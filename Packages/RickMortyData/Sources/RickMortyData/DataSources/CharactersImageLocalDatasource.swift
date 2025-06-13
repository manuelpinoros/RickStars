//
//  CharactersImageLocalDatasource.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 4/6/25.
//
import UIKit
import RickMortyDomain

public final class CharactersImageLocalDatasource{

    private var cache = NSCache<NSURL, UIImage>()

    public init() {}

    public func imageFromCache(url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    public func saveImageToCache(_ image: UIImage, url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }

    public func removeAll() {
        cache.removeAllObjects()
    }
}

extension CharactersImageLocalDatasource: CharacterImageSource{

    public func imageFromSource(url: URL) async throws -> UIImage {
        guard let image = cache.object(forKey: url as NSURL)
                else {
            throw DomainError.localResourceNotFound
        }
        return image
    }
    
    public func imageToSource(_ image: UIImage, url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
