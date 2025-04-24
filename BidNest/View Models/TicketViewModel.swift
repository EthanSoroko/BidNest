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
    func saveTicket(ticket: Ticket) -> Ticket? {
        let db = Firestore.firestore()
        var updatedTicket = ticket
        
        do {
            if let id = ticket.id {
                // If ticket has an ID, update the existing document
                try db.collection("tickets").document(id).setData(from: ticket)
                print("✅ Ticket updated with ID: \(id)")
                return updatedTicket
            } else {
                // Otherwise, add a new document
                let ticketRef = try db.collection("tickets").addDocument(from: ticket)
                updatedTicket.id = ticketRef.documentID
                print("✅ Ticket created with ID: \(updatedTicket.id ?? "Unknown")")
                return updatedTicket
            }
        } catch {
            print("❌ Failed to save ticket: \(error)")
            return nil
        }
    }
    
    
    func deleteTicket(ticket: Ticket) async -> Bool {
        let db = Firestore.firestore()
        
        guard let id = ticket.id else {
            print("Ticket ID is nil; cannot delete.")
            return false
        }
        
        do {
            try await db.collection("tickets").document(id).delete()
            print("Ticket deleted successfully!")
            return true
        } catch {
            print("Could not delete ticket in 'tickets': \(error.localizedDescription)")
            return false
        }
    }
}
