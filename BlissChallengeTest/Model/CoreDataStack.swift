import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: K.dataModelName)
        container.loadPersistentStores{ _, error in
            if let e = error {
                fatalError("Failed to load Core Data stack: \(e)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
