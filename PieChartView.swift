import SwiftUI

struct PieChartView: View {
    @Environment(\.colorScheme) var colorScheme
    let expenses: [Expense]
    
    private var expensesByCategory: [Expense.Category: Double] {
        var result: [Expense.Category: Double] = [:]
        for expense in expenses where expense.type == .expense {
            result[expense.category, default: 0] += expense.amount
        }
        return result
    }
    
    private var totalExpenses: Double {
        expenses.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    private var sortedExpenses: [(category: Expense.Category, amount: Double)] {
        expensesByCategory.map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) * 0.8
            let center = CGPoint(x: geometry.size.width/2, 
                               y: (geometry.size.height/2) + 20)
            
            ZStack {
                // Fondo del círculo con borde más visible en modo oscuro
                Circle()
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.15) : Color.gray.opacity(0.3), lineWidth: 30)
                    .frame(width: radius * 2)
                    .position(center)
                    .overlay {
                        // Borde exterior
                        Circle()
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
                            .frame(width: radius * 2 + 30)
                            .position(center)
                        // Borde interior
                        Circle()
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
                            .frame(width: radius * 2 - 30)
                            .position(center)
                    }
                
                // Arcos de colores por categoría con bordes
                ForEach(Array(sortedExpenses.enumerated()), id: \.element.category) { index, expense in
                    let startAngle = getStartAngle(for: index)
                    let endAngle = startAngle + 360 * (expense.amount / totalExpenses)
                    
                    Circle()
                        .trim(from: startAngle/360, to: endAngle/360)
                        .stroke(expense.category.color.opacity(colorScheme == .dark ? 0.8 : 1), lineWidth: 30)
                        .frame(width: radius * 2)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: colorScheme == .dark ? Color.black.opacity(0.5) : expense.category.color.opacity(0.3), 
                               radius: 4, x: 0, y: 2)
                        .overlay {
                            Circle()
                                .trim(from: startAngle/360, to: endAngle/360)
                                .stroke(colorScheme == .dark ? Color.white.opacity(0.3) : Color.white.opacity(0.5), lineWidth: 1)
                                .frame(width: radius * 2)
                                .rotationEffect(.degrees(-90))
                        }
                        .position(center)
                }
                
                // Texto central
                VStack(spacing: 8) {
                    Text("Gastos")
                        .font(.system(size: min(radius * 0.1, 24)))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .gray)
                    Text(String(format: "%.2f", totalExpenses))
                        .font(.system(size: min(radius * 0.15, 36), weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .white : .primary)
                }
                .position(center)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
    
    private func getStartAngle(for index: Int) -> Double {
        var startAngle = 0.0
        for i in 0..<index {
            startAngle += 360 * (sortedExpenses[i].amount / totalExpenses)
        }
        return startAngle
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(expenses: [
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
            Expense(title: "Medicamentos", amount: 200, date: Date(),
                   category: .salud, type: .expense, time: "17:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            
            // Transporte
            Expense(title: "Gasolina", amount: 400, date: Date(),
                   category: .transporte, type: .expense, time: "18:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            Expense(title: "Taxi", amount: 150, date: Date(),
                   category: .transporte, type: .expense, time: "19:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            
            // Entretenimiento
            Expense(title: "Netflix", amount: 45, date: Date(),
                   category: .entretenimiento, type: .expense, time: "20:00",
                   isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
            Expense(title: "Cine", amount: 100, date: Date(),
                   category: .entretenimiento, type: .expense, time: "21:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            
            // Educación
            Expense(title: "Curso online", amount: 600, date: Date(),
                   category: .educacion, type: .expense, time: "09:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            Expense(title: "Libros", amount: 200, date: Date(),
                   category: .educacion, type: .expense, time: "10:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            
            // Vestimenta
            Expense(title: "Ropa", amount: 300, date: Date(),
                   category: .vestimenta, type: .expense, time: "11:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            Expense(title: "Zapatos", amount: 250, date: Date(),
                   category: .vestimenta, type: .expense, time: "12:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            
            // Tecnología
            Expense(title: "Accesorios celular", amount: 150, date: Date(),
                   category: .tecnologia, type: .expense, time: "13:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            Expense(title: "Software", amount: 200, date: Date(),
                   category: .tecnologia, type: .expense, time: "14:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            
            // Mascota
            Expense(title: "Comida mascota", amount: 180, date: Date(),
                   category: .mascota, type: .expense, time: "15:00",
                   isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
            Expense(title: "Veterinario", amount: 150, date: Date(),
                   category: .mascota, type: .expense, time: "16:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
            
            // Ahorro
            Expense(title: "Ahorro mensual", amount: 1000, date: Date(),
                   category: .ahorro, type: .expense, time: "17:00",
                   isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
            
            // Otros
            Expense(title: "Gastos varios", amount: 300, date: Date(),
                   category: .otros, type: .expense, time: "18:00",
                   isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN")
        ])
        .frame(height: 300)
    }
}
