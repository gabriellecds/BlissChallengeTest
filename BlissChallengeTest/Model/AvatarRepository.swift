import CoreData

struct Avatar: Decodable, Identifiable {
    let id: Int
    let login: String
    let avatarURL: String
    
    private enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
    }
}

class AvatarRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func fetchAvatarFromCache(by login: String) -> AvatarEntity? {
        let request: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        request.predicate = NSPredicate(format: "login == %@", login)
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching avatar from cache: \(error)")
            return nil
        }
    }
    
    func fetchAvatarFromAPI(by username: String, completion: @escaping(Result<Avatar, Error>) -> Void) {
        let urlString = K.avatarURL + username
        
        guard let url = URL(string: urlString) else {
            print("Unvalid URL")
            return
        }
       
        URLSession.shared.dataTask(with: url) {data, response, error in
       
            if let e = error {
                print("Error searching for avatar: \(e.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty")
                return
            }
       
            do {
                let avatar = try JSONDecoder().decode(Avatar.self, from: data)
                completion(.success(avatar))
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
   
    func saveAvatar(_ avatar: Avatar) {
        let avatarEntity = AvatarEntity(context: context)
        avatarEntity.id = Int64(avatar.id)
        avatarEntity.login = avatar.login
        avatarEntity.avatarURL = avatar.avatarURL
        
        do {
            try context.save()
        } catch {
            print("Error saving avatar: \(error)")
        }
    }
    
    func fetchSavedAvatars() -> [AvatarEntity] {
        let request: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching avatars: \(error)")
            return []
        }
    }
    
    func deleteAvatar(_ avatarEntity: AvatarEntity) {
        context.delete(avatarEntity)
        
        do {
            try context.save()
        } catch {
            print("Error deleting avatar: \(error).")
        }
    }
}
