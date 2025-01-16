import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @EnvironmentObject var settings: AppSettings
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    BalanceCardView(
                        balance: viewModel.totalBalance,
                        isPositive: viewModel.balanceIsPositive,
                        percentage: viewModel.balancePercentage
                    )
                    
                    HStack(spacing: 8) {
                        TransactionCardView(
                            title: "Ingresos",
                            amount: viewModel.totalIncome,
                            isIncome: true
                        )
                        
                        TransactionCardView(
                            title: "Gastos",
                            amount: viewModel.totalExpenses,
                            isIncome: false
                        )
                    }
                    .padding(.horizontal, 8)
                    
                    ExpenseDistributionView(expenses: viewModel.currentMonthExpenses)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.white.opacity(0.3), radius: 4, x: 0, y: 0)
                        .shadow(color: Color.white.opacity(0.2), radius: 8, x: 0, y: 0)
                        .padding(.horizontal, 8)
                    
                    RecentTransactionsListView(expenses: viewModel.currentMonthExpenses, viewModel: viewModel)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Mi Dinero")
            .navigationBarItems(
                leading: HStack(spacing: 16) {
                    Button(action: { settings.isDarkMode.toggle() }) {
                        Image(systemName: settings.isDarkMode ? "moon.fill" : "moon")
                            .font(.title2)
                            .foregroundColor(.indigo)
                    }
                },
                trailing: Button(action: { showingAddExpense = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.indigo)
                }
            )
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(viewModel: viewModel)
        }
    }
}
