//
//  UserTicketListView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct UserTicketListView: View {
    @State private var sheetIsPresented = false
    @FirestoreQuery(collectionPath: "tickets") var tickets: [Ticket]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tickets) { ticket in
                    if ticket.highestBidderId == Auth.auth().currentUser?.uid && ticket.date < Date() {
                        NavigationLink {
                            TicketOwnedView(ticket: ticket)
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
            .navigationTitle("Owned Tickets:")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgcolor)
            .listStyle(.plain)
            .listItemTint(.appcolor)
        }
    }
}

#Preview {
    UserPostingListView()
}
