//
//  Profile.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import Foundation
import FirebaseFirestore

let adjectives = ["Zesty", "Bubbly", "Wacky", "Sassy", "Snazzy",
                  "Jazzy", "Peppy", "Jolly", "Quirky", "Breezy",
                  "Goofy", "Perky", "Spunky", "Funky", "Chipper",
                  "Giddy", "Dorky", "Nifty", "Swole", "Feisty"]
let nouns = ["Taco", "Llama", "Noodle", "Penguin", "Pickle",
             "Cactus", "Gnome", "Waffle", "Muffin", "Sloth",
             "Bison", "Koala", "Disco", "Banana", "Squirrel",
             "Marshmallow", "Unicorn", "Bagel", "Robot", "Platypus"]

struct Profile: Identifiable, Codable, Equatable {
    var id: String?
    var displayName = ""
    var profileImage = ""
    
    init(id: String? = nil, displayName: String? = "", profileImage: String? = "") {
        self.id = id ?? "1"
        self.displayName = displayName ?? "\(adjectives.randomElement() ?? "")\(nouns.randomElement() ?? "")\(Int.random(in: 1...99))"
        self.profileImage = profileImage ?? "profile\(Int.random(in: 1...9))"
    }
}
