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
    var durationDays: Int      // berapa hari habit ini berjalan
    var startDate: Date        // tanggal mulai

    var endDate: Date {
        Calendar.current.date(byAdding: .day, value: durationDays, to: startDate) ?? startDate
    }

    var isActive: Bool {
        Date() <= endDate
    }

    var daysRemaining: Int {
        max(0, Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0)
    }

    var progressPercent: Double {
        let elapsed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return min(1.0, Double(elapsed) / Double(max(1, durationDays)))
    }

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
