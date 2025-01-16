import SwiftUI

struct CategoryDetailView: View {
    let category: Expense.Category
    let expenses: [Expense]
    @Environment(\.dismiss) private var dismiss
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Total: S/ \(totalAmount, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(category.color)) {
                    ForEach(expenses.sorted(by: { $0.date > $1.date })) { expense in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(expense.title)
                                    .font(.body)
                                Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text("S/ \(expense.amount, specifier: "%.2f")")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
