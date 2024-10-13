//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Adrian Eberhardt on 13.10.24.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    let lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    let email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    var body: some View {
        VStack {
            Text("Personal information")
            Image("Logo")
            Text("First Name: \(firstName)")
            Text("Last Name: \(lastName)")
            Text("Email: \(email)")
            Spacer()
            Button("Logout", action: {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            } )
            
        }
    }
}

#Preview {
    UserProfile()
}
