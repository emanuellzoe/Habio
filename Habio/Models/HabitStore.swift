import Foundation
import SwiftUI

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []

    init() {
        loadSampleData()
    }

    private func loadSampleData() {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!

        habits = [
            Habit(name: "Morning Meditation", icon: "brain.head.profile", color: "purple",
                  frequency: .daily, completedDates: [today, yesterday, twoDaysAgo],
                  streak: 7, goal: 1, completedToday: 1),
            Habit(name: "Exercise", icon: "figure.run", color: "orange",
                  frequency: .daily, completedDates: [today, yesterday],
                  streak: 3, goal: 1, completedToday: 1),
            Habit(name: "Read", icon: "book.fill", color: "blue",
                  frequency: .daily, completedDates: [yesterday, twoDaysAgo],
                  streak: 12, goal: 1, completedToday: 0),
            Habit(name: "Drink Water", icon: "drop.fill", color: "cyan",
                  frequency: .daily, completedDates: [today, yesterday, twoDaysAgo],
                  streak: 21, goal: 8, completedToday: 5),
            Habit(name: "Sleep 8h", icon: "moon.fill", color: "indigo",
                  frequency: .daily, completedDates: [yesterday],
                  streak: 2, goal: 1, completedToday: 0),
            Habit(name: "Journaling", icon: "pencil.and.list.clipboard", color: "green",
                  frequency: .daily, completedDates: [today, yesterday],
                  streak: 5, goal: 1, completedToday: 1),
            Habit(name: "No Sugar", icon: "fork.knife", color: "red",
                  frequency: .daily, completedDates: [yesterday, twoDaysAgo],
                  streak: 4, goal: 1, completedToday: 0),
            Habit(name: "Cold Shower", icon: "shower.fill", color: "teal",
                  frequency: .daily, completedDates: [today],
                  streak: 9, goal: 1, completedToday: 1),
        ]
    }

    var completedTodayCount: Int {
        habits.filter { $0.isCompletedToday }.count
    }

    var todayCompletionRatio: Double {
        guard !habits.isEmpty else { return 0 }
        return Double(completedTodayCount) / Double(habits.count)
    }

    var longestStreak: Int {
        habits.map(\.streak).max() ?? 0
    }

    func toggleHabit(_ habit: Habit) {
        guard let idx = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        if habits[idx].isCompletedToday {
            habits[idx].completedDates.removeAll { Calendar.current.isDateInToday($0) }
            habits[idx].completedToday = max(0, habits[idx].completedToday - 1)
            if habits[idx].streak > 0 { habits[idx].streak -= 1 }
        } else {
            habits[idx].completedDates.append(Date())
            habits[idx].completedToday = habits[idx].goal
            habits[idx].streak += 1
        }
    }

    func weeklyData() -> [(label: String, ratio: Double)] {
        (0..<7).map { offset in
            let daysAgo = 6 - offset
            let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
            let completed = habits.filter { h in
                h.completedDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
            }.count
            let ratio = habits.isEmpty ? 0.0 : Double(completed) / Double(habits.count)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            let label = String(formatter.string(from: date).prefix(1))
            return (label: label, ratio: ratio)
        }
    }
}
