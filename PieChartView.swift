import SwiftUI

struct PieChartView: View {
    let expenses: [Expense]
    
    var body: some View {
        GeometryReader { geometry in
            let diameter = min(geometry.size.width, geometry.size.height)
            ZStack {
                // Círculo base
                Circle()
                    .fill(Color.gray.opacity(0.3))
                
                // Sectores del gráfico
                ForEach(expenses.indices, id: \.self) { index in
                    let percentage = Double(index + 1) / Double(expenses.count)
                    PieSlice(startAngle: .degrees(0), endAngle: .degrees(percentage * 360))
                        .fill(expenses[index].category.color)
                }
            }
            .frame(width: diameter, height: diameter)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(center: center,
                   radius: radius,
                   startAngle: Angle(degrees: -90) + startAngle,
                   endAngle: Angle(degrees: -90) + endAngle,
                   clockwise: false)
        
        return path
    }
}

#Preview {
    PieChartView(expenses: [
        Expense(title: "Comida", amount: -100, date: Date(), category: .alimentos, type: .expense, time: "12:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Transporte", amount: -50, date: Date(), category: .transporte, type: .expense, time: "12:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN")
    ])
    .frame(width: 200, height: 200)
    .border(Color.red)
}
