//
//  UserTicketListView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import SwiftUI

struct UserTicketListView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Sample Ticket!")
            }
            .navigationTitle("Tickets:")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //TODO: Add button code
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.appcolor)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgcolor)
            .listStyle(.plain)
            .listItemTint(.appcolor)
        }
    }
}

#Preview {
    UserTicketListView()
}
