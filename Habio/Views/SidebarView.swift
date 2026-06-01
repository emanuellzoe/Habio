import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case dashboard  = "Dashboard"
    case habits     = "My Habits"
    case statistics = "Statistics"
    case settings   = "Settings"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .dashboard:  return "square.grid.2x2.fill"
        case .habits:     return "checkmark.circle.fill"
        case .statistics: return "chart.bar.fill"
        case .settings:   return "gearshape.fill"
        }
    }

    var color: Color {
        switch self {
        case .dashboard:  return .blue
        case .habits:     return .green
        case .statistics: return .orange
        case .settings:   return .gray
        }
    }
}

struct SidebarView: View {
    @Binding var selection: SidebarItem
    @EnvironmentObject var store: HabitStore
    @EnvironmentObject var auth: AuthStore

    var body: some View {
        VStack(spacing: 0) {
            appHeader
            Divider().padding(.horizontal, 16)
            navList
            Spacer()
            bottomStats
        }
        .frame(minWidth: 200, idealWidth: 220)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private var appHeader: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 36, height: 36)
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text("Habio")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text("Habit Tracker")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var navList: some View {
        VStack(spacing: 2) {
            ForEach(SidebarItem.allCases) { item in
                SidebarRow(item: item, isSelected: selection == item)
                    .onTapGesture { selection = item }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }

    private var bottomStats: some View {
        VStack(spacing: 0) {
            Divider().padding(.horizontal, 16)
            HStack(spacing: 16) {
                miniStat(value: "\(store.completedTodayCount)/\(store.habits.count)", label: "Today")
                miniStat(value: "\(store.longestStreak)d", label: "Best Streak")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider().padding(.horizontal, 16)
            Button(action: { auth.logout() }) {
                HStack(spacing: 8) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 13))
                    Text("Keluar")
                        .font(.system(size: 13, weight: .medium))
                    Spacer()
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
        }
    }

    private func miniStat(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SidebarRow: View {
    let item: SidebarItem
    let isSelected: Bool
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(isSelected ? item.color : item.color.opacity(0.1))
                    .frame(width: 28, height: 28)
                Image(systemName: item.icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : item.color)
            }
            Text(item.rawValue)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .primary : .secondary)
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 9)
                .fill(isSelected
                      ? Color(nsColor: .selectedContentBackgroundColor).opacity(0.15)
                      : (isHovered ? Color(nsColor: .controlBackgroundColor) : .clear))
        )
        .onHover { isHovered = $0 }
        .animation(.easeInOut(duration: 0.15), value: isHovered)
    }
}
