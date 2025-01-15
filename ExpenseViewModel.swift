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
        Expense(
            title: "Supermercado Wong",
            amount: -850.00,
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
            title: "Luz y Agua",
            amount: -320.00,
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
            title: "Consulta Médica",
            amount: -180.00,
            date: Date(),
            category: .salud,
            type: .expense,
            time: "16:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Pasajes Metro",
            amount: -100.00,
            date: Date(),
            category: .transporte,
            type: .expense,
            time: "08:00",
            isPending: false,
            repeatOption: .monthly,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Netflix y Spotify",
            amount: -45.00,
            date: Date(),
            category: .entretenimiento,
            type: .expense,
            time: "00:00",
            isPending: false,
            repeatOption: .monthly,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Curso Udemy",
            amount: -200.00,
            date: Date(),
            category: .educacion,
            type: .expense,
            time: "20:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Ropa H&M",
            amount: -250.00,
            date: Date(),
            category: .vestimenta,
            type: .expense,
            time: "17:00",
            isPending: false,
            repeatOption: .never,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "MacBook Pro Cuota",
            amount: -500.00,
            date: Date(),
            category: .tecnologia,
            type: .expense,
            time: "13:00",
            isPending: false,
            repeatOption: .monthly,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Veterinario y Alimento",
            amount: -180.00,
            date: Date(),
            category: .mascota,
            type: .expense,
            time: "11:30",
            isPending: false,
            repeatOption: .monthly,
            sheet: "Principal",
            currency: "PEN"
        ),
        Expense(
            title: "Ahorro Mensual",
            amount: -1000.00,
            date: Date(),
            category: .ahorro,
            type: .expense,
            time: "00:00",
            isPending: false,
            repeatOption: .monthly,
            sheet: "Principal",
            currency: "PEN"
        )
    ]
    
    var totalBalance: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var totalIncome: Double {
        expenses.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        expenses.filter { $0.amount < 0 }.reduce(0) { $0 + $1.amount }
    }
    
    var expensesByCategory: [Expense.Category: Double] {
        var result: [Expense.Category: Double] = [:]
        for expense in expenses where expense.amount < 0 {
            result[expense.category, default: 0] += abs(expense.amount)
        }
        return result
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        // Aquí podrías agregar persistencia de datos
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        // Aquí podrías agregar persistencia de datos
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }
    
    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }
    
    init() {
        // Datos de prueba
        expenses = [
            Expense(title: "Supermercado Wong", amount: -850.00, date: Date(), category: .alimentos, type: .expense, time: "10:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            Expense(title: "Luz y Agua", amount: -320.00, date: Date(), category: .serviciosHogar, type: .expense, time: "11:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            Expense(title: "Sueldo Mensual", amount: 5000.00, date: Date(), category: .otros, type: .income, time: "12:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN")
        ]
    }
}
