import Testing
@testable import dummyCountries

struct CachingNetworkServiceTests {
    @Test
    func invalidURLThrowsError() async throws {
        // Given
        let sut = CachingNetworkService(cacheSize: 1024 * 1024)
        let invalidURL = "\\invalid/url"
        
        // When/Then
        do {
            let _: [Country] = try await sut.fetch(from: invalidURL)
            #expect(false, "Expected error for invalid URL")
        } catch is CountryFetchingError {
            // Success
            #expect(true)
        } catch {
            #expect(false, "Wrong error type")
        }
    }
} 