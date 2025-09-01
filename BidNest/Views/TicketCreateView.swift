//
//  TicketCreateView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/17/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct TicketCreateView: View {
    enum Field {
        case eventName
        case venue
        case additionalInfo
        case ticketPrice
    }
    
    @FirestoreQuery(collectionPath: "tickets") var photos: [Photo]
    @State private var profileVM = ProfileViewModel()
    @State private var ticketVM = TicketViewModel()
    @State private var eventName = ""
    @State private var eventType: EventType = .football
    @State private var date = Date()
    @State private var location = ""
    @State private var price = ""
    @State private var additionalInfo = ""
    @State private var profile = Profile()
    @State var ticket: Ticket
    @State private var photoSheetIsPresented = false
    @FocusState private var focusField: Field?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView() {
            Text("New Ticket")
                .font(.custom("Menlo", size: 30))
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            HStack {
                Text("Event Name:")
                
                TextField("Event Name", text: $eventName)
                    .textFieldStyle(.roundedBorder)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                    .focused($focusField, equals: .eventName)
            }
            .padding(.bottom, 20)
            
            HStack {
                Text("Event Type:")
                
                Spacer()
                
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
            .padding(.bottom, 20)
            
            HStack {
                DatePicker("Date:", selection: $date)
            }
            .padding(.bottom, 20)
            
            HStack {
                Text("Location:")
                
                TextField("Address / Venue", text: $location)
                    .textFieldStyle(.roundedBorder)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                    .focused($focusField, equals: .venue)
            }
            .padding(.bottom, 20)
            
            HStack {
                Text("Seat Info:")
                
                TextField("Seat No. & Section", text: $additionalInfo)
                    .textFieldStyle(.roundedBorder)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                    .focused($focusField, equals: .additionalInfo)
            }
            .padding(.bottom, 20)
            
            HStack {
                Text("Starting Price (USD):")
                
                TextField("Enter Price", text: $price)
                    .keyboardType(.decimalPad)
                    .submitLabel(.done)
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
            .padding(.bottom, 20)
            
            Button {
                Task {
                    if ticket.id == nil {
                        let newTicket = Ticket(
                            id: ticket.id,
                            eventName: eventName,
                            eventType: eventType,
                            location: location,
                            date: date,
                            price: Double(price) ?? 1.00,
                            sellerId: profile.id!,
                            sellerName: profile.displayName,
                            isSold: false,
                            additionalInfo: additionalInfo,
                            highestBidderId: profile.id ?? "1",
                            highestBidderName: profile.displayName
                        )
                        let savedTicket = ticketVM.saveTicket(ticket: newTicket)
                        if savedTicket == nil {
                            print("ERROR Saving ticket before adding image")
                        } else {
                            print("Created new ticket while pressing photo button")
                            ticket = savedTicket!
                        }
                        photoSheetIsPresented.toggle()
                    } else {
                        photoSheetIsPresented.toggle()
                    }
                }
            } label: {
                Image(systemName: "camera.fill")
                Text("Photo of Ticket")
            }
            .buttonStyle(.borderedProminent)
            .tint(.appcolor)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 20)
            
            if let photo = photos.first, let url = URL(string: photo.imageURLString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .frame(maxWidth: .infinity, alignment: .center)
                } placeholder: {
                    ProgressView()
                        .tint(.appcolor)
                }
            } else {
                Text("Please add ticket photo.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
        }
        .font(.custom("Menlo", size: 20))
        .onAppear() {
            eventName = ticket.eventName
            eventType = ticket.eventType
            date = ticket.date
            location = ticket.location
            additionalInfo = ticket.additionalInfo ?? ""
        }
        .padding()
        .fullScreenCover(isPresented: $photoSheetIsPresented) {
            PhotoView(ticket: $ticket)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.bgcolor)
        .navigationBarBackButtonHidden()
        .task {
            profile = await profileVM.getProfile()
        }
        .submitLabel(.done)
        .onSubmit{
            focusField = nil
        }
        .onChange(of: ticket.id) {
            Task {
                if ticket.id != nil {
                    $photos.path = "tickets/\(ticket.id ?? "")/photos"
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let newTicket = Ticket(
                        id: ticket.id,
                        eventName: eventName,
                        eventType: eventType,
                        location: location,
                        date: date,
                        price: Double(price) ?? 1.00,
                        sellerId: profile.id!,
                        sellerName: profile.displayName,
                        isSold: false,
                        additionalInfo: additionalInfo,
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
    TicketCreateView(ticket: Ticket(
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

