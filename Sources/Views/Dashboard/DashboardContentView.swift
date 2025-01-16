import SwiftUI

struct DashboardContentView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Month Title
            Text(monthYearString())
                .font(.headline)
                .foregroundColor(.gray)
            
            // Balance Card
            VStack(spacing: 8) {
                Text("Balance del Mes")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("S/ \(viewModel.totalBalance, specifier: "%.2f")")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(viewModel.totalBalance >= 0 ? .green : .red)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("Ingresos")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("S/ \(viewModel.totalIncome, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    
                    VStack {
                        Text("Gastos")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("S/ \(viewModel.totalExpenses, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
            
            // Recent Transactions
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Movimientos del Mes")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if viewModel.currentMonthExpenses.isEmpty {
                        Text("No hay movimientos este mes")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(viewModel.currentMonthExpenses.prefix(5)) { expense in
                            NavigationLink(destination: EditExpenseView(expense: expense, viewModel: viewModel)) {
                                HStack {
                                    Image(systemName: expense.category.icon)
                                        .foregroundColor(expense.category.color)
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading) {
                                        Text(expense.title)
                                            .font(.subheadline)
                                        Text(expense.category.rawValue.capitalized)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(expense.type == .expense ? "-" : "+")
                                        .foregroundColor(expense.type == .expense ? .red : .green) +
                                    Text("S/ \(abs(expense.amount), specifier: "%.2f")")
                                        .foregroundColor(expense.type == .expense ? .red : .green)
                                }
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
    
    private func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: Date()).capitalized
    }
}

#Preview {
    DashboardContentView(viewModel: ExpenseViewModel())
}
