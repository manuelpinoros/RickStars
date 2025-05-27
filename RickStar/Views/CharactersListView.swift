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
    @State private var searchText: String = ""
    @Environment(Router.self) var router: Router
    var cache: MemoryImageCache = MemoryImageCache()

    var body: some View {
        List(vm.items, id: \.id) { character in
            CharacterRow(character: character, cache: cache)
                .task {
                    if let idx = vm.items.firstIndex(where: { $0.id == character.id }) {
                        vm.prefetchIfNeeded(index: idx)
                    }
                }
                .onTapGesture { router.pushDetail(character) }
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle(NSLocalizedString("RickStar", comment: ""))
        .overlay {
            if vm.isLoading && vm.items.isEmpty { ProgressView() }
        }
        .searchable(text: $searchText, prompt: "Search characters")
        .onSubmit(of: .search) {
            performSearch()
        }
        .onChange(of: searchText, { oldValue, newValue in
            if newValue.isEmpty {
                resetSearch()
            }
        })
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
        .task { await vm.load() }
    }
    
    // MARK: - Helpers
    private func performSearch() {
        vm.clearAll()
        cache.removeAll()
        Task { await vm.search(name: searchText) }
    }

    private func resetSearch() {
        vm.clearAll()
        cache.removeAll()
        Task { await vm.search(name: "") }
    }
}
