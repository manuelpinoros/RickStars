//
//  RickStarApp.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//

import SwiftUI
import RickMortyData

@main
struct RickStarApp: App {
    
    private let repo = DefaultCharacterRepository()
    private let imageRepo = DefaultCharactersImageRepository()
    @State private var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                CharactersListView(vm: .init(repo: repo,
                                             imageRepo: imageRepo,
                                             router: router))
                    .navigationDestination(for: Router.Route.self) { route in
                        switch route {
                        case .detail(let character):
                            CharacterDetailView(character: character)
                        }
                    }
            }
        }
    }
}
