import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var menuItems: [MenuItem] = []
    
    var body: some View {
        VStack {
            Text("Little Lemon Restaurant")
            Text("Albstadt")
            Text("Beste Restaurant in der Stadt")
            List(menuItems) { item in
                VStack(alignment: .leading) {
                    Text(item.title)
                    Text("Price: \(item.price)")
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }
    
    // Methode zum Abrufen der Menüdaten
    func getMenuData() {
        // Datenbank leeren, bevor neue Daten hinzugefügt werden
        PersistenceController.shared.clear()
        
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        guard let url = URL(string: urlString) else {
            print("Ungültige URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fehler beim Abrufen der Daten: \(error)")
                return
            }
            
            guard let data = data else {
                print("Keine Daten erhalten")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let menuList = try decoder.decode(MenuList.self, from: data)
                let menuItems = menuList.menu
                
                // Menüelemente in Core Data speichern
                DispatchQueue.main.async {
                    self.menuItems = menuItems  // Hier die menuItems für die Liste aktualisieren
                    
                    // Durch jedes Menüelement iterieren und in Core Data speichern
                    for menuItem in menuItems {
                        let dish = Dish(context: viewContext)
                        dish.name = menuItem.title
                        dish.image = menuItem.image
                        dish.price = Float(menuItem.price) ?? 0.0
                        
                        // Core Data speichern
                        do {
                            try viewContext.save()
                            print("Erfolgreich gespeichert: \(menuItem.title)")
                        } catch {
                            print("Fehler beim Speichern in Core Data: \(error)")
                        }
                    }
                }
            } catch {
                print("Fehler beim Dekodieren: \(error)")
            }
        }
        
        task.resume()
    }
}
