import SwiftUI

struct LanguageSelectionView: View {
    @StateObject private var viewModel = LanguageSelectionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Button("English") {
                viewModel.setLanguage("en")
                dismiss()
            }
            .foregroundColor(viewModel.language == "en" ? .blue : .primary)
            
            Button("العربية") {
                viewModel.setLanguage("ar")
                dismiss()
            }
            .foregroundColor(viewModel.language == "ar" ? .blue : .primary)
        }
        .navigationTitle(String(localized: "Language"))
    }
} 
