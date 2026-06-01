import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthStore
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @FocusState private var focusedField: Field?

    enum Field { case username, password }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(nsColor: .windowBackgroundColor),
                    Color.blue.opacity(0.04),
                    Color.purple.opacity(0.06),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                loginCard
                Spacer()
            }
        }
        .frame(minWidth: 420, minHeight: 500)
    }

    private var loginCard: some View {
        VStack(spacing: 28) {
            appLogo
            formSection
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.12), radius: 30, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color(nsColor: .separatorColor).opacity(0.4), lineWidth: 0.5)
        )
        .frame(width: 360)
    }

    private var appLogo: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 72, height: 72)
                    .shadow(color: .blue.opacity(0.3), radius: 12, y: 4)

                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 4) {
                Text("Habio")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                Text("Track your daily habits")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var formSection: some View {
        VStack(spacing: 14) {
            // Username
            VStack(alignment: .leading, spacing: 6) {
                Label("Username", systemImage: "person")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)

                TextField("Masukkan username", text: $username)
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
                                        focusedField == .username ? Color.accentColor : Color(nsColor: .separatorColor),
                                        lineWidth: focusedField == .username ? 1.5 : 0.5
                                    )
                            )
                    )
                    .focused($focusedField, equals: .username)
                    .onSubmit { focusedField = .password }
            }

            // Password
            VStack(alignment: .leading, spacing: 6) {
                Label("Password", systemImage: "lock")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)

                HStack {
                    Group {
                        if isPasswordVisible {
                            TextField("Masukkan password", text: $password)
                        } else {
                            SecureField("Masukkan password", text: $password)
                        }
                    }
                    .textFieldStyle(.plain)
                    .font(.system(size: 14))
                    .focused($focusedField, equals: .password)
                    .onSubmit { attemptLogin() }

                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(nsColor: .textBackgroundColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(
                                    focusedField == .password ? Color.accentColor : Color(nsColor: .separatorColor),
                                    lineWidth: focusedField == .password ? 1.5 : 0.5
                                )
                        )
                )
            }

            // Error message
            if let error = auth.loginError {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(.red)
                    Text(error)
                        .foregroundStyle(.red)
                }
                .font(.system(size: 12, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Login button
            Button(action: attemptLogin) {
                HStack {
                    Spacer()
                    Text("Masuk")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                }
                .padding(.vertical, 11)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(username.isEmpty || password.isEmpty
                              ? Color.accentColor.opacity(0.4)
                              : Color.accentColor)
                )
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .disabled(username.isEmpty || password.isEmpty)
            .padding(.top, 4)
        }
        .animation(.spring(response: 0.3), value: auth.loginError)
    }

    private func attemptLogin() {
        auth.login(username: username.trimmingCharacters(in: .whitespaces),
                   password: password)
    }
}
