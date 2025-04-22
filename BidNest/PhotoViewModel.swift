//
//  PhotoViewModel.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/22/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI

class PhotoViewModel {
    static func saveImage(ticket: Ticket, photo: Photo, data: Data) async {
        guard let id = ticket.id else {
            print("ERROR: Should never have been called without a valid ticket.id")
            return
        }
        
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if photo.id == nil {
            photo.id = UUID().uuidString
        }
        metadata.contentType = "image/jpeg"
        let path = "\(id)/\(photo.id ?? "n/a")"
        
        do {
            let storageref = storage.child(path)
            let returnedMetaData = try await storageref.putDataAsync(data, metadata: metadata)
            print("SAVED PHOTO")
            
            guard let url = try? await storageref.downloadURL() else {
                print("ERROR: Could not get download URL")
                return
            }
            
            photo.imageURLString = url.absoluteString
            print("photo.imageURLString: \(photo.imageURLString)")
            
            let db = Firestore.firestore()
            do {
                try db.collection("tickets").document(id).collection("photos").document(photo.id ?? "n/a").setData(from: photo)
            } catch {
                print("ERROR: Could not update data in spots/\(id)/photos/\(photo.id ?? "n/a")")
            }
        } catch {
            print("Error saving photo to storage")
        }
    }
}
