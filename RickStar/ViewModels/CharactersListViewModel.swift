//
//  CharactersListView.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation
import Combine
import RickMortyData
import NetworkKit
import UIKit

@MainActor
@Observable
final class CharactersListViewModel {
    
    private var connectivity = NetworkMonitor.shared
    private var currentName: String? = nil
    private(set) var items: [Character] = []
    private(set) var isLoading = false
    private var page = 1
    private var canLoadMore = true
    private let repo: CharacterRepository
    private let imageRepo: CharactersImageRepository
    private let router: Router
    private var bag = Set<AnyCancellable>()
    
    private let prefetchThreshold = 5
    private let searchThrottle: TimeInterval = 0.4   // 400 ms
    private var lastSearchTimestamp: Date?
    
    // MARK: - UI State
    var alertMessage: String?
    var imagesByURL: [URL: UIImage] = [:]
    
    init(repo: CharacterRepository,
         imageRepo: CharactersImageRepository,
         router: Router) {
        self.repo = repo
        self.imageRepo = imageRepo
        self.router = router
        
        connectivity.$isConnected
            .removeDuplicates()
            .filter { $0 }
            .sink { [weak self] _ in
                Task { [weak self] in
                    guard let self else { return }
                    do {
                        try await self.reloadFromScratch()
                    } catch {
                        self.alertMessage = (error as? LocalizedError)?.errorDescription ?? unexpectedErrorMessage
                    }
                }
            }
            .store(in: &bag)
    }

    func load() async throws {
        guard !isLoading, canLoadMore else { return }
        isLoading = true
        defer { isLoading = false }
        
        let pageData = try await repo.characters(page: page, name: currentName)
        items.append(contentsOf: pageData.results)
        canLoadMore = pageData.info.next != nil
        page += 1
    }

    private func reloadFromScratch() async throws {
        page = 1
        canLoadMore = true
        items.removeAll()
        try await load()
    }
    
    func prefetchIfNeeded(index: Int) {
        guard index >= items.count - prefetchThreshold,
              canLoadMore,
              !isLoading else { return }

        Task { [weak self] in
            guard let self = self else { return }
            do {
                try await self.load()
            } catch NetworkError.cancelled {
                debugPrint("request cancel")
            } catch {
                self.alertMessage = (error as? LocalizedError)?.errorDescription ?? unexpectedErrorMessage
            }
        }
    }
    
    func search(name: String) async throws {
        currentName = name.isEmpty ? nil : name
        page = 1
        canLoadMore = true
        items.removeAll()
        try await load()
    }
    
    func clearAll() {
        currentName = nil
        page = 1
        canLoadMore = true
        items.removeAll()
    }
    
    func loadImage(from url: URL) async throws {
        if imagesByURL[url] != nil { return }
        let image = try await imageRepo.loadImage(from: url)
        imagesByURL[url] = image
    }
    
    func showDetail(_ character: Character) {
        router.pushDetail(character)
    }
    
    // MARK: - View helpers (side‑effects isolated here)
    func onViewAppear() async {
        do {
            try await load()
        } catch {
            alertMessage = (error as? LocalizedError)?.errorDescription ?? unexpectedErrorMessage
        }
    }

    func onRowAppear(_ character: Character) async {
        if let idx = items.firstIndex(where: { $0.id == character.id }) {
            prefetchIfNeeded(index: idx)
        }
        do {
            try await loadImage(from: character.image)
        } catch {
            alertMessage = (error as? LocalizedError)?.errorDescription ?? unexpectedErrorMessage
        }
    }

    func handleSearchChange(_ text: String) async {
        if text.isEmpty {
            lastSearchTimestamp = nil
            do {
                clearAll()
                try await search(name: "")
            } catch {
                alertMessage = (error as? LocalizedError)?.errorDescription ?? unexpectedErrorMessage
            }
            return
        }
        
        let now = Date()
        if let last = lastSearchTimestamp,
           now.timeIntervalSince(last) < searchThrottle {
           return
        }
        lastSearchTimestamp = now
        
        do {
            clearAll()
            try await search(name: text)
        } catch {
            alertMessage = (error as? LocalizedError)?.errorDescription ?? unexpectedErrorMessage
        }
    }
}
