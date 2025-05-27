//
//  DefaultCharacterRepository.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation
import NetworkKit
import RickMortyDomain

public final class DefaultCharacterRepository: CharacterRepository {
  private let client: NetworkClient
  public init(client: NetworkClient = URLSessionClient()) {
    self.client = client
  }

  public func characters(page: Int) async throws -> CharacterPage {
    // without filters:
    let ep = RickMortyRoute.characters(page: page).endpoint
    return try await client.request(ep)
  }
}
