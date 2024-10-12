import SwiftUI

// Globale Konstanten für UserDefaults-Schlüssel
let kFirstName = "first name key"
let kLastName = "last name key"
let kEmail = "email key"

// Funktion zur Überprüfung der E-Mail-Syntax (einfache Version)
func isValidEmail(_ email: String) -> Bool {
    return email.contains("@") && email.contains(".")
}

struct Onboarding: View {
    // State-Variablen für die Eingabefelder
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var isLoggedIn = false
    
    // State-Variable für die Fehlermeldung
    @State var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                // Textfelder für Vorname, Nachname und E-Mail
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                
                // Button für die Registrierung
                Button("Register") {
                    // Überprüfung, ob alle Felder ausgefüllt sind und die E-Mail gültig ist
                    if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && isValidEmail(email) {
                        // Speichern in UserDefaults
                        UserDefaults.standard.set(firstName, forKey: kFirstName)
                        UserDefaults.standard.set(lastName, forKey: kLastName)
                        UserDefaults.standard.set(email, forKey: kEmail)
                        
                        // Leere Fehlermeldung, da alles korrekt ist
                        errorMessage = ""
                        isLoggedIn = true // Navigation zur Home-Ansicht
                    } else {
                        // Setze die Fehlermeldung, falls etwas fehlt oder die E-Mail ungültig ist
                        errorMessage = "Please fill in all fields with valid information"
                    }
                }
                
                // Zeige Fehlermeldung als Text an
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)  // Rote Fehlermeldung
                        .padding()
                }
            }
            // Verwende den .navigationDestination Modifikator innerhalb des NavigationStack
            .navigationDestination(isPresented: $isLoggedIn) {
                Home()
            }
        }
    }
}

#Preview {
    Onboarding()
}
