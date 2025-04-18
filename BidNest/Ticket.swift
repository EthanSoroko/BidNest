//
//  Ticket.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/17/25.
//

import Foundation
import FirebaseFirestore

enum EventType: String, Codable, CaseIterable, Identifiable {
    case football, basketball, hockey, baseball, soccer, concert, theater, other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .football: 
            return "Football"
        case .basketball: 
            return "Basketball"
        case .hockey: 
            return "Hockey"
        case .baseball: 
            return "Baseball"
        case .soccer: 
            return "Soccer"
        case .concert: 
            return "Concert"
        case .theater: 
            return "Theater"
        case .other: 
            return "Other"
        }
    }

    var systemIconName: String {
        switch self {
        case .football:
            return "american.football.fill"
        case .basketball:
            return "basketball.fill"
        case .hockey:
            return "figure.hockey"
        case .baseball:
            return "figure.baseball"
        case .soccer:
            return "soccerball"
        case .concert: 
            return "music.mic"
        case .theater: 
            return "theatermasks.fill"
        case .other:
            return "ticket.fill"
        }
    }
}

struct Ticket: Identifiable, Codable {
    @DocumentID var id: String?

    var eventName: String = ""
    var eventType: EventType = .football
    var location: String = ""
    var date: Date = Date()
    var price: Double = 0.00
    var sellerId: String = ""
    var sellerName: String = ""
    var isSold: Bool = false
    var additionalInfo: String? = ""

    var timestamp: Timestamp {
        Timestamp(date: date)
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
