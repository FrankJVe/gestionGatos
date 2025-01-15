import Foundation
import SwiftUI

struct Expense: Identifiable, Codable {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var category: Category
    var type: TransactionType
    var time: String
    var isPending: Bool
    var repeatOption: RepeatOption
    var sheet: String
    var currency: String
    
    init(title: String, amount: Double, date: Date, category: Category, type: TransactionType, time: String, isPending: Bool, repeatOption: RepeatOption, sheet: String, currency: String) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.type = type
        self.time = time
        self.isPending = isPending
        self.repeatOption = repeatOption
        self.sheet = sheet
        self.currency = currency
    }
    
    enum TransactionType: String, Codable, CaseIterable {
        case expense = "Gasto"
        case income = "Ingreso"
    }
    
    enum Category: String, Codable, CaseIterable {
        case alimentos = "Alimentos"
        case serviciosHogar = "Servicios Hogar"
        case salud = "Salud"
        case transporte = "Transporte"
        case entretenimiento = "Entretenimiento"
        case educacion = "Educación"
        case vestimenta = "Vestimenta"
        case tecnologia = "Tecnología"
        case mascota = "Mascota"
        case ahorro = "Ahorro"
        case otros = "Otros"
        
        var icon: String {
            switch self {
            case .alimentos: return "cart.fill"
            case .serviciosHogar: return "house.fill"
            case .salud: return "heart.fill"
            case .transporte: return "car.fill"
            case .entretenimiento: return "film.fill"
            case .educacion: return "book.fill"
            case .vestimenta: return "tshirt.fill"
            case .tecnologia: return "laptopcomputer"
            case .mascota: return "pawprint.fill"
            case .ahorro: return "banknote.fill"
            case .otros: return "ellipsis.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .alimentos: return .blue
            case .serviciosHogar: return .purple
            case .salud: return .red
            case .transporte: return .orange
            case .entretenimiento: return .pink
            case .educacion: return .green
            case .vestimenta: return .yellow
            case .tecnologia: return .indigo
            case .mascota: return .mint
            case .ahorro: return .teal
            case .otros: return .gray
            }
        }
    }
    
    enum RepeatOption: String, Codable, CaseIterable {
        case never = "Nunca"
        case daily = "Diario"
        case weekly = "Semanal"
        case monthly = "Mensual"
    }
    
    static var sampleData: [Expense] = [
        Expense(title: "Compras supermercado", amount: 250.00, date: Date(), category: .alimentos, type: .expense, time: "14:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Luz y agua", amount: 180.00, date: Date(), category: .serviciosHogar, type: .expense, time: "15:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Consulta médica", amount: 120.00, date: Date(), category: .salud, type: .expense, time: "16:30", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Pasajes", amount: 50.00, date: Date(), category: .transporte, type: .expense, time: "08:00", isPending: false, repeatOption: .daily, sheet: "Principal", currency: "PEN"),
        Expense(title: "Netflix", amount: 45.00, date: Date(), category: .entretenimiento, type: .expense, time: "20:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN"),
        Expense(title: "Curso online", amount: 200.00, date: Date(), category: .educacion, type: .expense, time: "10:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Ropa", amount: 150.00, date: Date(), category: .vestimenta, type: .expense, time: "13:00", isPending: false, repeatOption: .never, sheet: "Principal", currency: "PEN"),
        Expense(title: "Comida mascota", amount: 80.00, date: Date(), category: .mascota, type: .expense, time: "09:00", isPending: false, repeatOption: .monthly, sheet: "Principal", currency: "PEN")
    ]
}
