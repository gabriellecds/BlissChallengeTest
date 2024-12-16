import Foundation
import CoreData

struct Emoji {
   let id: String
   let url: String
}

class EmojiRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func fetchEmojis(completion: @escaping([Emoji]) -> Void) {
        
        let cacheEmoji = fetchSavedEmojis()
        
        if !cacheEmoji.isEmpty{
            completion(cacheEmoji.map {Emoji(id: $0.id ?? "", url: $0.url ?? "")})
            return
        }
        
        fetchEmojiFromAPI(completion: completion)
    }
        
    private func fetchEmojiFromAPI(completion: @escaping([Emoji]) -> Void) {
        let urlString = K.emojisURL
        
        guard let url = URL(string: urlString) else {
            print("Unvalid URL")
            completion ([])
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in
          
            if let e = error {
                print("Error searching for emojis: \(e.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("Empty data")
                completion([])
                return
            }
       
            do {
                let decodedData = try JSONDecoder().decode([String: String].self, from: data)
                
                let emojis = decodedData.map{ Emoji(id: $0.key, url: $0.value) }
                completion(emojis)
                
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
    
    func saveEmoji(id: String, url: String) {
        let emoji = EmojiEntity(context: context)
        emoji.id = id
        emoji.url = url
        
        do {
            try context.save()
        } catch {
            print("Error saving emoji: \(error)")
        }
    }
    
    func fetchSavedEmojis() -> [EmojiEntity] {
        let request: NSFetchRequest<EmojiEntity> = EmojiEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error searching for emojis: \(error)")
            return []
        }
    }
}
