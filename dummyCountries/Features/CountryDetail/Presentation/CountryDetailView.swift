import SwiftUI

struct CountryDetailView: View {
    let country: Country
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Flag Image
                CachedAsyncImage(url: country.flags.png)
                CountryInfo(country: country)
                .padding()
            }
        }
        .navigationTitle(country.name)
    }
    
}

private struct CountryInfo: View {
    let country: Country
    @StateObject private var viewModel = CountryDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Country Information
            InfoRow(title: "Capital", value: country.capital ?? "N/A")
            InfoRow(title: "Region", value: country.region)
            InfoRow(title: "Population", value: viewModel.formatPopulation(country.population))
            
            // Currencies
            if let currencies = country.currencies {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Currencies")
                        .font(.headline)
                    
                    ForEach(currencies, id: \.code) { currency in
                        HStack {
                            Text(currency.name)
                            if let symbol = currency.symbol {
                                Text("(\(symbol))")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
} 
