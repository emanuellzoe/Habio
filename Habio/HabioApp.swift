import SwiftUI

@main
struct HabioApp: App {
    @StateObject private var store = HabitStore()
    @StateObject private var auth = AuthStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environmentObject(auth)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1100, height: 740)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}

struct RootView: View {
    @EnvironmentObject var auth: AuthStore

    var body: some View {
        if auth.isLoggedIn {
            ContentView()
        } else {
            LoginView()
                .frame(width: 420, height: 500)
        }
    }
}
