import SwiftUI

// MARK: - Card Style
struct CardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color(nsColor: .separatorColor).opacity(0.3), lineWidth: 0.5)
            )
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.12))
                            .frame(width: 32, height: 32)
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(color)
                    }
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .lastTextBaseline, spacing: 3) {
                        Text(value)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                        Text(subtitle)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    Text(title)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .groupBoxStyle(CardGroupBoxStyle())
    }
}

// MARK: - Weekly Bar Chart
struct WeeklyBarChart: View {
    let data: [(label: String, ratio: Double)]

    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                VStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(barColor(for: item.ratio, isToday: index == data.count - 1))
                        .frame(height: max(4, item.ratio * 52))
                    Text(item.label)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(index == data.count - 1 ? .primary : .secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 72)
    }

    private func barColor(for ratio: Double, isToday: Bool) -> Color {
        guard ratio > 0 else { return Color(nsColor: .separatorColor) }
        if ratio >= 0.8 { return isToday ? .green : .green.opacity(0.6) }
        if ratio >= 0.5 { return isToday ? .orange : .orange.opacity(0.6) }
        return isToday ? .blue.opacity(0.8) : .blue.opacity(0.4)
    }
}

// MARK: - Main Dashboard
struct DashboardView: View {
    @EnvironmentObject var store: HabitStore

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default:      return "Good Night"
        }
    }

    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        return f.string(from: Date())
    }

    private var progressColor: Color {
        switch store.todayCompletionRatio {
        case 0.8...: return .green
        case 0.5...: return .orange
        default:     return .red
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                headerSection
                overviewSection
                habitsSection
                Spacer(minLength: 20)
            }
            .padding(28)
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }

    // MARK: Header
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text(greeting + " 👋")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                Text(dateString)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            addHabitButton
        }
    }

    private var addHabitButton: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Image(systemName: "plus")
                    .font(.system(size: 12, weight: .bold))
                Text("Add Habit")
                    .font(.system(size: 13, weight: .semibold))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.accentColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    // MARK: Overview
    private var overviewSection: some View {
        HStack(alignment: .top, spacing: 18) {
            todayCard
            VStack(spacing: 14) {
                HStack(spacing: 14) {
                    StatCard(title: "Best Streak", value: "\(store.longestStreak)",
                             subtitle: "days", icon: "flame.fill", color: .orange)
                    StatCard(title: "Completed", value: "\(store.completedTodayCount)",
                             subtitle: "/ \(store.habits.count)", icon: "checkmark.circle.fill", color: .green)
                }
                weeklyCard
            }
        }
    }

    private var todayCard: some View {
        GroupBox {
            VStack(spacing: 18) {
                Text("Today")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    ProgressRing(
                        progress: store.todayCompletionRatio,
                        lineWidth: 14,
                        size: 130,
                        color: progressColor
                    )
                    VStack(spacing: 3) {
                        Text("\(Int(store.todayCompletionRatio * 100))%")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(progressColor)
                        Text("done")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(spacing: 4) {
                    Text("\(store.completedTodayCount) of \(store.habits.count) habits")
                        .font(.system(size: 13, weight: .semibold))
                    if store.todayCompletionRatio == 1.0 {
                        Label("All done! Great job!", systemImage: "star.fill")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.yellow)
                    } else {
                        let remaining = store.habits.count - store.completedTodayCount
                        Text("\(remaining) habit\(remaining == 1 ? "" : "s") left")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(6)
        }
        .frame(width: 210)
        .groupBoxStyle(CardGroupBoxStyle())
    }

    private var weeklyCard: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Label("This Week", systemImage: "calendar")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    let avg = store.weeklyData().map(\.ratio).reduce(0, +) / 7.0
                    Text("\(Int(avg * 100))% avg")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                WeeklyBarChart(data: store.weeklyData())
            }
            .padding(2)
        }
        .groupBoxStyle(CardGroupBoxStyle())
    }

    // MARK: Habits Grid
    private var habitsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Your Habits")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text("\(store.habits.count) active")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
            ], spacing: 12) {
                ForEach(store.habits) { habit in
                    HabitCard(habit: habit)
                }
            }
        }
    }
}
