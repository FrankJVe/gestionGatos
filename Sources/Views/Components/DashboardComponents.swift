import SwiftUI

// Vista de la Tarjeta de Balance
struct BalanceCardView: View {
    let balance: Double
    let isPositive: Bool
    let percentage: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Balance Total")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("S/ \(balance, specifier: "%.2f")")
                .font(.system(size: 34, weight: .bold))
            
            HStack {
                Text("Este mes")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                    .foregroundColor(isPositive ? .green : .red)
                Text("\(percentage, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(isPositive ? .green : .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.white.opacity(0.3), radius: 4, x: 0, y: 0)
        .shadow(color: Color.white.opacity(0.2), radius: 8, x: 0, y: 0)
        .padding(.horizontal, 8)
    }
}

// Vista de Tarjeta de Transacción
struct TransactionCardView: View {
    let title: String
    let amount: Double
    let isIncome: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: isIncome ? "arrow.down.left" : "arrow.up.right")
                    .foregroundColor(isIncome ? .green : .red)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Text("S/ \(amount, specifier: "%.2f")")
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.white.opacity(0.3), radius: 4, x: 0, y: 0)
        .shadow(color: Color.white.opacity(0.2), radius: 8, x: 0, y: 0)
    }
}

// Vista de Fila de Transacción
struct TransactionRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Image(systemName: expense.category.icon)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(expense.category.color)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(expense.title)
                Text(expense.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("S/ \(expense.amount, specifier: "%.2f")")
                    .foregroundColor(expense.type == .income ? .green : .primary)
                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}

// Vista de Transacciones Recientes
struct RecentTransactionsListView: View {
    let expenses: [Expense]
    @ObservedObject var viewModel: ExpenseViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Movimientos Recientes")
                .font(.headline)
                .padding(.horizontal)
            
            if expenses.isEmpty {
                Text("No hay movimientos registrados")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(Array(expenses.prefix(5).enumerated()), id: \.element.id) { index, expense in
                    NavigationLink(destination: EditExpenseView(expense: expense, viewModel: viewModel)) {
                        TransactionRowView(expense: expense)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if index < expenses.prefix(5).count - 1 {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.white.opacity(0.3), radius: 4, x: 0, y: 0)
        .shadow(color: Color.white.opacity(0.2), radius: 8, x: 0, y: 0)
        .padding(.horizontal, 8)
    }
}

// Vista de Distribución de Gastos
struct ExpenseDistributionView: View {
    let expenses: [Expense]
    
    var body: some View {
        VStack {
            Text("Distribución por Categorías")
                .font(.headline)
            
            PieChartView(expenses: expenses)
                .frame(height: 200)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
