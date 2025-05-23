//
//  TicketBidView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/18/25.
//

import SwiftUI

struct TicketBidView: View {
    enum Field: Hashable {
        case ticketPrice
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var profileVM = ProfileViewModel()
    @State private var ticketVM = TicketViewModel()
    @State private var profile = Profile()
    @State var ticket: Ticket
    @State private var bidOffer = "0.00"
    @State private var bidOffers = ["1.00", "1.00", "1.00"]
    @State private var bidDisabled = true
    @FocusState private var focusField: Field?
    
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
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Text(ticket.highestBidderId == ticket.sellerId ? "None" : ticket.highestBidderName)
            }
            .padding(.bottom)
            
            HStack {
                Text("Your Bid (USD):")
                    .fontWeight(.bold)
                
                TextField("Enter Price", text: $bidOffer)
                    .keyboardType(.decimalPad)
                    .submitLabel(.done)
                    .onChange(of: bidOffer) {
                        let filtered = filterPriceInput(bidOffer)
                        bidOffer = filtered
                    }
                    .textFieldStyle(.roundedBorder)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    focusField = nil
                                }
                            }
                        }
                    .focused($focusField, equals: .ticketPrice)
            }
            .padding(.bottom)
            
            HStack {
                Text("Suggested Bids (USD):")
                    .fontWeight(.bold)
                
                Picker("", selection: $bidOffer) {
                    ForEach(bidOffers, id: \.self) { offer in
                        Text(offer)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Button("Place Bid") {
                let newTicket = Ticket(
                    id: ticket.id,
                    eventName: ticket.eventName,
                    eventType: ticket.eventType,
                    location: ticket.location,
                    date: ticket.date,
                    price: Double(bidOffer) ?? -1.00,
                    sellerId: ticket.sellerId,
                    sellerName: ticket.sellerName,
                    isSold: false,
                    additionalInfo: ticket.additionalInfo,
                    highestBidderId: profile.id ?? "1",
                    highestBidderName: profile.displayName
                )
                
                let savedTicket = ticketVM.saveTicket(ticket: newTicket)
                
                if savedTicket != nil {
                    print("Successfully saved ticket!")
                } else {
                    print("Failed to save ticket.")
                }
                dismiss()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .buttonStyle(.borderedProminent)
            .tint(.appcolor)
            .disabled(bidDisabled)
            
            if ticket.highestBidderId == profile.id {
                Text("Cannot bid again until you are outbid!")
                    .font(.title2)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
            Spacer()
        }
        .font(.custom("Menlo", size: 20))
        .onAppear() {
            bidOffers[0] = String(Double((Double(bidOffers[0]) ?? 1.00) * ticket.price * 1.1).formatted(.number.precision(.fractionLength(2))))
            bidOffers[1] = String(Double((Double(bidOffers[1]) ?? 1.00) * ticket.price * 1.25).formatted(.number.precision(.fractionLength(2))))
            bidOffers[2] = String(Double((Double(bidOffers[2]) ?? 1.00) * ticket.price * 1.5).formatted(.number.precision(.fractionLength(2))))
        }
        .task {
            profile = await profileVM.getProfile()
        }
        .submitLabel(.done)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.bgcolor)
        .toolbarVisibility(.hidden, for: .tabBar)
        .onChange(of: bidOffer) {
            if Double(bidOffer) ?? -1.00 > ticket.price && ticket.highestBidderId != profile.id {
                bidDisabled = false
            } else {
                bidDisabled = true
            }
        }
    }
    
    func filterPriceInput(_ input: String) -> String {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        var filtered = input.filter { char in
            char.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }
        }
        
        // Only allow one decimal point
        let components = filtered.components(separatedBy: ".")
        if components.count > 2 {
            filtered = components[0] + "." + components[1]
        }
        
        // Limit to two decimal places if there's a decimal
        if let dotIndex = filtered.firstIndex(of: ".") {
            let decimalPart = filtered[filtered.index(after: dotIndex)...]
            if decimalPart.count > 2 {
                let endIndex = filtered.index(dotIndex, offsetBy: 3)
                filtered = String(filtered[..<endIndex])
            }
        }
        
        return filtered
    }
}

#Preview {
    TicketBidView(ticket: Ticket(
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
