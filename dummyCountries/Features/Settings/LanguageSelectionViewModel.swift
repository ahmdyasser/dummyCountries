import SwiftUI

class LanguageSelectionViewModel: ObservableObject {
    @AppStorage("AppleLanguages") var language = UserDefaults.standard.string(forKey: "AppleLanguages") ?? "en"
    
    func setLanguage(_ code: String) {
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        AppLogger.debug("Selected language update", category: .cache)
    }
} 