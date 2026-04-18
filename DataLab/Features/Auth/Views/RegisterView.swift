//
//  RegisterView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 08.10.2024.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct RegisterView: View {
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @FocusState private var focusedField: FocusField?
    
    var canProceed: Bool {
        Validator.validateEmail(emailID) && Validator.validatePassword(password)
    }
    
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    
    @State var enterAccount: Bool = false
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false

    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        NavigationStack {
            Text("CreateAccTitle".localized)
                .font(.largeTitle.bold())
                .foregroundStyle(.blue)
                .hALign(.leading)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            Text("CreateAccSubTitle".localized)
                .foregroundStyle(Color("BlackApp"))
                .font(.title3)
                .hALign(.leading)
                .padding(.horizontal)
        
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                HelperView()
            }
            
            HStack {
                Text("HaveAcc".localized)
                    .foregroundStyle(.gray)
                
                Button("LoginNow".localized) {
                    enterAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundStyle(.blue)
            }
            .font(.callout)
            .vALign(.bottom)
            .padding()
        }
        .fullScreenCover(isPresented: $enterAccount) {
            LoginView()
        }
        .padding(.top, 16)
        .navigationBarBackButtonHidden(true)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { oldValue, newValue in
            if let newValue {
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    @ViewBuilder
    func HelperView()->some View{
        VStack(spacing: 12) {
            ZStack {
                if let userProfilePicData, let image = UIImage(data: userProfilePicData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(.blue)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top, 8)
            
            TextField("UserName".localized, text: $userName)
                .textContentType(.emailAddress)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color("GrayApp"), lineWidth: 3))
                .padding(.horizontal)
            
            TextField("Email".localized, text: $emailID)
                .textContentType(.emailAddress)
                .padding()
                .focused($focusedField, equals: .email)
                .background(RoundedRectangle(cornerRadius: 12)
                    .stroke(!isValidEmail ? .red : focusedField == .email ? Color(.blue): Color("GrayApp"), lineWidth: 3))
                .padding(.horizontal)
                .onChange(of: emailID) { oldValue, newValue in
                    isValidEmail = Validator.validateEmail(newValue)
                }
            
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
                .onChange(of: password) { oldValue, newValue in
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
            
            TextField("AboutYou".localized, text: $userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.emailAddress)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color("GrayApp"), lineWidth: 3))
                .padding(.horizontal)
            
            TextField("BioLink".localized, text: $userBioLink)
                .textContentType(.emailAddress)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color("GrayApp"), lineWidth: 3))
                .padding(.horizontal)
                .padding(.bottom)
            
            Button(action: registerUser) {
                Text("SignUp".localized)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(Color(.blue))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || password == "" || userProfilePicData == nil)
        }
    }
    
    func registerUser() {
        isLoading = true

        closeKeyboard()
        
        Task {
            do {
                // Creating Firebase Account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                // Uploading Profile Photo into Firebase Storage
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                guard let imageData = userProfilePicData else {return}
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                
                // Downloading Photo URL
                let downloadURL = try await storageRef.downloadURL()
                
                //Creating a User Firestore Object
                let user = User(username: userName, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                
                // Saving User Doc into Firestore Database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
                    if error == nil {
                        
                        print("Saved Successfully")
                        
                        userNameStored = userName
                        self.userUID = userUID
                        profileURL = downloadURL
                        logStatus = true
                    }
                    
                })
            } catch{
                try await Auth.auth().currentUser?.delete()
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
    RegisterView()
}
