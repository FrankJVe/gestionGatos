import Foundation
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense]
    
    init() {
        self.expenses = Expense.sampleData
    }
    
    var balance: Double {
        let income = expenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let expense = expenses.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        return income - expense
    }
    
    var totalIncome: Double {
        expenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        expenses.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }
    
    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }
}
