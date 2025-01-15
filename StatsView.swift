import SwiftUI

struct StatsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var selectedPeriod: Period = .month
    @State private var selectedType: Expense.TransactionType = .expense
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    enum Period: String, CaseIterable {
        case week = "Semana"
        case month = "Mes"
        case year = "Año"
    }
    
    var filteredExpenses: [Expense] {
        viewModel.expenses.filter { expense in
            let isTypeMatch = expense.type == selectedType
            let isInPeriod: Bool
            
            let calendar = Calendar.current
            let now = Date()
            
            switch selectedPeriod {
            case .week:
                let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
                isInPeriod = calendar.isDate(expense.date, equalTo: weekStart, toGranularity: .weekOfYear)
            case .month:
                isInPeriod = calendar.isDate(expense.date, equalTo: now, toGranularity: .month)
            case .year:
                isInPeriod = calendar.isDate(expense.date, equalTo: now, toGranularity: .year)
            }
            
            return isTypeMatch && isInPeriod
        }
    }
    
    var totalAmount: Double {
        filteredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Periodo", selection: $selectedPeriod) {
                    ForEach(Period.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Picker("Tipo", selection: $selectedType) {
                    Text("Gasto").tag(Expense.TransactionType.expense)
                    Text("Ingreso").tag(Expense.TransactionType.income)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List {
                    Section(header: Text("Total: S/ \(totalAmount, specifier: "%.2f")")) {
                        ForEach(filteredExpenses) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.title)
                                        .font(.headline)
                                    Text(dateFormatter.string(from: expense.date))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("S/ \(expense.amount, specifier: "%.2f")")
                                    .foregroundColor(expense.type == .expense ? .red : .green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Estadísticas")
            .navigationBarItems(trailing: Button("Cerrar") {
                dismiss()
            })
        }
    }
}

#if DEBUG
struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(viewModel: ExpenseViewModel())
    }
}
#endif
