import SwiftUI

final class HomeViewModel: ObservableObject {
    private let useCase: CountryFetchingUseCase
    private let locationManager: LocationManager
    
    @Published var countries: [Country] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Derived properties for the view
    @Published var searchText: String = ""
    @Published var userCountry: Country?
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries.filter { $0.name != "Israel" }
        }
        return countries.filter { country in
            country.name != "Israel" &&
            country.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var groupedCountries: [String: [Country]] {
        let filtered = filteredCountries
        return Dictionary(grouping: filtered) { $0.region }
    }
    
    init(useCase: CountryFetchingUseCase = DefaultCountryFetchingUseCase(),
         locationManager: LocationManager = LocationManager()) {
        self.useCase = useCase
        self.locationManager = locationManager
        
        Task { await loadCountries() }
        setupLocationUpdates()
    }
    
    private func setupLocationUpdates() {
        locationManager.requestLocation()
        
        Task {
            for await countryCode in locationManager.$currentCountryCode.values {
                guard let code = countryCode else { continue }
                await updateUserCountry(for: code)
            }
        }
    }
    
    @MainActor
    private func updateUserCountry(for countryCode: String) {
        userCountry = countries.first { country in
            country.alpha2Code.uppercased() == countryCode.uppercased()
        }
    }
    
    @MainActor
    func loadCountries() async {
        isLoading = true
        errorMessage = nil
        
        do {
            countries = try await useCase.fetchAllCountries()
        } catch let error as CountryFetchingError {
            switch error {
            case .invalidURL:
                errorMessage = "Invalid URL. Please try again later."
            case .networkError:
                errorMessage = "Network error. Please check your connection."
            case .decodingError:
                errorMessage = "Error processing data. Please try again later."
            }
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func refreshCountries() {
        Task { await loadCountries() }
    }
    
    func getPopulationText(for country: Country) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: country.population)) ?? String(country.population)
    }
}
