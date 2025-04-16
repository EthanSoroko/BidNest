//
//  PasswordInfoView.swift
//  BidNest
//
//  Created by Ethan Soroko on 4/16/25.
//

import SwiftUI

struct PasswordInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "lock.circle")
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()
            
            Text("Password Rules:")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("1: Must be at least 10 characters long")
                
                Text("2: Must contain an Uppercase Letter")
                
                Text("3: Must contain a number")
                
                Text("4: Must contain a special character (e.g., !@#$%^&*())")
            }
            
            Button("Okay") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.appcolor)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgcolor)
        .presentationDetents([.medium])
    }
}

#Preview {
    PasswordInfoView()
}
