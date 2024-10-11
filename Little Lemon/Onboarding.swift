//
//  Onboarding.swift
//  Little Lemon
//
//  Created by Adrian Eberhardt on 11.10.24.
//

import SwiftUI

struct Onboarding: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    var body: some View {
        
        VStack{
                TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Email", text: $email)
        }
    }
}

#Preview {
    Onboarding()
}
