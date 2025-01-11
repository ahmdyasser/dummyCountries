import Testing
@testable import dummyCountries

struct HomeViewModelTests {
    @Test
    func filteredCountriesExcludesIsrael() async throws {
        // Given
        let mockUseCase = MockCountryFetchingUseCase()
        let viewModel = HomeViewModel(useCase: mockUseCase)
        viewModel.countries = [
            Country(name: "Egypt", capital: "Cairo", region: "Africa", population: 100000000, 
                   flags: Flags(png: "url", svg: "url"), currencies: [], alpha2Code: "EG"),
            Country(name: "Israel", capital: "Jerusalem", region: "Asia", population: 9000000, 
                   flags: Flags(png: "url", svg: "url"), currencies: [], alpha2Code: "IL")
        ]
        
        // When
        let filtered = viewModel.filteredCountries
        
        // Then
        #expect(filtered.count == 1)
        #expect(filtered.first?.name == "Egypt")
    }
    
    @Test
    func searchFiltering() async throws {
        // Given
        let mockUseCase = MockCountryFetchingUseCase()
        let viewModel = HomeViewModel(useCase: mockUseCase)
        viewModel.countries = [
            Country(name: "Egypt", capital: "Cairo", region: "Africa", population: 100000000, 
                   flags: Flags(png: "url", svg: "url"), currencies: [], alpha2Code: "EG"),
            Country(name: "Ethiopia", capital: "Addis Ababa", region: "Africa", population: 100000000, 
                   flags: Flags(png: "url", svg: "url"), currencies: [], alpha2Code: "ET")
        ]
        
        // When
        viewModel.searchText = "Egy"
        
        // Then
        #expect(viewModel.filteredCountries.count == 1)
        #expect(viewModel.filteredCountries.first?.name == "Egypt")
    }
    
    @Test
    func groupedCountries() async throws {
        // Given
        let mockUseCase = MockCountryFetchingUseCase()
        let viewModel = HomeViewModel(useCase: mockUseCase)
        viewModel.countries = [
            Country(name: "Egypt", capital: "Cairo", region: "Africa", population: 100000000, 
                   flags: Flags(png: "url", svg: "url"), currencies: [], alpha2Code: "EG"),
            Country(name: "Saudi Arabia", capital: "Riyadh", region: "Asia", population: 35000000, 
                   flags: Flags(png: "url", svg: "url"), currencies: [], alpha2Code: "SA")
        ]
        
        // When
        let grouped = viewModel.groupedCountries
        
        // Then
        #expect(grouped.keys.count == 2)
        #expect(grouped["Africa"]?.count == 1)
        #expect(grouped["Asia"]?.count == 1)
    }
} 