//
//  PublicTicketListView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct PublicTicketListView: View {
    @FirestoreQuery(collectionPath: "tickets") var tickets: [Ticket]
    @Environment(\.dismiss) private var dismiss
    @State private var sheetIsPresented = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tickets) { ticket in
                    if ticket.sellerId != Auth.auth().currentUser?.uid && ticket.date > Date() {
                        NavigationLink {
                            TicketBidView(ticket: ticket)
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: ticket.eventType.systemIconName)
                                        .foregroundStyle(.appcolor)
                                    
                                    Text(ticket.eventName)
                                }
                                .font(.title2)
                                
                                HStack {
                                    Text("\(ticket.date.formatted())")
                                    
                                    Spacer()
                                    
                                    Text("$\(ticket.price.formatted(.number.precision(.fractionLength(2))))")
                                        .padding(.trailing)
                                }
                            }
                        }
                        .listRowBackground(Color.bgcolor.opacity(0.1))
                    }
                }
            }
            .navigationTitle("Ticket Postings:")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgcolor)
            .listStyle(.plain)
            .listItemTint(.appcolor)
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    TicketCreateView(ticket: Ticket())
                }
            }
        }
    }
}

#Preview {
    UserPostingListView()
}
