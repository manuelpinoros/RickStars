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
    
    var uiError: String?
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
                Task { await self?.reloadFromScratch() }
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

    private func reloadFromScratch() async {
        page = 1
        canLoadMore = true
        items.removeAll()
        do {
            try await load()
        } catch NetworkError.cancelled {
            debugPrint("request cancel")
        } catch {
            uiError = (error as? LocalizedError)?.errorDescription ?? "Error desconocido"
        }
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
                self.uiError = (error as? LocalizedError)?.errorDescription ?? "Error desconocido"
            }
        }
    }
    
    func search(name: String) async {
        currentName = name.isEmpty ? nil : name
        page = 1
        canLoadMore = true
        items.removeAll()
        do {
            try await load()
        } catch {
            uiError = (error as? LocalizedError)?.errorDescription ?? "Error desconocido"
        }
    }
    
    func clearAll() {
        currentName = nil
        page = 1
        canLoadMore = true
        items.removeAll()
    }
    
    func loadImage(from url: URL) async {
        if imagesByURL[url] != nil { return }
        do {
            let image = try await imageRepo.loadImage(from: url)
            imagesByURL[url] = image
        } catch {
            print("Error loading image: \(error)")
        }
    }
    
    func showDetail(_ character: Character) {
        router.pushDetail(character)
    }
}
