//
//  HomeView.swift
//  dummyCountries
//
//  Created by Ahmad Yasser on 09/01/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var removedCountries: Set<String> = []
    @State private var favoriteCountries: Set<String> = []
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(error: error, onRetry: viewModel.refreshCountries)
                } else {
                    CountryListView(
                        viewModel: viewModel,
                        removedCountries: $removedCountries,
                        favoriteCountries: $favoriteCountries
                    )
                }
            }
            .navigationTitle("Countries")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: LanguageSelectionView()) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

// MARK: - Loading View
private struct LoadingView: View {
    var body: some View {
        ProgressView("Loading countries...")
    }
}

// MARK: - Error View
private struct ErrorView: View {
    let error: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(error)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
            
            Button("Try Again", action: onRetry)
                .buttonStyle(.bordered)
        }
    }
}

// MARK: - Country List View
private struct CountryListView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var removedCountries: Set<String>
    @Binding var favoriteCountries: Set<String>
    
    var body: some View {
        List {
            if let userCountry = viewModel.userCountry {
                UserLocationSection(country: userCountry)
            }
            
            if !favoriteCountries.isEmpty {
                FavoritesSection(
                    viewModel: viewModel,
                    favoriteCountries: $favoriteCountries
                )
            }
            
            RegionsSection(
                viewModel: viewModel,
                removedCountries: $removedCountries,
                favoriteCountries: $favoriteCountries
            )
        }
        .searchable(text: $viewModel.searchText, prompt: "Search countries")
        .refreshable {
            await viewModel.loadCountries()
        }
    }
}

// MARK: - User Location Section
private struct UserLocationSection: View {
    let country: Country
    
    var body: some View {
        Section("Your Location") {
            NavigationLink(destination: CountryDetailView(country: country)) {
                CountryRow(country: country)
            }
        }
    }
}

// MARK: - Regions Section
private struct RegionsSection: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var removedCountries: Set<String>
    @Binding var favoriteCountries: Set<String>
    
    var body: some View {
        ForEach(Array(viewModel.groupedCountries.keys.sorted()), id: \.self) { region in
            Section(header: Text(region)) {
                CountriesList(
                    countries: viewModel.groupedCountries[region] ?? [],
                    removedCountries: $removedCountries,
                    favoriteCountries: $favoriteCountries
                )
            }
        }
    }
}

// MARK: - Favorites Section
private struct FavoritesSection: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var favoriteCountries: Set<String>
    
    var body: some View {
        Section("Favorites") {
            ForEach(viewModel.countries.filter { favoriteCountries.contains($0.name) }, id: \.name) { country in
                NavigationLink(destination: CountryDetailView(country: country)) {
                    CountryRow(country: country)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                            favoriteCountries.remove(country.name)
                    } label: {
                        Label("Remove", systemImage: "star.slash")
                    }
                }
            }
        }
    }
}

// MARK: - Countries List
private struct CountriesList: View {
    let countries: [Country]
    @Binding var removedCountries: Set<String>
    @Binding var favoriteCountries: Set<String>
    @State private var showMaxFavoritesAlert = false
    
    var body: some View {
        ForEach(countries, id: \.name) { country in
            if !removedCountries.contains(country.name) {
                NavigationLink(destination: CountryDetailView(country: country)) {
                    CountryRow(country: country)
                }
                .swipeActions(edge: .trailing) {
                    if !favoriteCountries.contains(country.name) {
                        Button {
                            withAnimation {
                                if favoriteCountries.count < 5 {
                                    favoriteCountries.insert(country.name)
                                } else {
                                    showMaxFavoritesAlert = true
                                }
                            }
                        } label: {
                            Label("Favorite", systemImage: "star")
                        }
                        .tint(.yellow)
                    }
                    
                    Button(role: .destructive) {
                        removedCountries.insert(country.name)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
        }
        .alert("Maximum Favorites Reached", isPresented: $showMaxFavoritesAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can only add up to 5 favorite countries. Please remove a favorite country before adding a new one.")
        }
    }
}

struct CountryRow: View {
    let country: Country
    
    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(url: country.flags.png)
                .frame(width: 60, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(country.name)
                    .font(.headline)
                
                if let capital = country.capital {
                    Text(capital)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HomeView()
}
