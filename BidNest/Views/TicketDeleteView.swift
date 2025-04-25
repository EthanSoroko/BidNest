//
//  TicketDeleteView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/21/25.
//

import SwiftUI
import FirebaseFirestore

struct TicketDeleteView: View {
    @Environment(\.dismiss) private var dismiss
    @FirestoreQuery(collectionPath: "tickets") var photos: [Photo]
    @State private var profileVM = ProfileViewModel()
    @State private var ticketVM = TicketViewModel()
    @State private var profile = Profile()
    @State var ticket: Ticket
    @State private var price = "0.00"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(ticket.eventName)
                .font(.custom("Menlo", size: 30))
                .fontWeight(.bold)
                .padding(.bottom)
            
            HStack {
                Text("Event Type:")
                    .fontWeight(.bold)
                
                Text(ticket.eventType.displayName)
            }
            .padding(.bottom)
            
            HStack {
                Text("Date:")
                    .fontWeight(.bold)
                
                Text(String(ticket.date.formatted()))
            }
            .padding(.bottom)
            
            HStack {
                Text("Location:")
                    .fontWeight(.bold)
                
                Text(ticket.location)
            }
            .padding(.bottom)
            
            HStack {
                Text("Seat Info:")
                    .fontWeight(.bold)
                
                Text(ticket.additionalInfo ?? "")
            }
            .padding(.bottom)
            
            HStack {
                Text("Current Auction Price:")
                    .fontWeight(.bold)
                
                Text("\(ticket.price.formatted(.currency(code: "USD")))")
            }
            .padding(.bottom)
            
            HStack {
                Text("Current Highest Bidder:")
                    .fontWeight(.bold)
                
                Text(ticket.highestBidderId == profile.id ? "None" : ticket.highestBidderName)
            }
            .padding(.bottom)
            
            if let photo = photos.first, let url = URL(string: photo.imageURLString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .frame(maxWidth: .infinity, alignment: .center)
                } placeholder: {
                    ProgressView()
                        .tint(.appcolor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            } else {
                Text("Ticket Photo Missing.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
        }
        .padding(.bottom, 20)
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
        .font(.custom("Menlo", size: 20))
        .navigationBarBackButtonHidden()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.bgcolor)
        .toolbarVisibility(.hidden, for: .tabBar)
        .task {
            profile = await profileVM.getProfile()
            if ticket.id != nil {
                $photos.path = "tickets/\(ticket.id ?? "")/photos"
            }
        }
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
