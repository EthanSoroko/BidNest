//
//  Photo.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/22/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = ""
}
