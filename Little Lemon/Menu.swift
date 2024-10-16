import SwiftUI
import CoreData
struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var menuItems: [MenuItem] = []
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            Text("Little Lemon Restaurant")
            Text("Albstadt")
            Text("Beste Restaurant in der Stadt")
            
            TextField("Search menu", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                List {
                    ForEach(dishes) { dish in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(dish.name ?? "Unbekanntes Gericht")
                                Text("Price: \(String(format: "%.2f", dish.price))")
                            }
                            if let imageUrl = dish.image, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                } placeholder: {
                                    Color.gray.frame(width: 100, height: 100)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }
    
    // Funktion zum Sortieren der Menüelemente nach Titel
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
    }
    
    // Funktion zum Erstellen des Prädikats für die Suche
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
    }
    
    // Methode zum Abrufen der Menüdaten
    func getMenuData() {
        // Überprüfe, ob bereits Menüelemente in Core Data vorhanden sind
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        
        do {
            let dishCount = try viewContext.count(for: fetchRequest)
            
            if dishCount > 0 {
                // Daten sind bereits in Core Data, keine neuen Daten abrufen
                print("Menüelemente bereits vorhanden, kein erneutes Abrufen erforderlich")
                return
            }
        } catch {
            print("Fehler beim Abrufen der Daten aus Core Data: \(error)")
            return
        }
        
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
