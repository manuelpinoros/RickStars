//
//  CharactersImageRemoteDatasource.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 4/6/25.
//
import UIKit
import RickMortyDomain

public final class CharactersImageRemoteDatasource{
    
    public init() {}

    public func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        return image
    }
}

extension CharactersImageRemoteDatasource: CharacterImageSource{
    
    public func imageFromSource(url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw DomainError.resourceNotFound
        }
        return image
    }
    
    public func imageToSource(_ image: UIImage, url: URL) {}
}
