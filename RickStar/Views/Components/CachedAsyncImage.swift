//
//  CachedAsyncImage.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import CacheKit

struct CachedAsyncImage<Placeholder: View>: View {

    @State private var image: UIImage?
    
    let url: URL
    let placeholder: Placeholder
    let imageWidth: CGFloat = 100
    let imageHeight: CGFloat = 100
    var cache: ImageCache
    
    init(url: URL,
         cache: ImageCache,
         @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.cache = cache
        self.placeholder = placeholder()
        _image = State(initialValue: cache[url])
    }
    
    var body: some View {
        content
            .task { await load() }
    }
    
    @ViewBuilder
    private var content: some View {
        if let uiImage = image {
            Image(uiImage: uiImage)
                .resizable()
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(Circle())
        } else {
            placeholder
        }
    }
    
    private func load() async {
        if image != nil { return }
        if let (data, _) = try? await URLSession.shared.data(from: url),
           let ui = UIImage(data: data) {
            cache[url] = ui
            await MainActor.run { image = ui }
        }
    }
}
