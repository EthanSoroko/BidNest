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
    @State var profile: Profile
    
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
            
            ProfileView(profile: profile)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .toolbarBackground(Color("toolbarcolor"), for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
        }
        .tint(.appcolor)
        .onAppear() {
            print("Profile: \(profile.id!)")
            print("Profile DN: \(profile.displayName)")
            print("Profile Image: \(profile.profileImage)")
        }
    }
}

#Preview {
    TicketTabView(profile: Profile(id: nil, displayName: nil, profileImage: nil))
}
