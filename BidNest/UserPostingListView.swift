//
//  UserPostingListView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct UserPostingListView: View {
    @FirestoreQuery(collectionPath: "tickets") var tickets: [Ticket]
    @Environment(\.dismiss) private var dismiss
    @State private var sheetIsPresented = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tickets) { ticket in
                    Text(ticket.eventName)
                }
            }
            .navigationTitle("My Postings:")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sheetIsPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.appcolor)
                    .font(.title2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgcolor)
            .listStyle(.plain)
            .listItemTint(.appcolor)
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    TicketEditView(ticket: Ticket())
                }
            }
        }
    }
}

#Preview {
    UserPostingListView()
}
