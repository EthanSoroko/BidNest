//
//  PhotoView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/22/25.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @Binding var ticket: Ticket
    @State private var photo = Photo()
    @State private var data = Data()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            selectedImage
                .resizable()
                .scaledToFit()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .tint(.appcolor)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task {
                                print("Ticket id: \(ticket.id ?? "")")
                                print("Ticket name: \(ticket.eventName)")
                                await PhotoViewModel.saveImage(ticket: ticket, photo: photo, data: data)
                                dismiss()
                            }
                        }
                        .tint(.appcolor)
                    }
                }
                .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto) {
                    Task {
                        do {
                            if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                                selectedImage = image
                            }
                            guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                                print("ERROR: Could not convert data from selectedPhoto")
                                return
                            }
                            data = transferredData
                        } catch {
                            print("ERROR: Could not create Image from selected photo.")
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(.bgcolor)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.bgcolor)
        .toolbarVisibility(.hidden, for: .tabBar)
    }
}

#Preview {
    @Previewable @State var ticket = Ticket(
        eventName: "Boston College vs. Notre Dame",
        eventType: .football,
        location: "Alumni Stadium",
        date: Date().addingTimeInterval(86400),
        price: 45.00,
        sellerId: "ABC",
        sellerName: "ABC",
        isSold: false,
        additionalInfo: "Student section, row 12"
    )
    
    PhotoView(ticket: $ticket)
}
