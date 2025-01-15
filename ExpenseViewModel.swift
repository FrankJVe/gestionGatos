import Foundation
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = [
        // INGRESOS
        Expense(
            title: "Sueldo Mensual",
            amount: 5000.00,
            date: Date(),
            category: .otros,
            type: .income,
            time: "09:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Freelance Proyecto",
            amount: 2500.00,
            date: Date(),
            category: .tecnologia,
            type: .income,
            time: "15:30",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        
        // GASTOS
        // Alimentos
        Expense(
            title: "Supermercado Wong",
            amount: 850.00,
            date: Date(),
            category: .alimentos,
            type: .expense,
            time: "11:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Restaurante",
            amount: 200.00,
            date: Date(),
            category: .alimentos,
            type: .expense,
            time: "13:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        
        // Servicios
        Expense(
            title: "Luz",
            amount: 180.00,
            date: Date(),
            category: .serviciosHogar,
            type: .expense,
            time: "14:00",
            isPending: false,
            repeatOption: .monthly,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Agua",
            amount: 140.00,
            date: Date(),
            category: .serviciosHogar,
            type: .expense,
            time: "14:00",
            isPending: false,
            repeatOption: .monthly,
            sheet: "Principal",
            currency: "PEN"
        ),
        
        // Transporte
        Expense(
            title: "Gasolina",
            amount: 300.00,
            date: Date(),
            category: .transporte,
            type: .expense,
            time: "16:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Taxi",
            amount: 150.00,
            date: Date(),
            category: .transporte,
            type: .expense,
            time: "17:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        
        // Entretenimiento
        Expense(
            title: "Netflix",
            amount: 45.00,
            date: Date(),
            category: .entretenimiento,
            type: .expense,
            time: "18:00",
            isPending: false,
            repeatOption: .monthly,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Cine",
            amount: 80.00,
            date: Date(),
            category: .entretenimiento,
            type: .expense,
            time: "19:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        
        // Educación
        Expense(
            title: "Curso Online",
            amount: 500.00,
            date: Date(),
            category: .educacion,
            type: .expense,
            time: "10:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        
        // Salud
        Expense(
            title: "Consulta Médica",
            amount: 250.00,
            date: Date(),
            category: .salud,
            type: .expense,
            time: "11:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        
        // Mascota
        Expense(
            title: "Comida Mascota",
            amount: 180.00,
            date: Date(),
            category: .mascota,
            type: .expense,
            time: "12:00",
            isPending: false,
            repeatOption: .monthly,
            sheet: "Principal",
            currency: "PEN"
        )
    ]
    
    var totalBalance: Double {
        expenses.reduce(0) { total, expense in
            total + (expense.type == .income ? expense.amount : -expense.amount)
        }
    }
    
    var totalIncome: Double {
        expenses.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        expenses.filter { $0.type == .expense }.reduce(0) { $0 + abs($1.amount) }
    }
    
    var balanceIsPositive: Bool {
        totalBalance >= 0
    }
    
    var balancePercentage: Double {
        let previousMonthBalance = calculatePreviousMonthBalance()
        guard previousMonthBalance != 0 else { return 0 }
        return ((totalBalance - previousMonthBalance) / abs(previousMonthBalance)) * 100
    }
    
    var expensesByCategory: [Expense.Category: Double] {
        var result: [Expense.Category: Double] = [:]
        for expense in expenses where expense.type == .expense {
            result[expense.category, default: 0] += abs(expense.amount)
        }
        return result
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        sortExpenses()
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        expenses.remove(atOffsets: indexSet)
        sortExpenses()
    }
    
    func updateExpense(_ updatedExpense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == updatedExpense.id }) {
            expenses[index] = updatedExpense
        }
    }
    
    func getExpensesByCategory() -> [(category: Expense.Category, amount: Double)] {
        var expensesByCategory: [Expense.Category: Double] = [:]
        
        for expense in expenses where expense.type == .expense {
            expensesByCategory[expense.category, default: 0] += abs(expense.amount)
        }
        
        return expensesByCategory.map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }
    }
    
    private func sortExpenses() {
        expenses.sort { $0.date > $1.date }
    }
    
    private func calculatePreviousMonthBalance() -> Double {
        let calendar = Calendar.current
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: Date()) else {
            return 0
        }
        
        return expenses.filter { expense in
            calendar.isDate(expense.date, equalTo: previousMonth, toGranularity: .month)
        }.reduce(0) { total, expense in
            total + (expense.type == .income ? expense.amount : -expense.amount)
        }
    }
}
