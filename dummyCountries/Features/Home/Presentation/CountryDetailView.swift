import SwiftUI

struct CountryDetailView: View {
    let country: Country
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Flag Image
                AsyncImage(url: URL(string: country.flags.png)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 16) {
                    // Country Information
                    InfoRow(title: "Capital", value: country.capital ?? "N/A")
                    InfoRow(title: "Region", value: country.region)
                    InfoRow(title: "Population", value: formatPopulation(country.population))
                    
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
                .padding()
            }
        }
        .navigationTitle(country.name)
    }
    
    private func formatPopulation(_ population: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: population)) ?? String(population)
    }
}

struct InfoRow: View {
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
