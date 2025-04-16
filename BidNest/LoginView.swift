//
//  LoginView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var passwordInfoShown = false
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack {
            Text("BidNest")
                .font(.custom("Menlo", size: 80))
                .fontWeight(.bold)
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding(.bottom)
            
            Group {
                TextField("email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) {
                        enableButtons()
                    }
                
                SecureField("password", text: $password)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }
                    .onChange(of: password) {
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            
            HStack {
                Button("Sign Up") {
                    register()
                }
                .padding(.trailing)
                
                Button("Log In") {
                    //TODO: Action Here
                }
                .padding(.leading)
            }
            .padding(.top)
            .buttonStyle(.borderedProminent)
            .tint(.appcolor)
            .font(.title2)
            .disabled(buttonDisabled)
            
            Button("Password Info", systemImage: "info.circle") {
                passwordInfoShown.toggle()
            }
            .padding(.top)
            .tint(.appcolor)
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgcolor)
        .sheet(isPresented: $passwordInfoShown) {
            PasswordInfoView()
        }
    }
    
    func enableButtons() {
        let emailIsGood = isValidEmail(email)
        let passwordIsGood = isValidPassword(password)
        
        buttonDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // At least 10 characters, 1 uppercase, 1 number, and 1 special character
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*.,?])[A-Za-z\\d!@#$&*.,?]{10,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: password)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 Sign Up Error: \(error.localizedDescription)")
                alertMessage = "Sign Up Error: Password must be at least 10 characters and include an uppercase letter, a number, and a special symbol."
                showingAlert = true
            } else {
                print("😎 Registration Success!")
                //TODO: Load NextView
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 Log In Error: \(error.localizedDescription)")
                alertMessage = "Log In Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Log In Success!")
                //TODO: Load NextView
            }
        }
    }
}

#Preview {
    LoginView()
}
