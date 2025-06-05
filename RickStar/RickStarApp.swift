//
//  RickStarApp.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
// RickStarApp.swift
import SwiftUI
import RickMortyData

@main
struct RickStarApp: App {
    @State private var router: Router
    @State private var characterListVM: CharactersListViewModel

    init() {
        let router = Router()
        _router = .init(initialValue: router)
        _characterListVM = .init(
            initialValue: CharactersListViewModel(
                repo: DefaultCharacterRepository(),
                imageRepo: DefaultCharactersImageRepository(),
                router: router
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                CharactersListView(vm: characterListVM)
                    .navigationDestination(for: Router.Route.self) { route in
                        switch route {
                        case .detail(let rickCharacter):
                            CharacterDetailView(rickCharacter: rickCharacter)
                        }
                    }
            }
        }
    }
}
