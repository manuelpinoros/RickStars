//
//  CharactersImageLocalDatasource.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 4/6/25.
//
import UIKit

public final class CharactersImageLocalDatasource {
    private let cache = NSCache<NSURL, UIImage>()

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
