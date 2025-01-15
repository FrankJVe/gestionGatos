import SwiftUI

// Vista de la Tarjeta de Balance
struct BalanceCardView: View {
    let balance: Double
    let monthlyComparison: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Balance Total")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("S/ \(balance, specifier: "%.2f")")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(balance >= 0 ? .green : .red)
            
            HStack {
                Image(systemName: monthlyComparison >= 0 ? "arrow.up.right" : "arrow.down.right")
                Text("\(abs(monthlyComparison), specifier: "%.1f")% vs mes anterior")
                    .font(.caption)
            }
            .foregroundColor(monthlyComparison >= 0 ? .green : .red)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

// Vista de Tarjeta de Transacción
struct TransactionCardView: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
            }
            
            Text("S/ \(amount, specifier: "%.2f")")
                .font(.title3)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

// Vista de Distribución de Gastos
struct ExpenseDistributionView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Distribución de Gastos")
                .font(.headline)
                .padding(.horizontal)
            
            // TODO: Implementar gráfico de distribución
            Text("Gráfico en desarrollo")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

// Vista de Transacciones Recientes
struct RecentTransactionsView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    
    var recentTransactions: [Expense] {
        viewModel.expenses
            .sorted { $0.date > $1.date }
            .prefix(5)
            .map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Últimos Movimientos")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(recentTransactions) { expense in
                TransactionRowView(expense: expense)
                    .padding(.horizontal)
                
                if expense.id != recentTransactions.last?.id {
                    Divider()
                        .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

// Vista de Fila de Transacción
struct TransactionRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Image(systemName: expense.type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                .foregroundColor(expense.type == .income ? .green : expense.category.color)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.body)
                Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("S/ \(expense.amount, specifier: "%.2f")")
                .font(.body)
                .foregroundColor(expense.type == .income ? .green : .primary)
        }
    }
}
