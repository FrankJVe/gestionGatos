import SwiftUI

struct TestPieChartView: View {
    var body: some View {
        VStack {
            Text("Test Pie Chart")
                .font(.title)
            
            // Círculo simple para probar
            Circle()
                .fill(Color.blue)
                .frame(width: 200, height: 200)
                .padding()
            
            // Gráfico de prueba con datos fijos
            PieChartView(expenses: [
                Expense(
                    title: "Comida",
                    amount: -100,
                    date: Date(),
                    category: .alimentos,
                    type: .expense,
                    time: "12:00",
                    isPending: false,
                    repeatOption: .never,
                    sheet: "Principal",
                    currency: "PEN"
                ),
                Expense(
                    title: "Transporte",
                    amount: -50,
                    date: Date(),
                    category: .transporte,
                    type: .expense,
                    time: "12:00",
                    isPending: false,
                    repeatOption: .never,
                    sheet: "Principal",
                    currency: "PEN"
                )
            ])
            .frame(width: 200, height: 200)
            .border(Color.red) // Para ver el límite del frame
            
            Text("Debajo del gráfico")
                .padding()
        }
    }
}

#Preview {
    TestPieChartView()
}
