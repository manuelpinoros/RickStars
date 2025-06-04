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

    func load() async {
        guard !isLoading, canLoadMore else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let pageData = try await repo.characters(page: page, name: currentName)
            items += pageData.results
            canLoadMore = pageData.info.next != nil
            page += 1
            return
        } catch NetworkError.cancelled {
            return  //Network client cancell
        } catch {
            uiError = (error as? LocalizedError)?.errorDescription ?? "Error desconocido"
        }
    }

    private func reloadFromScratch() async {
        page = 1
        canLoadMore = true
        items.removeAll()
        await load()
    }
    
    func prefetchIfNeeded(index: Int) {
        guard index >= items.count - 5,
              canLoadMore,
              !isLoading else { return }

        Task.detached(priority: .utility) { [weak self] in
            await self?.load()
        }
    }
    
    func search(name: String) async {
        currentName = name.isEmpty ? nil : name
        page = 1
        canLoadMore = true
        items.removeAll()
        await load()
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
