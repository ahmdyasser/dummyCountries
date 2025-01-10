import SwiftUI

struct LanguageSelectionView: View {
    @AppStorage("AppleLanguages") var language = UserDefaults.standard.string(forKey: "AppleLanguages") ?? "en"
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Button("English") {
                setLanguage("en")
            }
            .foregroundColor(language == "en" ? .blue : .primary)
            
            Button("العربية") {
                setLanguage("ar")
            }
            .foregroundColor(language == "ar" ? .blue : .primary)
        }
        .navigationTitle(String(localized: "Language"))
    }
    
    private func setLanguage(_ code: String) {
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        AppLogger.debug("Selected langauge update", category: .cache)
        dismiss()
    }
} 
