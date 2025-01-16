import Foundation
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []
    private let repository: ExpenseRepositoryProtocol
    
    init(repository: ExpenseRepositoryProtocol = ExpenseRepository()) {
        self.repository = repository
        loadExpenses()
    }
    
    // MARK: - Public Methods
    
    func loadExpenses() {
        expenses = repository.getAllExpenses()
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
    
    // MARK: - Computed Properties
    
    var totalIncome: Double {
        expenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        expenses.filter { $0.type == .expense }.reduce(0) { $0 + abs($1.amount) }
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
    
    var expensesByCategory: [Expense.Category: Double] {
        var result: [Expense.Category: Double] = [:]
        for expense in expenses where expense.type == .expense {
            result[expense.category, default: 0] += abs(expense.amount)
        }
        return result
    }
    
    // MARK: - Filtering Methods
    
    func expenses(for category: Expense.Category) -> [Expense] {
        expenses.filter { $0.category == category }
    }
    
    func expenses(forType type: Expense.TransactionType) -> [Expense] {
        expenses.filter { $0.type == type }
    }
    
    func expenses(forMonth month: Date) -> [Expense] {
        let calendar = Calendar.current
        return expenses.filter {
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: month) &&
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: month)
        }
    }
    
    // MARK: - Statistics Methods
    
    func totalAmount(for category: Expense.Category, type: Expense.TransactionType) -> Double {
        expenses(for: category)
            .filter { $0.type == type }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    func percentageForCategory(_ category: Expense.Category, type: Expense.TransactionType) -> Double {
        let categoryTotal = totalAmount(for: category, type: type)
        let total = type == .expense ? totalExpenses : totalIncome
        return total > 0 ? (categoryTotal / total) * 100 : 0
    }
    
    func monthlyExpenses(for date: Date = Date()) -> Double {
        expenses(forMonth: date)
            .filter { $0.type == .expense }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    func monthlyIncome(for date: Date = Date()) -> Double {
        expenses(forMonth: date)
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
}
