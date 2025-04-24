//
//  ProfileViewModel.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class ProfileViewModel {
    func saveProfile(profile: Profile) -> Bool {
        let db = Firestore.firestore()
        
        if let id = profile.id {
            do {
                try db.collection("profiles").document(id).setData(from: profile)
                print("Data updated successfully!")
                return true
            } catch {
                print("Could not update data in 'profiles' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                try db.collection("spots").addDocument(from: profile)
                print("New Data added successfully!")
                return true
            } catch {
                print("Could not create a new profile in 'profiles' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    //    func getProfile() -> Profile {
    //        @FirestoreQuery(collectionPath: "profiles") var profiles: [Profile]
    //
    //        print("getProfile() Called!")
    //
    //        guard let uid = Auth.auth().currentUser?.uid else {
    //            print("⚠️ No current user")
    //            return Profile(id: nil, displayName: nil, profileImage: nil)
    //        }
    //
    //        print(profiles)
    //
    //        print("\(profiles.first(where: { $0.id == uid })?.displayName ?? "NOPE")")
    //
    //        return profiles.first(where: { $0.id == uid }) ?? Profile(id: uid, displayName: nil, profileImage: nil)
    //    }
    
    func getProfile() async -> Profile {
        print("getProfile() Called!")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("⚠️ No current user")
            return Profile(id: nil, displayName: nil, profileImage: nil)
        }
        
        let docRef = Firestore.firestore().collection("profiles").document(uid)
        
        do {
            let document = try await docRef.getDocument()
            if let data = document.data() {
                let profile = Profile(
                    id: uid,
                    displayName: data["displayName"] as? String,
                    profileImage: data["profileImage"] as? String
                )
                print("✅ Found profile: \(profile.displayName)")
                return profile
            } else {
                print("❗ No profile found")
                return Profile(id: uid, displayName: nil, profileImage: nil)
            }
        } catch {
            print("❌ Error fetching profile: \(error)")
            return Profile(id: uid, displayName: nil, profileImage: nil)
        }
    }
    
}
