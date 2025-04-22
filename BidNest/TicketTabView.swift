//
//  TicketTabView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct TicketTabView: View {
    @FirestoreQuery(collectionPath: "profiles") var profiles: [Profile]
    @State private var profileVM = ProfileViewModel()
    @State var profile: Profile
    @State private var loadView = false

    var body: some View {
        TabView {
            PublicTicketListView()
                .tabItem {
                    Image(systemName: "ticket.fill")
                    Text("Tickets")
                }
                .toolbarBackground(Color("toolbarcolor"), for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)

            UserPostingListView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("My Listings")
                }
                .toolbarBackground(Color("toolbarcolor"), for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)

            UserTicketListView()
                .tabItem {
                    Image(systemName: "wallet.bifold.fill")
                    Text("My Tickets")
                }
                .toolbarBackground(Color("toolbarcolor"), for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)

            if loadView {
                ProfileView(profile: profile)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                    .toolbarBackground(Color("toolbarcolor"), for: .tabBar)
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
        }
        .tint(.appcolor)
        .onAppear {
            print("Profile: \(profile.id!)")
        }
        .task {
            profile = await profileVM.getProfile()
            loadView = true
        }
    }
}

#Preview {
    TicketTabView(profile: Profile(id: nil, displayName: nil, profileImage: nil))
}

