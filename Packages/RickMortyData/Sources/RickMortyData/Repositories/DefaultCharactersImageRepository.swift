//
//  DefaultCharactersImageRepository.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 4/6/25.
//
import UIKit

public final class DefaultCharactersImageRepository: CharactersImageRepository {
    private let local: CharactersImageLocalDatasource
    private let remote: CharactersImageRemoteDatasource

    public init(local: CharactersImageLocalDatasource = .init(),
                remote: CharactersImageRemoteDatasource = .init()) {
        self.local = local
        self.remote = remote
    }

    public func loadImage(from url: URL) async throws -> UIImage {
        if let cached = local.imageFromCache(url: url) {
            return cached
        }
    
        let downloaded = try await remote.downloadImage(from: url)
    
        local.saveImageToCache(downloaded, url: url)
        return downloaded
    }
}
