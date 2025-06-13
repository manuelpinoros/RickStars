//
//  CharacterRepository.swift
//  RickMortyDomain
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import UIKit

public protocol CharacterRepository {
    func characters(page: Int) async throws -> CharacterPage
    func characters(page: Int, name: String?) async throws -> CharacterPage
}

public protocol CharactersImageRepository {
    func loadImage(from url: URL) async throws -> UIImage
}

public protocol CharacterImageSource{
    
    func imageFromSource(url: URL) async throws -> UIImage
    func imageToSource(_ image: UIImage, url: URL)
}
