import SwiftUI

struct HabitCard: View {
    let habit: Habit
    @EnvironmentObject var store: HabitStore
    @State private var isHovered = false
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                store.toggleHabit(habit)
            }
        }) {
            HStack(spacing: 14) {
                habitIcon
                habitInfo
                Spacer()
                completionIndicator
            }
            .padding(14)
            .background(cardBackground)
            .overlay(cardBorder)
            .scaleEffect(isPressed ? 0.97 : (isHovered ? 1.01 : 1.0))
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHovered)
            .animation(.spring(response: 0.2), value: isPressed)
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }

    private var habitIcon: some View {
        ZStack {
            Circle()
                .fill(habit.isCompletedToday
                      ? habit.swiftColor
                      : habit.swiftColor.opacity(0.12))
                .frame(width: 46, height: 46)
            Image(systemName: habit.icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(habit.isCompletedToday ? .white : habit.swiftColor)
                .symbolEffect(.bounce, value: habit.isCompletedToday)
        }
    }

    private var habitInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(habit.name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(habit.isCompletedToday ? .primary : .primary)
                .lineLimit(1)
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(.orange)
                Text("\(habit.streak)d streak")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var completionIndicator: some View {
        ZStack {
            ProgressRing(
                progress: habit.isCompletedToday ? 1.0 : Double(habit.completedToday) / Double(max(1, habit.goal)),
                lineWidth: 3,
                size: 30,
                color: habit.swiftColor
            )
            if habit.isCompletedToday {
                Image(systemName: "checkmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(habit.swiftColor)
            } else if habit.goal > 1 {
                Text("\(habit.completedToday)")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color(nsColor: .controlBackgroundColor))
            .shadow(
                color: .black.opacity(isHovered ? 0.1 : 0.05),
                radius: isHovered ? 10 : 4,
                y: isHovered ? 4 : 2
            )
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 14)
            .strokeBorder(
                habit.isCompletedToday
                    ? habit.swiftColor.opacity(0.35)
                    : Color(nsColor: .separatorColor).opacity(0.4),
                lineWidth: 1
            )
    }
}
