import Foundation


// MARK: - CountryFetchingUseCase
protocol CountryFetchingUseCase {
    func fetchAllCountries() async throws -> [Country]
}

class DefaultCountryFetchingUseCase: CountryFetchingUseCase {
    private let networkService: NetworkService
    private let baseURL = "https://restcountries.com/v2/all"
    
    init(networkService: NetworkService = CachingNetworkService()) {
        self.networkService = networkService
    }
    
    func fetchAllCountries() async throws -> [Country] {
        try await networkService.fetch(from: baseURL)
    }
}

