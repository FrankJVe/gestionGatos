import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: ExpenseViewModel
    
    @State private var title = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var time = Date()
    @State private var type: Expense.TransactionType = .expense
    @State private var category: Expense.Category = .alimentos
    @State private var isPending = false
    @State private var repeatOption: Expense.RepeatOption = .never
    @State private var sheet = "Principal"
    @State private var currency = "PEN"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tipo de Transacción")) {
                    Picker("Tipo", selection: $type) {
                        Text("Gasto").tag(Expense.TransactionType.expense)
                        Text("Ingreso").tag(Expense.TransactionType.income)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Detalles")) {
                    TextField("Título", text: $title)
                    
                    HStack {
                        Text("S/")
                        TextField("Monto", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                    
                    DatePicker("Fecha", selection: $date, displayedComponents: [.date])
                    DatePicker("Hora", selection: $time, displayedComponents: [.hourAndMinute])
                }
                
                Section(header: Text("Categoría")) {
                    if type == .expense {
                        Picker("Categoría", selection: $category) {
                            ForEach(Expense.Category.allCases, id: \.self) { category in
                                Label(category.rawValue, systemImage: category.icon)
                                    .foregroundColor(category.color)
                                    .tag(category)
                            }
                        }
                    }
                }
                
                Section(header: Text("Opciones Adicionales")) {
                    Toggle("Pendiente", isOn: $isPending)
                    
                    Picker("Repetir", selection: $repeatOption) {
                        ForEach(Expense.RepeatOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    
                    TextField("Hoja", text: $sheet)
                }
            }
            .scrollContentBackground(.hidden)
            .background(backgroundColor)
            .navigationTitle("Nuevo Registro")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    dismiss()
                },
                trailing: Button("Guardar") {
                    saveExpense()
                }
            )
            .alert("Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveExpense() {
        guard !title.isEmpty else {
            alertMessage = "Por favor ingrese un título"
            showingAlert = true
            return
        }
        
        guard let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) else {
            alertMessage = "Por favor ingrese un monto válido"
            showingAlert = true
            return
        }
        
        let timeString = time.formatted(date: .omitted, time: .shortened)
        
        let expense = Expense(
            title: title,
            amount: amountValue,
            date: date,
            category: type == .expense ? category : .otros,
            type: type,
            time: timeString,
            isPending: isPending,
            repeatOption: repeatOption,
            sheet: sheet,
            currency: currency
        )
        
        viewModel.addExpense(expense)
        dismiss()
    }
}

#if DEBUG
struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddExpenseView(viewModel: ExpenseViewModel())
                .preferredColorScheme(.light)
            
            AddExpenseView(viewModel: ExpenseViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
#endif
