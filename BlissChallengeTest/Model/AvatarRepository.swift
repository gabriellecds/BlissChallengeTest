import CoreData

class AvatarRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    //Buscar os avatares salvos no DB:
    func fetchSavedAvatars() -> [AvatarEntity] {
        let request: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching avatars: \(error)")
            return []
        }
    }
    
    //Deletar um avatar do DB:
    func deleteAvatar(_ avatarEntity: AvatarEntity) {
        context.delete(avatarEntity)
        
        do {
            try context.save()
            print("Avatar deleted.")
        } catch {
            print("Error deleting avatar: \(error).")
        }
    }
}
