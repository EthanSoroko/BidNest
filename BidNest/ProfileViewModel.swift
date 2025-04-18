//
//  ProfileViewModel.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import Foundation
import FirebaseFirestore

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
    
    func getProfile() -> Profile {
        print("getProfile() Called!")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("⚠️ No current user")
            return Profile(id: nil, displayName: nil, profileImage: nil)
        }
        
        print(profiles)
        
        print("\(profiles.first(where: { $0.id == uid })?.displayName ?? "NOPE")")
        
        return profiles.first(where: { $0.id == uid }) ?? Profile(id: uid, displayName: nil, profileImage: nil)
    }
}
