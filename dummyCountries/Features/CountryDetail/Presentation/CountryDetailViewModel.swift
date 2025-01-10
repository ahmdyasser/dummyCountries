import Foundation

class CountryDetailViewModel: ObservableObject {
    func formatPopulation(_ population: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: population)) ?? String(population)
    }
} 