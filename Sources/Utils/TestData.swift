import Foundation

struct TestData {
    static let sampleExpenses: [Expense] = [
        Expense(title: "Compras del mes", amount: 350.0, date: Date(), category: .alimentos, type: .expense, time: "12:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Salario", amount: 3000.0, date: Date(), category: .otros, type: .income, time: "09:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Netflix", amount: 45.0, date: Date(), category: .entretenimiento, type: .expense, time: "15:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Luz", amount: 120.0, date: Date(), category: .serviciosHogar, type: .expense, time: "14:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Freelance", amount: 800.0, date: Date(), category: .otros, type: .income, time: "10:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Internet", amount: 89.0, date: Date(), category: .serviciosHogar, type: .expense, time: "16:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Restaurante", amount: 75.0, date: Date(), category: .alimentos, type: .expense, time: "13:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Taxi", amount: 25.0, date: Date(), category: .transporte, type: .expense, time: "08:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Cine", amount: 40.0, date: Date(), category: .entretenimiento, type: .expense, time: "19:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Bono", amount: 500.0, date: Date(), category: .otros, type: .income, time: "11:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN")
    ]
    
    static var lastMonthExpenses: [Expense] {
        let calendar = Calendar.current
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        return [
            Expense(title: "Compras pasadas", amount: 280.0, date: lastMonth, category: .alimentos, type: .expense, time: "12:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            Expense(title: "Salario anterior", amount: 3000.0, date: lastMonth, category: .otros, type: .income, time: "09:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            Expense(title: "Servicios", amount: 200.0, date: lastMonth, category: .serviciosHogar, type: .expense, time: "14:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN")
        ]
    }
    
    static var allTestExpenses: [Expense] {
        sampleExpenses + lastMonthExpenses
    }
}
