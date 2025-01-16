import SwiftUI

// MARK: - Componentes auxiliares
struct MonthSelectorView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            Text(monthYearString(from: selectedDate))
                .foregroundColor(.gray)
            Spacer()
            Menu {
                ForEach(viewModel.availableMonthYears, id: \.self) { date in
                    Button(monthYearString(from: date)) {
                        selectedDate = date
                    }
                }
            } label: {
                HStack {
                    Text("Mes")
                    Image(systemName: "chevron.down")
                }
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
            }
        }
        .padding(.horizontal)
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
}

struct MonthlyBarChartView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(["mar", "abr", "may", "jun", "jul", "ago"], id: \.self) { month in
                        VStack(spacing: 4) {
                            Spacer()
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 20, height: 100)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.red.opacity(0.3))
                                .frame(width: 20, height: 50)
                            Text(month)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(height: 160)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct FinancialSummaryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                Text("Ingresos")
                Spacer()
                Text("S/ 625,48")
                    .fontWeight(.medium)
            }
            
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                Text("Gastos")
                Spacer()
                Text("S/ 2327,07")
                    .fontWeight(.medium)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                        
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: geometry.size.width * 0.39, height: 4)
                    }
                }
                .frame(height: 4)
                
                Text("39% de S/ 5964 previstos")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text("Neto")
                .foregroundColor(.gray)
            Text("S/ -1701,59")
                .fontWeight(.medium)
        }
        .padding(.horizontal)
    }
}

struct TabsView: View {
    @Binding var selectedTab: Int
    let tabs: [String]
    
    var body: some View {
        HStack {
            ForEach(tabs.indices, id: \.self) { index in
                Button(action: { selectedTab = index }) {
                    Text(tabs[index])
                        .foregroundColor(selectedTab == index ? .primary : .gray)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedTab == index ?
                                Color.gray.opacity(0.2) :
                                Color.clear
                        )
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct CategoryListView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    
    var sortedCategories: [(category: Expense.Category, amount: Double)] {
        viewModel.expensesByCategory
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(sortedCategories, id: \.category) { item in
                HStack {
                    Image(systemName: item.category.icon)
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(item.category.color)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(item.category.rawValue)
                            .font(.system(.body))
                        Text("\(viewModel.expenses.filter { $0.category == item.category }.count) movimientos")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("S/ \(item.amount, specifier: "%.2f")")
                            .fontWeight(.medium)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 4)
                                
                                Rectangle()
                                    .fill(item.category.color)
                                    .frame(width: geometry.size.width * CGFloat(item.amount/viewModel.totalExpenses), height: 4)
                            }
                        }
                        .frame(width: 60, height: 4)
                    }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TransactionListView: View {
    let expenses: [Expense]
    let type: Expense.TransactionType
    @ObservedObject var viewModel: ExpenseViewModel
    
    var filteredExpenses: [Expense] {
        expenses.filter { $0.type == type }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if filteredExpenses.isEmpty {
                Text("No hay \(type == .income ? "ingresos" : "gastos") registrados")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(filteredExpenses) { expense in
                    NavigationLink(destination: EditExpenseView(expense: expense, viewModel: viewModel)) {
                        HStack {
                            Image(systemName: expense.category.icon)
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(expense.category.color)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading) {
                                Text(expense.title)
                                    .font(.system(.body))
                                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text("S/ \(expense.amount, specifier: "%.2f")")
                                .fontWeight(.medium)
                                .foregroundColor(type == .income ? .green : .red)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Vista principal
struct StatsView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var selectedTab = 0
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    MonthSelectorView(viewModel: viewModel, selectedDate: $selectedDate)
                    
                    MonthlyBarChartView()
                    
                    FinancialSummaryView()
                    
                    TabsView(selectedTab: $selectedTab, tabs: ["Ingresos", "Gastos"])
                    
                    if selectedTab == 0 {
                        // Vista de Ingresos
                        TransactionListView(expenses: viewModel.currentMonthExpenses, type: .income, viewModel: viewModel)
                    } else {
                        // Vista de Gastos
                        TransactionListView(expenses: viewModel.currentMonthExpenses, type: .expense, viewModel: viewModel)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Estadísticas")
        }
    }
}

#if DEBUG
struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(viewModel: ExpenseViewModel())
    }
}
#endif
