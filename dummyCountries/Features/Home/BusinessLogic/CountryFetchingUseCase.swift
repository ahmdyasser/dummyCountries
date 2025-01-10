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

class DefaultNetworkService: NetworkService {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetch<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw CountryFetchingError.invalidURL
        }
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch let error as DecodingError {
            throw CountryFetchingError.decodingError(error)
        } catch {
            throw CountryFetchingError.networkError(error)
        }
    }
}

// MARK: - CountryFetchingUseCase
protocol CountryFetchingUseCase {
    func fetchAllCountries() async throws -> [Country]
}

class DefaultCountryFetchingUseCase: CountryFetchingUseCase {
    private let networkService: NetworkService
    private let baseURL = "https://restcountries.com/v2/all"
    
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
    
    func fetchAllCountries() async throws -> [Country] {
        try await networkService.fetch(from: baseURL)
    }
}

