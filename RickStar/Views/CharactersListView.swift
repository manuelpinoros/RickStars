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

private struct CharacterRow: View {
    let character: Character
    let cache: ImageCache

    var body: some View {
        HStack {
            CachedAsyncImage(url: character.image, cache: cache) {
                Image(systemName: "person.crop.circle")
                    .frame(width: 100, height: 100)
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(CharacterStatus(rawValue: character.status)?.statusColor ?? .green,
                                lineWidth: 4)
            )
            
            
            
            VStack(alignment: .leading) {
               // Group(){
                    Text(character.name).font(.headline)
                        .padding(.top, 8)
                HStack(alignment: .top,spacing: 5){
                        Text("Origin: ").font(.subheadline)
                        Text(character.origin.name)
                            .font(.subheadline)
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                
                    HStack(spacing: 5){
                        Text("Specie: ").font(.subheadline)
                        Text(character.species).font(.subheadline)
                    }
                
                //if character.status == CharacterStatus.dead.rawValue {
                    HStack(alignment: .top,spacing: 5){
                            Text("Last seen: ").font(.subheadline)
                            Text(character.location.name)
                                .font(.subheadline)
                                .lineLimit(2)
                                .truncationMode(.tail)
                        }
                //}
                //}
                
                Spacer()
                
            }
            .padding(.leading, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.indigo.opacity(0.5)))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.indigo, lineWidth: 2)
        )
        .padding(.vertical, 4)
    }
}
