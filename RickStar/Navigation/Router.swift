//
//  Router.swift
//  RickStar
//
//  Created by Manuel Pino Ros on 27/5/25.
//
import SwiftUI
import RickMortyDomain

@MainActor
@Observable
final class Router {
    
    var path = NavigationPath()
    func pushDetail(_ character: Character) { path.append(Route.detail(character)) }
    enum Route: Hashable {
        case detail(Character)
    }
}
