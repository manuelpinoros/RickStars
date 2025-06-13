//
//  DefaultCharactersImageRepository.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 4/6/25.
//
import UIKit
import RickMortyDomain

public final class DefaultCharactersImageRepository: CharactersImageRepository {
    private let local: CharacterImageSource
    private let remote: CharacterImageSource
    
    public init(local: CharacterImageSource = CharactersImageLocalDatasource(),
                remote: CharacterImageSource = CharactersImageRemoteDatasource()) {
        self.local = local
        self.remote = remote
    }
    
    public func loadImage(from url: URL) async throws -> UIImage {
        do {
            return try await local.imageFromSource(url: url)
        } catch {                
            if (error as? DomainError) != DomainError.localResourceNotFound {
                throw error
            }
        }

        do {
            let downloaded = try await remote.imageFromSource(url: url)
            local.imageToSource(downloaded, url: url)
            return downloaded
        } catch {
            throw error
        }
    }

    private func isNotFound(_ error: Error) -> Bool {
        (error as NSError).code == NSFileReadNoSuchFileError
    }
}
