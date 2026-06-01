import Foundation
import SwiftUI

class AuthStore: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var loginError: String? = nil

    private let validUsername = "maco"
    private let validPassword = "123"

    func login(username: String, password: String) {
        if username == validUsername && password == validPassword {
            withAnimation(.spring(response: 0.4)) {
                isLoggedIn = true
                loginError = nil
            }
        } else {
            loginError = "Username atau password salah."
        }
    }

    func logout() {
        withAnimation(.spring(response: 0.4)) {
            isLoggedIn = false
        }
    }
}
