import Foundation
import CoreData

class EmojiRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    //buscar dados JSON na URL e preencher o array "emojis"
    func fetchEmojis(completion: @escaping([Emoji]) -> Void) {
        
        //Verificar se há dados no cache:
        let cacheEmoji = fetchSavedEmojis()
        
        if !cacheEmoji.isEmpty{
            //retornar os dados que estiverem no cache
            print("Using cache emojis")
            completion(cacheEmoji.map {Emoji(id: $0.id ?? "", url: $0.url ?? "")})
            return
        }
        
        //Se nao houver dados em cache, buscar da API:
        print("Using API emojis")
        fetchEmojiFromAPI(completion: completion)
    }
        
    private func fetchEmojiFromAPI(completion: @escaping([Emoji]) -> Void) {
        let urlString = K.emojisURL
        
        //verificar se a url é válida:
        guard let url = URL(string: urlString) else {
            print("Unvalid URL")
            completion ([])
            return
        }
        
        //criar uma tarefa de rede (dataTask)
        URLSession.shared.dataTask(with: url) {data, response, error in
            
            //verificar se houve erro:
            if let e = error {
                print("Error searching for emojis: \(e.localizedDescription)")
                completion([])
                return
            }
            
            //verificar se o dado recebido nao é nulo:
            guard let data = data else {
                print("Empty")
                completion([])
                return
            }
        
            //decodificar o JSON:
            do {
                //dados recebidos transformados em um dicionário de String
                let decodedData = try JSONDecoder().decode([String: String].self, from: data)
                
                //transformar o dicionário em lista para popular a lista "emojis"
                let emojis = decodedData.map{ Emoji(id: $0.key, url: $0.value) }
                completion(emojis)
                
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion([])
            }
            
        //iniciar a execução da tarefa de rede (dataTask)
        }.resume()
    }
    
    func saveEmoji(id: String, url: String) {
        let emoji = EmojiEntity(context: context)
        emoji.id = id
        emoji.url = url
        
        do {
            try context.save()
            print("Emoji \(id) salvo com sucesso!")
        } catch {
            print("Error saving emoji: \(error)")
        }
    }
    
    //Recuperar os emojis salvos no CD
    func fetchSavedEmojis() -> [EmojiEntity] {
        //solicitacao de busca para todos os objetos do tipo EmojiEntity
        let request: NSFetchRequest<EmojiEntity> = EmojiEntity.fetchRequest()
        
        do {
            //busca os dados do CD
            return try context.fetch(request)
        } catch {
            print("Error searching for emojis: \(error)")
            return []
        }
    }
}
