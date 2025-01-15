import SwiftUI

@main
struct GestionGastosApp: App {
    @StateObject private var viewModel = ExpenseViewModel()
    @StateObject private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
    }
}
