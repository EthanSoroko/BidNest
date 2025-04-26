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
                .font(.custom("Menlo", size: 30))
                .fontWeight(.bold)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("1: Must be at least 10 characters long")
                    
                Text("2: Must contain an Uppercase Letter")
                
                Text("3: Must contain a number")
                
                Text("4: Must contain a special character (e.g., !@#$%^&*())")
            }
            .padding(.bottom, 10)
            .font(.custom("Menlo", size: 20))
            .minimumScaleFactor(0.5)
            
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
    PasswordInfoView()
}
