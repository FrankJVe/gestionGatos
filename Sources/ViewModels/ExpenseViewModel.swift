import Foundation
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []
    @Published private(set) var currentMonthExpenses: [Expense] = []
    @Published var selectedDate: Date = Date()
    private let repository: ExpenseRepositoryProtocol
    
    init(repository: ExpenseRepositoryProtocol = ExpenseRepository()) {
        self.repository = repository
        loadExpenses()
    }
    
    // MARK: - Public Methods
    
    func loadExpenses() {
        expenses = repository.getAllExpenses()
        updateCurrentMonthExpenses()
    }
    
    func addExpense(_ expense: Expense) {
        repository.addExpense(expense)
        loadExpenses()
    }
    
    func updateExpense(_ expense: Expense) {
        repository.updateExpense(expense)
        loadExpenses()
    }
    
    func deleteExpense(_ expense: Expense) {
        repository.deleteExpense(expense)
        loadExpenses()
    }
    
    // MARK: - Private Methods
    
    private func updateCurrentMonthExpenses() {
        let calendar = Calendar.current
        currentMonthExpenses = expenses.filter {
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: selectedDate) &&
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: selectedDate)
        }
    }
    
    private func startOfMonth(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
    
    private func previousMonthBalance() -> Double {
        let calendar = Calendar.current
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: selectedDate) else { return 0 }
        
        let previousMonthExpenses = expenses.filter {
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: previousMonth) &&
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: previousMonth)
        }
        
        return previousMonthExpenses.reduce(0) { $0 + ($1.type == .income ? $1.amount : -$1.amount) }
    }
    
    // MARK: - Computed Properties
    
    var totalIncome: Double {
        currentMonthExpenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        currentMonthExpenses.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    var totalBalance: Double {
        currentMonthExpenses.reduce(0) { $0 + ($1.type == .income ? $1.amount : -$1.amount) }
    }
    
    var balanceIsPositive: Bool {
        totalBalance >= 0
    }
    
    var balancePercentage: Double {
        if totalIncome == 0 { return 0 }
        return (totalBalance / totalIncome) * 100
    }
    
    var monthlyChangePercentage: Double {
        let previousMonthBalance = previousMonthBalance()
        guard previousMonthBalance != 0 else { return 0 }
        return ((totalBalance - previousMonthBalance) / abs(previousMonthBalance)) * 100
    }
    
    var expensesByCategory: [(category: Expense.Category, amount: Double)] {
        let expensesByCategory = Dictionary(grouping: currentMonthExpenses.filter { $0.type == .expense }) { $0.category }
        return Expense.Category.allCases.map { category in
            let amount = expensesByCategory[category]?.reduce(0) { $0 + $1.amount } ?? 0
            return (category: category, amount: amount)
        }.sorted { $0.amount > $1.amount }
    }
    
    // MARK: - Month Selection
    var availableMonthYears: [Date] {
        let calendar = Calendar.current
        let allDates = expenses.map { $0.date }
        
        // Get unique dates and sort them in descending order (newest first)
        return Array(Set(allDates.map { startOfMonth(for: $0) })).sorted(by: >)
    }
    
    // MARK: - Expense Statistics
    
    var incomeByCategory: [(category: Expense.Category, amount: Double)] {
        let incomeDict = Dictionary(grouping: currentMonthExpenses.filter { $0.type == .income }) { $0.category }
        return incomeDict.map { (category, expenses) in
            (category: category, amount: expenses.reduce(0) { $0 + $1.amount })
        }.sorted { $0.amount > $1.amount }
    }
}
