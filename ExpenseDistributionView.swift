import SwiftUI

struct ExpenseDistributionView: View {
    let expenses: [Expense]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Distribución")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            PieChartView(expenses: expenses)
                .frame(height: 300)
                .padding(.vertical)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    ExpenseDistributionView(expenses: [
        // Alimentos
        Expense(title: "Compras supermercado", amount: 1500, date: Date(), 
               category: .alimentos, type: .expense, time: "12:00",
               isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Restaurante", amount: 800, date: Date(),
               category: .alimentos, type: .expense, time: "13:00",
               isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        
        // Servicios Hogar
        Expense(title: "Luz", amount: 250, date: Date(),
               category: .serviciosHogar, type: .expense, time: "14:00",
               isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Agua", amount: 180, date: Date(),
               category: .serviciosHogar, type: .expense, time: "15:00",
               isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        
        // Salud
        Expense(title: "Consulta médica", amount: 350, date: Date(),
               category: .salud, type: .expense, time: "16:00",
               isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        
        // Transporte
        Expense(title: "Gasolina", amount: 400, date: Date(),
               category: .transporte, type: .expense, time: "18:00",
               isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        
        // Entretenimiento
        Expense(title: "Netflix", amount: 45, date: Date(),
               category: .entretenimiento, type: .expense, time: "20:00",
               isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        
        // Educación
        Expense(title: "Curso online", amount: 600, date: Date(),
               category: .educacion, type: .expense, time: "09:00",
               isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN")
    ])
}
