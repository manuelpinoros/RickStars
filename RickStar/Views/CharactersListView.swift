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
                List(vm.items, id: \.id) { rickCharacter in
                    CharacterRow(
                        rickCharacter: rickCharacter,
                        image: vm.imagesByURL[rickCharacter.image]
                    )
                    .id(rickCharacter.id)
                    .task { await vm.onRowAppear(rickCharacter) }
                    .onTapGesture { vm.showDetail(rickCharacter) }
                }
                .characterListStyle()
                .overlay {
                    if vm.isLoading && vm.items.isEmpty { ProgressView() }
                }
                .onChange(of: searchText) { _, newValue in
                    Task { await vm.handleSearchChange(newValue) }
                }
                .alert("Error",
                       isPresented: Binding(
                        get: { vm.alertMessage != nil },
                        set: { if !$0 { vm.alertMessage = nil } }
                       ),
                       actions: {
                    Button("OK", role: .cancel) { vm.alertMessage = nil }
                },
                       message: {
                    Text(vm.alertMessage ?? "")
                })
                .task { await vm.onViewAppear() }
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
    
}
