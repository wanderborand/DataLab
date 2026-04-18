//
//  LoginView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 08.10.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

enum FocusField {
    case email
    case password
}

struct LoginView: View {
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @FocusState private var focusedField: FocusField?
    
    var canProceed: Bool {
        Validator.validateEmail(emailID) && Validator.validatePassword(password)
    }

    @State var emailID: String = ""
    @State var password: String = ""
   
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        NavigationStack {
            Text("Welcome".localized)
                .font(.largeTitle.bold())
                .foregroundStyle(.blue)
                .hALign(.leading)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            Text("WelcomeSubTitle".localized)
                .font(.title3)
                .hALign(.leading)
                .foregroundStyle(Color("BlackApp"))
                .padding(.horizontal)
                .padding(.bottom, 80)
            
            TextField("Email".localized, text: $emailID)
                .textContentType(.emailAddress)
                .focused($focusedField, equals: .email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12)
                    .stroke(!isValidEmail ? .red : focusedField == .email ? Color(.blue): Color("GrayApp"), lineWidth: 3))
                .padding(.horizontal)
                .onChange(of: emailID) { oldValue, newValue in
                    isValidEmail = Validator.validateEmail(newValue)
                }
                .padding(.bottom, isValidEmail ? 16 : 0)
            
            if !isValidEmail {
                HStack {
                    Text("EmailNotValid".localized)
                        .foregroundStyle(.red)
                        .padding(.leading)
                    
                    Spacer()
                }
                .padding(.bottom)
            }
            
            SecureField("Password".localized, text: $password)
                .textContentType(.emailAddress)
                .focused($focusedField, equals: .password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12)
                    .stroke(!isValidPassword ? .red : focusedField == .password ? Color(.blue): Color("GrayApp"), lineWidth: 3))
                .padding(.horizontal)
                .onChange(of: password) {oldValue, newValue in
                    isValidPassword = Validator.validatePassword(newValue)
                }
            if !isValidPassword {
                HStack {
                    Text("PasswordNotValid".localized)
                        .foregroundStyle(.red)
                        .padding(.leading)
                    
                    Spacer()
                }
            }
            
            HStack {
                Spacer()
                Button("ForgotPassword".localized, action: resetPassword)
                    .foregroundStyle(.blue)
                    .font(.system(size: 14, weight: .semibold))
                    .padding()
                    .padding(.bottom)
            }
            
            Button(action: loginUser) {
                Text("SignIn".localized)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(Color(.blue))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .opacity(canProceed ? 1.0 : 0.5)
            .disabled(!canProceed)

            HStack {
                Text("DontHaveAcc".localized)
                    .foregroundStyle(.gray)
                
                Button("RegisterNow".localized) {
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundStyle(.blue)
            }
            .font(.callout)
            .vALign(.bottom)
            .padding()
        }
        .padding(.top, 16)
        .navigationBarBackButtonHidden(true)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func loginUser() {
        isLoading = true
        closeKeyboard()
        Task{
            do {
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("UserFound".localized)
                try await fetchUser()
            }catch{
                await setError(error)
            }
        }
    }
    
    func fetchUser()async throws {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        await MainActor.run(body: {
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        })
    }
    
    func resetPassword(){
        Task{
            do {
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("LinkSent".localized)
            }catch{
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error) async{
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

#Preview {
    LoginView()
}
