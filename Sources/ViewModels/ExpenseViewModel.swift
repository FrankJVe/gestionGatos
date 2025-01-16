import Foundation
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []
    @Published private(set) var currentMonthExpenses: [Expense] = []
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
        let now = Date()
        let calendar = Calendar.current
        currentMonthExpenses = expenses.filter {
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: now) &&
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: now)
        }
    }
    
    private func startOfMonth(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
    
    // MARK: - Computed Properties
    
    var totalIncome: Double {
        currentMonthExpenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        currentMonthExpenses.filter { $0.type == .expense }.reduce(0) { $0 + abs($1.amount) }
    }
    
    var totalBalance: Double {
        totalIncome - totalExpenses
    }
    
    var balanceIsPositive: Bool {
        totalBalance >= 0
    }
    
    var balancePercentage: Double {
        if totalIncome == 0 { return 0 }
        return (totalBalance / totalIncome) * 100
    }
    
    // MARK: - Month Selection
    var availableMonthYears: [Date] {
        let calendar = Calendar.current
        let allDates = expenses.map { $0.date }
        
        // Get unique dates and sort them in descending order (newest first)
        return Array(Set(allDates.map { startOfMonth(for: $0) })).sorted(by: >)
    }
    
    // MARK: - Expense Statistics
    
    var expensesByCategory: [(category: Expense.Category, amount: Double)] {
        let expenseDict = Dictionary(grouping: currentMonthExpenses.filter { $0.type == .expense }) { $0.category }
        return expenseDict.map { (category, expenses) in
            (category: category, amount: expenses.reduce(0) { $0 + abs($1.amount) })
        }.sorted { $0.amount > $1.amount }
    }
    
    var incomeByCategory: [(category: Expense.Category, amount: Double)] {
        let incomeDict = Dictionary(grouping: currentMonthExpenses.filter { $0.type == .income }) { $0.category }
        return incomeDict.map { (category, expenses) in
            (category: category, amount: expenses.reduce(0) { $0 + $1.amount })
        }.sorted { $0.amount > $1.amount }
    }
}
