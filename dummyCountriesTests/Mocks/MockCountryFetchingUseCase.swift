import Foundation
@testable import dummyCountries

class MockCountryFetchingUseCase: CountryFetchingUseCase {
    var mockCountries: [Country] = []
    var shouldThrowError = false
    
    func fetchAllCountries() async throws -> [Country] {
        if shouldThrowError {
            throw CountryFetchingError.networkError(NSError(domain: "", code: -1))
        }
        return mockCountries
    }
} 