//
//  CachingNetworkService.swift
//  dummyCountries
//
//  Created by Ahmad Yasser on 10/01/2025.
//

import Foundation

// MARK: - CountryFetchingError
enum CountryFetchingError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

// MARK: - Country Model
struct Country: Codable {
    
    let name: String
    let capital: String?
    let region: String
    let population: Int
    let flags: Flags
    let currencies: [Currency]?
    let alpha2Code: String
}

struct Flags: Codable {
    let png: String
    let svg: String
}

struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String?
}

// MARK: - NetworkService
protocol NetworkService {
    func fetch<T: Decodable>(from urlString: String) async throws -> T
}

class CachingNetworkService: NetworkService {
    private let cache: URLCache
    private let session: URLSession
    
    init(cacheSize: Int = 50 * 1024 * 1024) { // 50MB cache
        let config = URLSessionConfiguration.default
        cache = URLCache(memoryCapacity: cacheSize / 2,
                        diskCapacity: cacheSize,
                        diskPath: "countries_cache")
        config.urlCache = cache
        config.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: config)
    }
    
    func fetch<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw CountryFetchingError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Store response in cache if it's valid
            if let httpResponse = response as? HTTPURLResponse,
               200...299 ~= httpResponse.statusCode {
                cache.storeCachedResponse(
                    CachedURLResponse(response: response, data: data),
                    for: request
                )
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let cachedResponse = cache.cachedResponse(for: request) {
                return try JSONDecoder().decode(T.self, from: cachedResponse.data)
            }
            throw CountryFetchingError.networkError(error)
        }
    }
}
