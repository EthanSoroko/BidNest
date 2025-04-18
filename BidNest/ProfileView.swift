//
//  ProfileView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    let imageNames = ["profile1", "profile2", "profile3", "profile4", "profile5", "profile6", "profile7", "profile8", "profile9"]
    
    @Environment(\.dismiss) private var dismiss
        
    @State var profileVM = ProfileViewModel()
    @State private var profileImage = ""
    @State private var showImagePicker = false
    @State private var displayName = ""
    @State private var userEmail = ""
    @State var profile: Profile
    
    var body: some View {
        VStack {
            Text("My Profile")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack(alignment: .topTrailing) {
                Image(profileImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .padding(.top)
                
                Button(action: {
                    showImagePicker.toggle()
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.appcolor)
                        .background(Color.white.clipShape(Circle()))
                        .offset(x: 5, y: -5)
                }
                .padding(.trailing, 12)
            }
            .padding(.top)
            
            if showImagePicker {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(imageNames, id: \.self) { name in
                            Button {
                                profile.profileImage = name
                                profileImage = name
                                let success = profileVM.saveProfile(profile: profile)
                                if !success {
                                    print("ERROR Saving profile on profile image change.")
                                }
                                showImagePicker = false
                            } label: {
                                Image(name)
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(profileImage == name ? Color("appcolor") : Color.clear, lineWidth: 3))
                                    .scaledToFit()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            HStack {
                Text("Display Name: ")
                    .fontWeight(.bold)
                
                TextField("Display Name", text: $displayName)
                    .onSubmit {
                        profile.displayName = displayName
                        let success = profileVM.saveProfile(profile: profile)
                        if !success {
                            print("ERROR Saving profile on display name change.")
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                
                Spacer()
            }
            .font(.title2)
            .padding()
            
            HStack {
                Text("Email: ")
                    .fontWeight(.bold)
                
                Text("\(userEmail)")
                
                Spacer()
            }
            .font(.title2)
            .padding()
            
            Spacer()
            
            Button("Log Out") {
                do {
                    try Auth.auth().signOut()
                    print("🪵 Log out successful!")
                    dismiss()
                    
                } catch {
                    print("😡 ERROR: Could not sign out!")
                }
            }
            .font(.title2)
            .tint(.appcolor)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgcolor)
        .onAppear {
            if let user = Auth.auth().currentUser {
                userEmail = user.email!
                print("Profile DN: \(profile.displayName)")
                print("Profile Image: \(profile.profileImage)")
                displayName = profile.displayName
                profileImage = profile.profileImage
            }
            let success = profileVM.saveProfile(profile: profile)
            if !success {
                print("ERROR saving profile onAppear!")
            }
        }
    }
}

#Preview {
    ProfileView(profile: Profile(id: nil, displayName: nil, profileImage: nil))
}
