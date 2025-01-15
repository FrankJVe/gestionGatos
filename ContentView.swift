// AppSettings.swift
import SwiftUI

// Importar AppSettings
@available(iOS 13.0, *)
class AppSettings: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
}

// CategoryDetailView.swift
import SwiftUI

struct CategoryDetailView: View {
    let category: Expense.Category
    let expenses: [Expense]
    @Environment(\.dismiss) private var dismiss
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Total: S/ \(totalAmount, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(category.color)) {
                    ForEach(expenses.sorted(by: { $0.date > $1.date })) { expense in
                        HStack {
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
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// ContentView.swift
import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
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
            }
            .padding(.vertical)
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @StateObject private var settings = AppSettings()
    @State private var showingAddExpense = false
    @State private var showingStats = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                DashboardView(viewModel: viewModel)
                    .navigationTitle("Mi Dinero")
                    .navigationBarItems(
                        leading: HStack(spacing: 16) {
                            Button(action: { showingStats = true }) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.title2)
                                    .foregroundColor(.indigo)
                            }
                            
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
            .tabItem {
                Image(systemName: "house.fill")
                Text("Inicio")
            }
            .tag(0)
            
            NavigationView {
                Text("Movimientos")
                    .navigationTitle("Movimientos")
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Movimientos")
            }
            .tag(1)
            
            NavigationView {
                Text("Presupuestos")
                    .navigationTitle("Presupuestos")
            }
            .tabItem {
                Image(systemName: "doc.text.fill")
                Text("Presupuestos")
            }
            .tag(2)
            
            NavigationView {
                StatsView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "chart.pie.fill")
                Text("Análisis")
            }
            .tag(3)
            
            NavigationView {
                Text("Explorar")
                    .navigationTitle("Explorar")
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Explorar")
            }
            .tag(4)
        }
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingStats) {
            StatsView(viewModel: viewModel)
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

struct MainDashboardView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    private var totalIncome: Double {
        viewModel.expenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpenses: Double {
        viewModel.expenses.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    private var balance: Double {
        totalIncome - totalExpenses
    }
    
    private var monthlyComparison: Double {
        // TODO: Implementar comparación con mes anterior
        return 0.0
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                BalanceCardView(balance: balance, monthlyComparison: monthlyComparison)
                
                HStack(spacing: 16) {
                    TransactionCardView(
                        title: "Ingresos",
                        amount: totalIncome,
                        icon: "arrow.down.circle.fill",
                        color: .green
                    )
                    
                    TransactionCardView(
                        title: "Gastos",
                        amount: totalExpenses,
                        icon: "arrow.up.circle.fill",
                        color: .red
                    )
                }
                .padding(.horizontal)
                
                ExpenseDistributionView(viewModel: viewModel)
                    .frame(height: 300)
                    .padding()
                
                RecentTransactionsView(viewModel: viewModel)
            }
        }
    }
}

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

struct ExpenseDistributionView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    
    private struct CategoryStat {
        let category: Expense.Category
        let amount: Double
        let percentage: Double
    }
    
    private var categoryStats: [CategoryStat] {
        let expenses = viewModel.expenses.filter { $0.type == .expense }
        let totalExpenseAmount = expenses.reduce(0) { $0 + $1.amount }
        
        var categoryAmounts: [Expense.Category: Double] = [:]
        for expense in expenses {
            categoryAmounts[expense.category, default: 0] += expense.amount
        }
        
        return categoryAmounts.map { category, amount in
            CategoryStat(
                category: category,
                amount: amount,
                percentage: totalExpenseAmount > 0 ? amount / totalExpenseAmount : 0
            )
        }.sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Distribución de Gastos")
                .font(.headline)
                .padding(.horizontal)
            
            // Gráfico circular
            ZStack {
                ForEach(categoryStats.indices, id: \.self) { index in
                    let stat = categoryStats[index]
                    let startAngle = getStartAngle(index: index)
                    let endAngle = startAngle + stat.percentage
                    
                    PieSliceView(
                        startAngle: startAngle * 360,
                        endAngle: endAngle * 360,
                        color: stat.category.color
                    )
                }
                
                // Centro del gráfico con el total
                VStack(spacing: 4) {
                    Text("Total Gastos")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("S/ \(categoryStats.reduce(0) { $0 + $1.amount }, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .frame(height: 200)
            .padding()
            
            // Lista de categorías con porcentajes
            VStack(spacing: 12) {
                ForEach(categoryStats, id: \.category) { stat in
                    HStack {
                        Circle()
                            .fill(stat.category.color)
                            .frame(width: 12, height: 12)
                        
                        Text(stat.category.rawValue)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("S/ \(stat.amount, specifier: "%.2f")")
                            .font(.subheadline)
                        
                        Text("(\(stat.percentage * 100, specifier: "%.1f")%)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private func getStartAngle(index: Int) -> Double {
        var sum = 0.0
        for i in 0..<index {
            sum += categoryStats[i].percentage
        }
        return sum
    }
}

struct PieSliceView: View {
    let startAngle: Double
    let endAngle: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
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
            .fill(color)
        }
    }
}

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

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ExpenseViewModel())
    }
}
#endif
