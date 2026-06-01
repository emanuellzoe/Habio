import Foundation
import SwiftUI

enum HabitFrequency: String, CaseIterable, Codable {
    case daily = "Daily"
    case weekdays = "Weekdays"
    case weekends = "Weekends"
}

struct Habit: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var icon: String
    var color: String
    var frequency: HabitFrequency
    var completedDates: [Date]
    var streak: Int
    var goal: Int
    var completedToday: Int

    var isCompletedToday: Bool {
        completedDates.contains { Calendar.current.isDateInToday($0) }
    }

    var completionRatio: Double {
        min(1.0, Double(completedToday) / Double(max(1, goal)))
    }

    var swiftColor: Color {
        switch color {
        case "purple":  return .purple
        case "orange":  return .orange
        case "blue":    return .blue
        case "cyan":    return .cyan
        case "indigo":  return .indigo
        case "green":   return .green
        case "red":     return .red
        case "pink":    return .pink
        case "teal":    return .teal
        case "yellow":  return .yellow
        default:        return .accentColor
        }
    }
}
