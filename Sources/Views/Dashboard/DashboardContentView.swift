import SwiftUI

struct DashboardContentView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Balance Card
            VStack(spacing: 8) {
                Text("Balance Total")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("S/ \(viewModel.totalBalance, specifier: "%.2f")")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(viewModel.totalBalance >= 0 ? .green : .red)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
            
            // Test Circle Card
            VStack {
                Text("Test Circle")
                    .font(.headline)
                Rectangle()
                    .fill(.red)
                    .frame(width: 100, height: 100)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
            
            // Recent Transactions
            VStack(alignment: .leading, spacing: 16) {
                Text("Últimos Movimientos")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(viewModel.expenses.prefix(5)) { expense in
                    HStack {
                        Image(systemName: expense.category.icon)
                            .foregroundColor(expense.category.color)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading) {
                            Text(expense.title)
                                .font(.subheadline)
                            Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("S/ \(expense.amount, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(expense.amount >= 0 ? .green : .red)
                    }
                    .padding(.horizontal)
                    
                    if expense.id != viewModel.expenses.prefix(5).last?.id {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DashboardContentView(viewModel: ExpenseViewModel())
}
