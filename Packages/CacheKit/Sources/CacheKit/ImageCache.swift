//
//  ImageCache.swift
//  CacheKit
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import UIKit

public protocol ImageCache: AnyObject {
    subscript(_ url: URL) -> UIImage? { get set }
}

public final class MemoryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    public init() {}
    
    public subscript(_ url: URL) -> UIImage? {
        get { cache.object(forKey: url as NSURL) }
        set {
            if let img = newValue {
                cache.setObject(img, forKey: url as NSURL)
            } else {
                cache.removeObject(forKey: url as NSURL)
            }
        }
    }
}
