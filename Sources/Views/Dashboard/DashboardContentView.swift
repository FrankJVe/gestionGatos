import SwiftUI

struct RecentTransactionRow: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Image(systemName: expense.category.icon)
                .foregroundColor(expense.category.color)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(expense.title)
                    .font(.subheadline)
                HStack {
                    Text(expense.category.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(formatDate(expense.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text(expense.type == .expense ? "-" : "+")
                .foregroundColor(expense.type == .expense ? .red : .green) +
            Text("S/ \(abs(expense.amount), specifier: "%.2f")")
                .foregroundColor(expense.type == .expense ? .red : .green)
        }
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
}

struct RecentTransactionsView: View {
    let expenses: [Expense]
    let viewModel: ExpenseViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Movimientos del Mes")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(expenses.prefix(5).enumerated().map({ $0 }), id: \.element.id) { index, expense in
                if index != 0 {
                    Divider()
                }
                RecentTransactionRow(expense: expense)
            }
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct DashboardContentView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                MonthSelectorView(viewModel: viewModel, selectedDate: $viewModel.selectedDate)
                
                // Balance Card
                BalanceCardView(
                    balance: viewModel.totalBalance,
                    isPositive: viewModel.totalBalance >= 0,
                    percentage: abs(viewModel.monthlyChangePercentage)
                )
                
                // Recent Transactions
                RecentTransactionsView(expenses: viewModel.currentMonthExpenses, viewModel: viewModel)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    DashboardContentView(viewModel: ExpenseViewModel())
}
