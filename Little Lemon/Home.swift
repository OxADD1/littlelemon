import SwiftUI

struct Home: View {
    // Füge den PersistenceController hinzu
    let persistence = PersistenceController.shared
    
    var body: some View {
        TabView {
            Menu()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
                // Füge den managedObjectContext hier hinzu
                .environment(\.managedObjectContext, persistence.container.viewContext)
            
            UserProfile()
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
    }
}

#Preview {
    Home()
}
