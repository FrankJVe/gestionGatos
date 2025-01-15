import SwiftUI

struct EditExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: ExpenseViewModel
    let expense: Expense
    
    @State private var title: String
    @State private var amount: String
    @State private var date: Date
    @State private var time: Date
    @State private var type: Expense.TransactionType
    @State private var category: Expense.Category
    @State private var isPending: Bool
    @State private var repeatOption: Expense.RepeatOption
    @State private var sheet: String
    @State private var currency: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    init(expense: Expense, viewModel: ExpenseViewModel) {
        self.expense = expense
        self.viewModel = viewModel
        
        _title = State(initialValue: expense.title)
        _amount = State(initialValue: String(format: "%.2f", expense.amount))
        _date = State(initialValue: expense.date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeDate = formatter.date(from: expense.time) ?? Date()
        _time = State(initialValue: timeDate)
        
        _type = State(initialValue: expense.type)
        _category = State(initialValue: expense.category)
        _isPending = State(initialValue: expense.isPending)
        _repeatOption = State(initialValue: expense.repeatOption)
        _sheet = State(initialValue: expense.sheet)
        _currency = State(initialValue: expense.currency)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tipo de Transacción")) {
                    Picker("Tipo", selection: $type) {
                        ForEach(Expense.TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
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
                
                if type == .expense {
                    Section(header: Text("Categoría")) {
                        Picker("Categoría", selection: $category) {
                            ForEach(Expense.Category.allCases, id: \.self) { category in
                                HStack {
                                    Image(systemName: category.icon)
                                        .foregroundColor(category.color)
                                    Text(category.rawValue)
                                }.tag(category)
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
            .navigationTitle("Editar Registro")
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
        
        let updatedExpense = Expense(
            title: title,
            amount: amountValue,
            date: date,
            category: type == .expense ? category : .otros, // Categoría por defecto para ingresos
            type: type,
            time: timeString,
            isPending: isPending,
            repeatOption: repeatOption,
            sheet: sheet,
            currency: currency
        )
        
        viewModel.updateExpense(updatedExpense)
        dismiss()
    }
}

struct EditExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditExpenseView(
                expense: Expense.sampleData[0],
                viewModel: ExpenseViewModel()
            )
            .preferredColorScheme(.light)
            
            EditExpenseView(
                expense: Expense.sampleData[0],
                viewModel: ExpenseViewModel()
            )
            .preferredColorScheme(.dark)
        }
    }
}
