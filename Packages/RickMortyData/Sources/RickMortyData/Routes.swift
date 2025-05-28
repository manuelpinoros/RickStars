//
//  RickMortyRoute.swift
//  RickMortyData
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import Foundation
import NetworkKit
import RickMortyDomain

public enum RickMortyRoute {
    static let base = URL(string: "https://rickandmortyapi.com/api")!
    
    case characters(page: Int, name: String?)
    case multipleCharacters(ids: [Int])
    case location(id: Int)
    case locationSearch(name: String)
    case episodes(page: Int)
    case multipleEpisodes(ids: [Int])
    
    public var endpoint: Endpoint {
        switch self {
        case .characters(let page, let name):
            var query: [URLQueryItem] = [.init(name: "page", value: "\(page)")]
            if let name = name, !name.isEmpty {
                query.append(.init(name: "name", value: name))
            }
            return Endpoint(baseURL: Self.base, path: "character", query: query)
            
        case .multipleCharacters(let ids):
            let idList = ids.map(String.init).joined(separator: ",")
            return Endpoint(baseURL: Self.base, path: "character/\(idList)")
            
        case .location(let id):
            return Endpoint(baseURL: Self.base, path: "location/\(id)")
            
        case .locationSearch(let name):
            return Endpoint(baseURL: Self.base,
                            path: "location",
                            query: [.init(name: "name", value: name)])
            
        case .episodes(let page):
            return Endpoint(baseURL: Self.base,
                            path: "episode",
                            query: [URLQueryItem(name: "page", value: "\(page)")])
            
        case .multipleEpisodes(let ids):
            let idList = ids.map(String.init).joined(separator: ",")
            return Endpoint(baseURL: Self.base,
                            path: "episode/\(idList)")
        }
    }
}
