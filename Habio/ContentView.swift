import SwiftUI

struct ContentView: View {
    @State private var selection: SidebarItem = .dashboard
    @EnvironmentObject var store: HabitStore
    @EnvironmentObject var auth: AuthStore

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            SidebarView(selection: $selection)
                .environmentObject(auth)
                .navigationSplitViewColumnWidth(min: 190, ideal: 210, max: 260)
        } detail: {
            detailView
                .frame(minWidth: 700)
        }
        .navigationSplitViewStyle(.balanced)
    }

    @ViewBuilder
    private var detailView: some View {
        switch selection {
        case .dashboard:
            DashboardView()
        case .habits:
            placeholderView(title: "My Habits", icon: "checkmark.circle.fill", color: .green)
        case .statistics:
            placeholderView(title: "Statistics", icon: "chart.bar.fill", color: .orange)
        case .settings:
            placeholderView(title: "Settings", icon: "gearshape.fill", color: .gray)
        }
    }

    private func placeholderView(title: String, icon: String, color: Color) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(color.opacity(0.6))
            Text(title)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            Text("Coming soon")
                .font(.system(size: 14))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
