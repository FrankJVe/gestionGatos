import Foundation

protocol ExpenseRepositoryProtocol {
    func getAllExpenses() -> [Expense]
    func addExpense(_ expense: Expense)
    func updateExpense(_ expense: Expense)
    func deleteExpense(_ expense: Expense)
}

class ExpenseRepository: ExpenseRepositoryProtocol {
    private var expenses: [Expense] = []
    
    init() {
        // Aquí podrías inicializar con datos de ejemplo o cargar desde almacenamiento persistente
        loadInitialData()
    }
    
    func getAllExpenses() -> [Expense] {
        return expenses
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        // Aquí podrías agregar lógica para persistir los datos
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
    }
    
    private func loadInitialData() {
        // Aquí puedes mover los datos de ejemplo que estaban en el ViewModel
        expenses = [
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
            // ... otros gastos de ejemplo
        ]
    }
}
