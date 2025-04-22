//
//  TicketDeleteView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/21/25.
//

import SwiftUI

struct TicketDeleteView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var profileVM = ProfileViewModel()
    @State private var ticketVM = TicketViewModel()
    @State private var profile = Profile()
    @State var ticket: Ticket
    @State private var price = "0.00"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(ticket.eventName)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
            
            HStack {
                Text("Event Type:")
                    .fontWeight(.bold)
                
                Text(ticket.eventType.displayName)
            }
            .font(.title2)
            .padding(.bottom)
            
            HStack {
                Text("Date:")
                    .fontWeight(.bold)
                
                Text(String(ticket.date.formatted()))
            }
            .font(.title2)
            .padding(.bottom)
            
            HStack {
                Text("Location:")
                    .fontWeight(.bold)
                
                Text(ticket.location)
            }
            .font(.title2)
            .padding(.bottom)
            
            HStack {
                Text("Seat Info:")
                    .fontWeight(.bold)
                
                Text(ticket.additionalInfo ?? "")
            }
            .font(.title2)
            .padding(.bottom)
            
            HStack {
                Text("Current Auction Price:")
                    .fontWeight(.bold)
                
                Text("\(ticket.price.formatted(.currency(code: "USD")))")
            }
            .font(.title2)
            
            HStack {
                Text("Current Highest Bidder:")
                    .fontWeight(.bold)
                
                Text(ticket.highestBidderId == profile.id ? "None" : ticket.highestBidderName)
            }
            .font(.title2)
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Delete Ticket") {
                    Task {
                        await ticketVM.deleteTicket(ticket: ticket)
                    }
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.bgcolor)
        .toolbarVisibility(.hidden, for: .tabBar)
    }
}

#Preview {
    TicketDeleteView(ticket: Ticket(
        eventName: "Boston College vs. Notre Dame",
        eventType: .football,
        location: "Alumni Stadium",
        date: Date().addingTimeInterval(86400),
        price: 45.00,
        sellerId: "ABC",
        sellerName: "ABC",
        isSold: false,
        additionalInfo: "Student section, row 12"
    ))
}
