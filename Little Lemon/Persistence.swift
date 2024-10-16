import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ExampleDatabase") // Name der xcdatamodeld-Datei

        if let description = container.persistentStoreDescriptions.first {
            description.url = URL(fileURLWithPath: "/dev/null")
        } else {
            print("Error: No persistent store description found")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func clear() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Dish")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let _ = try? container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
    }

    func saveMenuItemsToCoreData(menuItems: [MenuItem]) {
        for menuItem in menuItems {
            let dish = Dish(context: container.viewContext)
            dish.name = menuItem.title
            dish.image = menuItem.image
            dish.price = Float(menuItem.price) ?? 0.0
            dish.dishDescription = menuItem.description

            // Speichern des Kontexts
            do {
                try container.viewContext.save()
                print("Erfolgreich gespeichert: \(menuItem.title)") // Überprüfung, ob gespeichert wird
            } catch {
                print("Fehler beim Speichern in Core Data: \(error)")
            }
        }
    }
}
