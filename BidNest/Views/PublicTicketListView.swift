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
    @State private var selectedEventType: EventType? = nil
    @State private var filteredTickets: [Ticket] = []
    @State private var auctionInfoShown = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
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
                    
                    Spacer()
                    
                    Button("Auction Info", systemImage: "info.circle") {
                        auctionInfoShown.toggle()
                    }
                    .tint(.appcolor)
                    .frame(maxWidth: .infinity)
                    .background(.bgcolor)
                }
                .background(.bgcolor)
                
                Divider()
                    .background(.bgcolor)
                    .padding([.leading, .trailing])
                
                List {
                    ForEach(filteredTickets) { ticket in
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
                .task {
                    await fetchFilteredTickets()
                }
                .navigationTitle("Public Ticket Auction:")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.trailing)
                .background(Color.bgcolor)
                .listStyle(.plain)
                .listItemTint(.appcolor)
                .sheet(isPresented: $sheetIsPresented) {
                    NavigationStack {
                        TicketCreateView(ticket: Ticket())
                    }
                }
                .sheet(isPresented: $auctionInfoShown) {
                    AuctionInfoView()
                }
            }
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
    NavigationStack {
        UserPostingListView()
    }
}
