import Foundation
import SwiftUI

class EmojiViewModel: ObservableObject {
    //criar o array de emojis:
    @Published var emojis: [Emoji] = []
    //criar a var do emoji selecionado quando o botao é pressionado
    @Published var selectedEmoji: Emoji? = nil
    @Published var avatar: AvatarEntity? = nil
    @Published var searchText: String = ""
    
    private let repository = EmojiRepository()
    
    func fetchEmojis(){
        //Buscar a lista de emojis na url:
        repository.fetchEmojis { [weak self] fetchedEmojis in
            DispatchQueue.main.async{
                self?.emojis = fetchedEmojis
            }
        }
    }
    
    func searchAvatar() {
        //limpar a lista de emoji ao buscar um avatar;
        selectedEmoji = nil
        
        //Verificar no cache
        if let cachedAvatar = repository.fetchAvatarFromCache(by: searchText) {
            avatar = cachedAvatar
            print("Avatar fetched from cache")
        }
        
        guard !searchText.isEmpty else {
            print ("Search text is empty")
            return
        }
        
        //Buscar na API
        repository.fetchAvatarFromAPI(by: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let avatar):
                    //salvar no DB:
                    self?.repository.saveAvatar(avatar)
                    
                    //buscar no DB:
                    if let savedAvatar = self?.repository.fetchAvatarFromCache(by: avatar.login) {
                        self?.avatar = savedAvatar
                    }
                    
                    print("Avatar saved on coredata")
                case .failure(let error):
                    print("Error fetching avatar \(error)")
                }
            }
        }
    }
    
    func selectRandomEmoji(){
        //limpar a lista de avatar quando selecionar um emoji
        avatar = nil
        
        //selecionar um emoji aleatorio da lista
        if !emojis.isEmpty {
            selectedEmoji = emojis.randomElement()
        }
    }
    
    func saveSelectedEmoji(){
        //salvar apenas o emoji selecionado
        guard let emoji = selectedEmoji else { return }
        repository.saveEmoji(id: emoji.id, url: emoji.url)
    }
}
                                                 
