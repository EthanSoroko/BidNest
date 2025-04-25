//
//  AuctionInfoView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/24/25.
//

import SwiftUI

struct AuctionInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "storefront.circle")
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()
            
            Text("Auction Rules:")
                .font(.custom("Menlo", size: 30))
                .fontWeight(.bold)
                .padding(.bottom)
            
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text("1: Must bid a minimum of the current auction price.")
                
                Text("2: Can only bid again when you are outbid.")
                
                Text("3: Auction ends 2 hours before event start time.")
            }
            .font(.custom("Menlo", size: 20))
            .padding(.bottom, 10)
            
            
            Button("Okay") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.appcolor)
            .font(.custom("Menlo", size: 20))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgcolor)
        .presentationDetents([.medium])
    }
}

#Preview {
    AuctionInfoView()
}
