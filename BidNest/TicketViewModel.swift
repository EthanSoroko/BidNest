//
//  TicketViewModel.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/17/25.
//

import Foundation
import FirebaseFirestore

@Observable
class TicketViewModel {
    
    func saveTicket(ticket: Ticket) -> Bool {
        let db = Firestore.firestore()

        if let id = ticket.id {
            do {
                try db.collection("tickets").document(id).setData(from: ticket)
                print("Ticket updated successfully!")
                return true
            } catch {
                print("Could not update ticket in 'tickets': \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                try db.collection("tickets").addDocument(from: ticket)
                print("New ticket added successfully!")
                return true
            } catch {
                print("Could not create a new ticket in 'tickets': \(error.localizedDescription)")
                return false
            }
        }
    }
}
