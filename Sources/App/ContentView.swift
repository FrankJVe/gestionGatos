import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ExpenseViewModel()
    @StateObject private var settings = AppSettings()
    @State private var showingAddExpense = false
    
    var body: some View {
        TabView {
            DashboardView(viewModel: viewModel)
                .environmentObject(settings)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.pie.fill")
                }
            
            StatsView(viewModel: viewModel)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(viewModel: viewModel)
        }
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
