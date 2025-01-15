import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    
    var body: some View {
        ScrollView {
            DashboardContentView(viewModel: viewModel)
                .padding(.vertical)
        }
    }
}

struct DashboardContentView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.colorScheme) private var colorScheme
    
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
            .padding(.horizontal)
            
            // Gráfico de Categorías
            VStack {
                Text("Distribución por Categorías")
                    .font(.headline)
                
                PieChartView(expenses: viewModel.expenses)
                    .frame(height: 200)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.horizontal)
            
            // Últimos Movimientos
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
            .padding(.horizontal)
        }
    }
}

struct PieChartView: View {
    let expenses: [Expense]
    
    private var expensesByCategory: [Expense.Category: Double] {
        var result: [Expense.Category: Double] = [:]
        for expense in expenses where expense.type == .expense {
            result[expense.category, default: 0] += expense.amount
        }
        return result
    }
    
    private var totalExpenses: Double {
        expensesByCategory.values.reduce(0, +)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                ForEach(Array(expensesByCategory.keys.enumerated()), id: \.element) { index, category in
                    let value = expensesByCategory[category] ?? 0
                    let percentage = value / totalExpenses
                    let startAngle = getStartAngle(for: index)
                    let endAngle = startAngle + percentage * 360
                    
                    Path { path in
                        path.move(to: center)
                        path.addArc(
                            center: center,
                            radius: radius,
                            startAngle: .degrees(startAngle - 90),
                            endAngle: .degrees(endAngle - 90),
                            clockwise: false
                        )
                        path.closeSubpath()
                    }
                    .fill(category.color)
                }
            }
        }
    }
    
    private func getStartAngle(for index: Int) -> Double {
        var startAngle = 0.0
        for i in 0..<index {
            let category = Array(expensesByCategory.keys)[i]
            let value = expensesByCategory[category] ?? 0
            startAngle += (value / totalExpenses) * 360
        }
        return startAngle
    }
}

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(viewModel: ExpenseViewModel())
    }
}
#endif
