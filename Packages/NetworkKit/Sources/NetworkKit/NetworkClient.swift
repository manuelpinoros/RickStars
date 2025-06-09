//
//  NetworkClient.swift
//  NetworkKit
//
//  Created by Manuel Pino Ros on 27/5/25.
//

import Foundation

public protocol NetworkClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

public struct Endpoint {
  public let baseURL: URL
  public let path: String
  public var query: [URLQueryItem] = []
  
  public init(baseURL: URL, path: String, query: [URLQueryItem] = []) {
    self.baseURL = baseURL
    self.path = path
    self.query = query
  }
  
  public var urlRequest: URLRequest {
    var comps = URLComponents(
      url: baseURL.appendingPathComponent(path),
      resolvingAgainstBaseURL: false
    )!
    comps.queryItems = query.isEmpty ? nil : query
    return URLRequest(url: comps.url!)
  }
}

public final class URLSessionClient: NetworkClient {
    private let session: URLSession
    public init(session: URLSession = .shared) { self.session = session }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        do {
            let (data, resp) = try await session.data(for: endpoint.urlRequest)
            guard let http = resp as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard 200..<300 ~= http.statusCode else {
                throw NetworkError.badStatusCode(http.statusCode)
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch is CancellationError {
            throw NetworkError.cancelled
        } catch let urlErr as URLError {
            if urlErr.code == .cancelled {
                throw NetworkError.cancelled
            }
            throw NetworkError.urlError(urlErr)
        } catch let netErr as NetworkError {
            throw netErr
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}

