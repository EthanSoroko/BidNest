//
//  TicketEditView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/17/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth


struct TicketEditView: View {
    @State private var profileVM = ProfileViewModel()
    @State private var ticketVM = TicketViewModel()
    @State var ticket: Ticket
    @State private var eventName = ""
    @State private var eventType: EventType = .football
    @State private var date = Date()
    @State private var location = ""
    @State private var price = ""
    @State private var additionalInfo = ""
    @State private var profile = Profile()
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("My Ticket")
                .font(.title)
                .fontWeight(.bold)
            
            HStack {
                Text("Event Name:")
                
                TextField("Event Name", text: $eventName, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .font(.title2)
            
            HStack {
                Text("Event Type:")
                
                Picker("", selection: $eventType) {
                    ForEach(EventType.allCases, id: \.self) { eventType in
                        HStack {
                            Image(systemName: eventType.systemIconName)
                            
                            Text(" \(eventType.displayName)")
                        }
                    }
                }
                .pickerStyle(.automatic)
                .buttonStyle(.bordered)
                .tint(.appcolor)
            }
            .font(.title2)
            
            HStack {
                DatePicker("Date:", selection: $date)
            }
            .font(.title2)
            
            HStack {
                Text("Location:")
                
                TextField("Address / Venue", text: $location, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .font(.title2)
            
            HStack {
                Text("Seat Info:")
                
                TextField("Seat No. & Section", text: $location, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .font(.title2)
            
            HStack {
                Text("Starting Price:")
                
                TextField("Enter Price", text: $price)
                    .keyboardType(.decimalPad)
                    .onChange(of: price) {
                        let filtered = filterPriceInput(price)
                        price = filtered
                    }
                    .textFieldStyle(.roundedBorder)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .font(.title2)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.bgcolor)
        .task {
            profile = await profileVM.getProfile()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let success = ticketVM.saveTicket(ticket: Ticket(eventName: eventName, eventType: eventType, location: location, price: Double(price)!, sellerId: profile.id!, sellerName: profile.displayName, isSold: false, additionalInfo: additionalInfo))
                    
                    if success {
                        print("Successfully saved ticket!")
                    } else {
                        print("Failed to save ticket.")
                    }
                    dismiss()
                }
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
    TicketEditView(ticket: Ticket(
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
