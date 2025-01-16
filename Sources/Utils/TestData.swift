import Foundation

struct TestData {
    static func createDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    static let sampleExpenses: [Expense] = [
        // DICIEMBRE 2024 - INGRESOS
        Expense(title: "Salario Diciembre", amount: 3500.0, date: createDate(year: 2024, month: 12, day: 15), category: .otros, type: .income, time: "09:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Aguinaldo", amount: 3500.0, date: createDate(year: 2024, month: 12, day: 15), category: .otros, type: .income, time: "09:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Freelance Proyecto Web", amount: 1200.0, date: createDate(year: 2024, month: 12, day: 20), category: .otros, type: .income, time: "14:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        
        // DICIEMBRE 2024 - GASTOS FIJOS
        Expense(title: "Alquiler Diciembre", amount: 1200.0, date: createDate(year: 2024, month: 12, day: 1), category: .serviciosHogar, type: .expense, time: "10:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Internet + Cable", amount: 189.0, date: createDate(year: 2024, month: 12, day: 5), category: .tecnologia, type: .expense, time: "11:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Luz", amount: 120.0, date: createDate(year: 2024, month: 12, day: 10), category: .serviciosHogar, type: .expense, time: "14:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Agua", amount: 45.0, date: createDate(year: 2024, month: 12, day: 12), category: .serviciosHogar, type: .expense, time: "15:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        
        // DICIEMBRE 2024 - GASTOS NAVIDEÑOS
        Expense(title: "Compras Navideñas", amount: 800.0, date: createDate(year: 2024, month: 12, day: 23), category: .alimentos, type: .expense, time: "16:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Cena Navideña", amount: 350.0, date: createDate(year: 2024, month: 12, day: 24), category: .alimentos, type: .expense, time: "20:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Regalo Familiar", amount: 500.0, date: createDate(year: 2024, month: 12, day: 24), category: .vestimenta, type: .expense, time: "15:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Fiesta Año Nuevo", amount: 300.0, date: createDate(year: 2024, month: 12, day: 31), category: .entretenimiento, type: .expense, time: "22:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        
        // DICIEMBRE 2024 - OTROS GASTOS
        Expense(title: "Consulta Médica", amount: 150.0, date: createDate(year: 2024, month: 12, day: 7), category: .salud, type: .expense, time: "11:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Medicamentos", amount: 85.0, date: createDate(year: 2024, month: 12, day: 7), category: .salud, type: .expense, time: "12:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Curso Online", amount: 250.0, date: createDate(year: 2024, month: 12, day: 8), category: .educacion, type: .expense, time: "14:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Comida Mascota", amount: 120.0, date: createDate(year: 2024, month: 12, day: 9), category: .mascota, type: .expense, time: "17:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Taxi Semana", amount: 100.0, date: createDate(year: 2024, month: 12, day: 13), category: .transporte, type: .expense, time: "19:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Laptop Nueva", amount: 3500.0, date: createDate(year: 2024, month: 12, day: 16), category: .tecnologia, type: .expense, time: "15:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        
        // ENERO 2025 - INGRESOS
        Expense(title: "Salario Enero", amount: 3500.0, date: createDate(year: 2025, month: 1, day: 15), category: .otros, type: .income, time: "09:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Freelance App Móvil", amount: 2000.0, date: createDate(year: 2025, month: 1, day: 10), category: .otros, type: .income, time: "15:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Inversiones", amount: 500.0, date: createDate(year: 2025, month: 1, day: 5), category: .ahorro, type: .income, time: "10:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        
        // ENERO 2025 - GASTOS FIJOS
        Expense(title: "Alquiler Enero", amount: 1200.0, date: createDate(year: 2025, month: 1, day: 1), category: .serviciosHogar, type: .expense, time: "10:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Internet + Cable", amount: 189.0, date: createDate(year: 2025, month: 1, day: 5), category: .tecnologia, type: .expense, time: "11:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Luz", amount: 135.0, date: createDate(year: 2025, month: 1, day: 10), category: .serviciosHogar, type: .expense, time: "14:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Agua", amount: 50.0, date: createDate(year: 2025, month: 1, day: 12), category: .serviciosHogar, type: .expense, time: "15:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        
        // ENERO 2025 - GASTOS VARIOS
        Expense(title: "Compras Supermercado", amount: 450.0, date: createDate(year: 2025, month: 1, day: 5), category: .alimentos, type: .expense, time: "11:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Veterinario", amount: 180.0, date: createDate(year: 2025, month: 1, day: 6), category: .mascota, type: .expense, time: "16:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Comida Mascota", amount: 120.0, date: createDate(year: 2025, month: 1, day: 6), category: .mascota, type: .expense, time: "17:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Ropa", amount: 300.0, date: createDate(year: 2025, month: 1, day: 8), category: .vestimenta, type: .expense, time: "16:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Zapatos", amount: 250.0, date: createDate(year: 2025, month: 1, day: 8), category: .vestimenta, type: .expense, time: "16:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Restaurante", amount: 120.0, date: createDate(year: 2025, month: 1, day: 14), category: .alimentos, type: .expense, time: "20:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Taxi", amount: 80.0, date: createDate(year: 2025, month: 1, day: 14), category: .transporte, type: .expense, time: "19:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Curso Programación", amount: 300.0, date: createDate(year: 2025, month: 1, day: 15), category: .educacion, type: .expense, time: "09:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        
        // SUSCRIPCIONES MENSUALES
        Expense(title: "Netflix", amount: 45.0, date: createDate(year: 2025, month: 1, day: 1), category: .entretenimiento, type: .expense, time: "00:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Spotify", amount: 18.90, date: createDate(year: 2025, month: 1, day: 1), category: .entretenimiento, type: .expense, time: "00:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "iCloud", amount: 11.90, date: createDate(year: 2025, month: 1, day: 1), category: .tecnologia, type: .expense, time: "00:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN")
    ]
    
    static var allTestExpenses: [Expense] {
        sampleExpenses
    }
}
