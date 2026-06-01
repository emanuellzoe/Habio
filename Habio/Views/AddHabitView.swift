import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject var store: HabitStore
    @Environment(\.dismiss) var dismiss

    @State private var habitName = ""
    @State private var selectedIcon = "star.fill"
    @State private var selectedColor = "blue"
    @State private var selectedFrequency: HabitFrequency = .daily
    @State private var durationDays = 30
    @FocusState private var nameFocused: Bool

    private let icons = [
        "star.fill", "heart.fill", "brain.head.profile", "figure.run", "book.fill",
        "drop.fill", "moon.fill", "sun.max.fill", "fork.knife", "shower.fill",
        "pencil.and.list.clipboard", "music.note", "gamecontroller.fill", "laptopcomputer",
        "bicycle", "leaf.fill", "flame.fill", "bolt.fill", "camera.fill", "cup.and.saucer.fill"
    ]

    private let colors: [(name: String, color: Color)] = [
        ("blue", .blue), ("purple", .purple), ("green", .green), ("orange", .orange),
        ("red", .red), ("pink", .pink), ("teal", .teal), ("cyan", .cyan),
        ("indigo", .indigo), ("yellow", .yellow)
    ]

    private let durationPresets = [7, 14, 21, 30, 60, 90]

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                VStack(spacing: 22) {
                    nameSection
                    iconSection
                    colorSection
                    frequencySection
                    durationSection
                    preview
                }
                .padding(24)
            }
            Divider()
            footer
        }
        .frame(width: 480, height: 600)
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear { nameFocused = true }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            Text("Tambah Habit Baru")
                .font(.system(size: 16, weight: .semibold))
            Spacer()
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color(nsColor: .tertiaryLabelColor))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    // MARK: - Nama Habit
    private var nameSection: some View {
        formSection(title: "Nama Habit", icon: "textformat") {
            TextField("Contoh: Olahraga pagi, Baca buku...", text: $habitName)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(nsColor: .textBackgroundColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(
                                    nameFocused ? Color.accentColor : Color(nsColor: .separatorColor),
                                    lineWidth: nameFocused ? 1.5 : 0.5
                                )
                        )
                )
                .focused($nameFocused)
        }
    }

    // MARK: - Icon
    private var iconSection: some View {
        formSection(title: "Icon", icon: "square.grid.3x3.fill") {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(44)), count: 10), spacing: 8) {
                ForEach(icons, id: \.self) { icon in
                    Button(action: { selectedIcon = icon }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedIcon == icon
                                      ? currentColor
                                      : Color(nsColor: .controlBackgroundColor))
                            Image(systemName: icon)
                                .font(.system(size: 16))
                                .foregroundStyle(selectedIcon == icon ? .white : .secondary)
                        }
                        .frame(width: 40, height: 40)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Warna
    private var colorSection: some View {
        formSection(title: "Warna", icon: "paintpalette.fill") {
            HStack(spacing: 10) {
                ForEach(colors, id: \.name) { item in
                    Button(action: { selectedColor = item.name }) {
                        ZStack {
                            Circle()
                                .fill(item.color)
                                .frame(width: 30, height: 30)
                            if selectedColor == item.name {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Frekuensi
    private var frequencySection: some View {
        formSection(title: "Frekuensi", icon: "calendar") {
            HStack(spacing: 8) {
                ForEach(HabitFrequency.allCases, id: \.self) { freq in
                    Button(action: { selectedFrequency = freq }) {
                        Text(freq.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedFrequency == freq
                                          ? currentColor
                                          : Color(nsColor: .controlBackgroundColor))
                            )
                            .foregroundStyle(selectedFrequency == freq ? .white : .secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Durasi
    private var durationSection: some View {
        formSection(title: "Durasi Berjalan", icon: "clock.fill") {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    ForEach(durationPresets, id: \.self) { days in
                        Button(action: { durationDays = days }) {
                            Text("\(days)h")
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(durationDays == days
                                              ? currentColor
                                              : Color(nsColor: .controlBackgroundColor))
                                )
                                .foregroundStyle(durationDays == days ? .white : .secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    Text("hari")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 10) {
                    Text("Custom:")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Slider(value: Binding(
                        get: { Double(durationDays) },
                        set: { durationDays = Int($0) }
                    ), in: 1...365, step: 1)
                    .tint(currentColor)
                    Text("\(durationDays) hari")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(currentColor)
                        .frame(width: 55, alignment: .trailing)
                }
            }
        }
    }

    // MARK: - Preview
    private var preview: some View {
        formSection(title: "Preview", icon: "eye.fill") {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(currentColor)
                        .frame(width: 46, height: 46)
                    Image(systemName: selectedIcon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(habitName.isEmpty ? "Nama habit..." : habitName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(habitName.isEmpty ? .tertiary : .primary)
                    HStack(spacing: 12) {
                        Label(selectedFrequency.rawValue, systemImage: "calendar")
                        Label("\(durationDays) hari", systemImage: "clock")
                    }
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                }
                Spacer()
                ProgressRing(progress: 0, lineWidth: 3, size: 30, color: currentColor)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(currentColor.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }

    // MARK: - Footer
    private var footer: some View {
        HStack(spacing: 12) {
            Button("Batal") { dismiss() }
                .buttonStyle(.plain)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)

            Spacer()

            Button(action: saveHabit) {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                    Text("Tambah Habit")
                }
                .font(.system(size: 13, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(habitName.isEmpty ? Color.accentColor.opacity(0.4) : Color.accentColor)
                )
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .disabled(habitName.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
    }

    // MARK: - Helpers
    private var currentColor: Color {
        colors.first { $0.name == selectedColor }?.color ?? .blue
    }

    private func formSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
            content()
        }
    }

    private func saveHabit() {
        let name = habitName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        store.addHabit(
            name: name,
            icon: selectedIcon,
            color: selectedColor,
            frequency: selectedFrequency,
            durationDays: durationDays
        )
        dismiss()
    }
}
