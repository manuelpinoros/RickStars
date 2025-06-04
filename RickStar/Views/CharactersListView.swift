//
//  CharactersListView.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI

struct CharactersListView: View {
    
    var vm: CharactersListViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                SearchBarView(searchText: $searchText)
                
                List(vm.items, id: \.id) { character in
                    CharacterRow(
                        character: character,
                        image: vm.imagesByURL[character.image]
                    )
                    .id(character.id)
                    .task {
                        if let idx = vm.items.firstIndex(where: { $0.id == character.id }) {
                            vm.prefetchIfNeeded(index: idx)
                        }
                        do {
                            try await vm.loadImage(from: character.image)
                        } catch {
                            vm.uiError = (error as? LocalizedError)?.errorDescription ?? "Error desconocido"
                        }
                    }
                    .onTapGesture { vm.showDetail(character) }
                }
                .characterListStyle()
                .overlay {
                    if vm.isLoading && vm.items.isEmpty { ProgressView() }
                }
                .onChange(of: searchText, { oldValue, newValue in
                    if newValue.isEmpty {
                        resetSearch()
                    }
                    else{
                        performSearch()
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
                .task {
                    do {
                        try await vm.load()
                    } catch {
                        //We will show the error with vm.uiError
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                CustomButton(
                    size: 65,
                    backgroundColor: .indigo.opacity(0.5),
                    selectedColor: .indigo,
                    iconColor:  .white,
                    icon: "arrow.up.circle.fill",
                    action: {
                        if let firstId = vm.items.first?.id {
                            proxy.scrollTo(firstId, anchor: .top)
                        }
                    },
                    borderColor:  .white.opacity(0.8),
                    borderWidth: 4
                )
                .padding([.trailing, .bottom])
            }
        }
        
    }
    
    // MARK: - Helpers
    private func performSearch() {
        vm.clearAll()
        Task {
            do { try await vm.search(name: searchText) }
            catch { vm.uiError = (error as? LocalizedError)?.errorDescription ?? "Error desconocido" }
        }
    }
    
    private func resetSearch() {
        vm.clearAll()
        Task {
            do { try await vm.search(name: "") }
            catch { vm.uiError = (error as? LocalizedError)?.errorDescription ?? "Error desconocido" }
        }
    }
}
