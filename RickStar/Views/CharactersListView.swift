//
//  CharactersListView.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//


import SwiftUI
import RickMortyDomain
import CacheKit

struct CharactersListView: View {
    @StateObject var vm: CharactersListViewModel
    @EnvironmentObject var router: Router
    private let cache: ImageCache = MemoryImageCache()

    var body: some View {
        List(vm.items.indices, id: \.self) { i in
            let c = vm.items[i]
            CharacterRow(character: c, cache: cache)
                .task { vm.prefetchIfNeeded(index: i) }
                .onTapGesture { router.pushDetail(c) }
        }
        .navigationTitle(NSLocalizedString("characters.title", comment: ""))
        .task { await vm.load() }
        .overlay {
            if vm.isLoading && vm.items.isEmpty { ProgressView() }
        }
        .alert("Error",
               isPresented: Binding<Bool>(
                 get: { vm.uiError != nil },
                 set: { if !$0 { vm.uiError = nil } }
               ),
               actions: {
                   Button("OK") { vm.uiError = nil }
               },
               message: {
                   Text(vm.uiError ?? "")
               })
    }
}

private struct CharacterRow: View {
    let character: Character
    let cache: ImageCache

    var body: some View {
        HStack {
            CachedAsyncImage(url: character.image, cache: cache) {
                Image(systemName: "person.crop.circle")
                    .frame(width: 56, height: 56)
            }
            VStack(alignment: .leading) {
                Text(character.name).font(.headline)
                Text(character.status).font(.subheadline)
            }
        }
    }
}
