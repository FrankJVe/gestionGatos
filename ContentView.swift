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

struct ContentView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @StateObject private var settings = AppSettings()
    @State private var showingAddExpense = false
    @State private var showingStats = false
    @State private var selectedTransactionType: Expense.TransactionType = .expense
    @State private var selectedCategory: Expense.Category?
    @State private var showingCategoryDetail = false
    @Environment(\.colorScheme) private var colorScheme
    
    var totalIncome: Double {
        viewModel.expenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        viewModel.expenses.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    var balance: Double {
        totalIncome - totalExpenses
    }
    
    private var headerBackgroundColor: Color {
        settings.isDarkMode ? Color.indigo.opacity(0.8) : Color.indigo
    }
    
    private var backgroundColor: Color {
        settings.isDarkMode ? Color(.systemGray6) : Color.white
    }
    
    private var secondaryBackgroundColor: Color {
        settings.isDarkMode ? Color(.systemGray5) : Color(.secondarySystemBackground)
    }
    
    private var textColor: Color {
        settings.isDarkMode ? .white : .black
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header con fecha
                    HStack {
                        Text(Date().formatted(date: .abbreviated, time: .omitted))
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(headerBackgroundColor)
                    
                    // Gráfico circular
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 25)
                            .frame(width: 220, height: 220)
                        
                        // Ingresos (verde)
                        Circle()
                            .trim(from: 0, to: totalIncome / (totalIncome + totalExpenses))
                            .stroke(
                                Color.green,
                                style: StrokeStyle(
                                    lineWidth: 25,
                                    lineCap: .butt
                                )
                            )
                            .rotationEffect(.degrees(-90))
                            .frame(width: 220, height: 220)
                        
                        // Gastos por categoría
                        ForEach(getCategoryStats().indices, id: \.self) { index in
                            let stat = getCategoryStats()[index]
                            let startAngle = getStartAngle(index: index)
                            let endAngle = getEndAngle(index: index)
                            
                            Circle()
                                .trim(from: startAngle, to: endAngle)
                                .stroke(
                                    stat.category.color,
                                    style: StrokeStyle(
                                        lineWidth: 25,
                                        lineCap: .butt
                                    )
                                )
                                .rotationEffect(.degrees(-90))
                                .frame(width: 220, height: 220)
                        }
                        
                        // Total en el centro
                        VStack(spacing: 4) {
                            Text("Balance")
                                .font(.title3)
                                .foregroundColor(.gray)
                            Text("S/ \(abs(balance), specifier: "%.2f")")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(balance >= 0 ? .green : .red)
                        }
                    }
                    .frame(height: 240)
                    .padding(.vertical, 10)
                    
                    // Selector de tipo de transacción
                    Picker("", selection: $selectedTransactionType) {
                        Text("Gasto").tag(Expense.TransactionType.expense)
                        Text("Ingreso").tag(Expense.TransactionType.income)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                    
                    // Lista de categorías o balance
                    VStack(spacing: 0) {
                        if selectedTransactionType == .expense {
                            // Vista de gastos por categoría
                            HStack(alignment: .center) {
                                Text("Total Gastos")
                                    .font(.headline)
                                    .frame(width: 120, alignment: .leading)
                                
                                Spacer()
                                
                                Text("S/ \(totalExpenses, specifier: "%.2f")")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(backgroundColor)
                            
                            Divider()
                            
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(getCategoryStats(), id: \.category) { stat in
                                        Button(action: {
                                            showCategoryDetail(stat.category)
                                        }) {
                                            VStack(spacing: 0) {
                                                HStack(alignment: .center) {
                                                    HStack(spacing: 12) {
                                                        Image(systemName: stat.category.icon)
                                                            .foregroundColor(stat.category.color)
                                                            .frame(width: 24)
                                                        
                                                        Text(stat.category.rawValue)
                                                            .font(.system(.body))
                                                            .foregroundColor(textColor)
                                                    }
                                                    .frame(width: 160, alignment: .leading)
                                                    
                                                    Spacer()
                                                    
                                                    Text("S/ \(abs(stat.amount), specifier: "%.2f")")
                                                        .font(.system(.body))
                                                        .foregroundColor(textColor)
                                                }
                                                .padding(.horizontal)
                                                .padding(.vertical, 12)
                                                
                                                Divider()
                                            }
                                            .background(backgroundColor)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        } else {
                            // Vista de ingresos y balance
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    // Total Ingresos
                                    HStack(alignment: .center) {
                                        Text("Total Ingresos")
                                            .font(.headline)
                                            .frame(width: 120, alignment: .leading)
                                            .foregroundColor(textColor)
                                        
                                        Spacer()
                                        
                                        Text("S/ \(totalIncome, specifier: "%.2f")")
                                            .font(.headline)
                                            .foregroundColor(.green)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .background(backgroundColor)
                                    
                                    Divider()
                                    
                                    // Lista de ingresos
                                    ForEach(viewModel.expenses.filter { $0.type == .income }.sorted(by: { $0.date > $1.date }), id: \.id) { income in
                                        VStack(spacing: 0) {
                                            HStack(alignment: .center) {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(income.title)
                                                        .font(.system(.body))
                                                        .foregroundColor(textColor)
                                                    
                                                    Text(income.date.formatted(date: .abbreviated, time: .shortened))
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Spacer()
                                                
                                                Text("S/ \(income.amount, specifier: "%.2f")")
                                                    .font(.system(.body))
                                                    .foregroundColor(.green)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 12)
                                            
                                            Divider()
                                        }
                                        .background(backgroundColor)
                                    }
                                }
                            }
                            .background(secondaryBackgroundColor)
                        }
                    }
                    .background(secondaryBackgroundColor)
                }
            }
            .navigationBarItems(
                leading: HStack(spacing: 16) {
                    Button(action: { showingStats = true }) {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: { settings.isDarkMode.toggle() }) {
                        Image(systemName: settings.isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, -8),
                
                trailing: Button(action: { showingAddExpense = true }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, -8)
            )
        }
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingStats) {
            StatsView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingCategoryDetail) {
            if let category = selectedCategory {
                CategoryDetailView(
                    category: category,
                    expenses: getExpensesForCategory(category)
                )
            }
        }
    }
    
    private struct CategoryStat {
        let category: Expense.Category
        let amount: Double
        let percentage: Double
    }
    
    private func getCategoryStats() -> [CategoryStat] {
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
    
    private func getStartAngle(index: Int) -> Double {
        let totalExpenseAmount = totalExpenses
        let incomeRatio = totalIncome / (totalIncome + totalExpenseAmount)
        
        let stats = getCategoryStats()
        var sum = 0.0
        for i in 0..<index {
            sum += stats[i].percentage
        }
        return incomeRatio + (sum * (1 - incomeRatio))
    }
    
    private func getEndAngle(index: Int) -> Double {
        getStartAngle(index: index) + (getCategoryStats()[index].percentage * (1 - (totalIncome / (totalIncome + totalExpenses))))
    }
    
    private func showCategoryDetail(_ category: Expense.Category) {
        selectedCategory = category
        showingCategoryDetail = true
    }
    
    private func getExpensesForCategory(_ category: Expense.Category) -> [Expense] {
        viewModel.expenses.filter { $0.type == .expense && $0.category == category }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ExpenseViewModel())
    }
}
#endif
