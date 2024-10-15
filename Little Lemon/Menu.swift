import SwiftUI

struct Menu: View {
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
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let menuData = try decoder.decode(MenuList.self, from: data)
                
                // Auf dem Hauptthread aktualisieren
                DispatchQueue.main.async {
                    menuItems = menuData.menu
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
}
