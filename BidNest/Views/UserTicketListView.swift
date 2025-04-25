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
    @State private var selectedEventType: EventType? = nil
    @State private var filteredTickets: [Ticket] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedEventType) {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text(" All")
                    }.tag(nil as EventType?)
                    
                    ForEach(EventType.allCases, id: \.self) { eventType in
                        HStack {
                            Image(systemName: eventType.systemIconName)
                            Text(" \(eventType.displayName)")
                        }.tag(Optional(eventType))
                    }
                }
                .pickerStyle(.automatic)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.bgcolor)
                .onChange(of: selectedEventType) {
                    Task {
                        print("fetching filtered tickets")
                        await fetchFilteredTickets()
                    }
                }
                
                Divider()
                    .background(.bgcolor)
                    .padding([.leading, .trailing])
                
                List {
                    ForEach(filteredTickets) { ticket in
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
                                    
                                    HStack {
                                        Text("\(ticket.date.formatted())")
                                        
                                        Spacer()
                                        
                                        Text("$\(ticket.price.formatted(.number.precision(.fractionLength(2))))")
                                            .padding(.trailing)
                                    }
                                    .font(.custom("Menlo", size: 15))
                                }
                            }
                            .listRowBackground(Color.bgcolor.opacity(0.1))
                        }
                    }
                }
                .task {
                    await fetchFilteredTickets()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Bought Tickets")
                            .padding(.top, 60)
                            .font(.custom("Menlo", size: 28))
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.trailing)
                .background(Color.bgcolor)
                .listStyle(.plain)
                .listItemTint(.appcolor)
            }
            .font(.custom("Menlo", size: 20))
        }
    }
    
    func fetchFilteredTickets() async {
        let db = Firestore.firestore()
        do {
            var query: Query = db.collection("tickets")
            
            if let eventType = selectedEventType {
                query = query.whereField("eventType", isEqualTo: eventType.rawValue)
            }
            
            let snapshot = try await query.getDocuments()
            let tickets = snapshot.documents.compactMap { doc in
                try? doc.data(as: Ticket.self)
            }
            
            DispatchQueue.main.async {
                self.filteredTickets = tickets
            }
        } catch {
            print("❌ Error fetching tickets: \(error)")
        }
    }
}

#Preview {
    UserPostingListView()
}
