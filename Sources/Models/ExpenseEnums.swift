import SwiftUI

public enum ExpenseType: String, Codable, CaseIterable {
    case income = "income"
    case expense = "expense"
}

public enum ExpenseCategory: String, Codable, CaseIterable {
    case food = "food"
    case transportation = "transportation"
    case entertainment = "entertainment"
    case shopping = "shopping"
    case utilities = "utilities"
    case health = "health"
    case education = "education"
    case other = "other"
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transportation: return "car.fill"
        case .entertainment: return "gamecontroller.fill"
        case .shopping: return "cart.fill"
        case .utilities: return "house.fill"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .blue
        case .transportation: return .green
        case .entertainment: return .purple
        case .shopping: return .orange
        case .utilities: return .red
        case .health: return .pink
        case .education: return .yellow
        case .other: return .gray
        }
    }
}

public enum RepeatOption: String, Codable, CaseIterable {
    case never = "never"
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
}
