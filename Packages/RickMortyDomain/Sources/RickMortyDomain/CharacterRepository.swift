//
//  CharacterRepository.swift
//  RickMortyDomain
//
//  Created by Manuel Pino Ros on 27/5/25.
//

public protocol CharacterRepository {
    func characters(page: Int) async throws -> CharacterPage
    
    func characters(page: Int, name: String?) async throws -> CharacterPage
}
