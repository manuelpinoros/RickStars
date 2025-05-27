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
    
    @State var vm: CharactersListViewModel
    @Environment(Router.self) var router: Router
    private let cache: ImageCache = MemoryImageCache()

    var body: some View {
        List(vm.items.indices, id: \.self) { i in
            let c = vm.items[i]
            CharacterRow(character: c, cache: cache)
                .task { vm.prefetchIfNeeded(index: i) }
                .onTapGesture { router.pushDetail(c) }
        }
        .listRowSeparator(.hidden, edges: .all)
        .navigationTitle(NSLocalizedString("RickStar", comment: ""))
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
