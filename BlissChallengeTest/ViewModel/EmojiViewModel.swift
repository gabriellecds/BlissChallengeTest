import Foundation
import SwiftUI

class EmojiViewModel: ObservableObject {
    //criar o array de emojis:
    @Published var emojis: [Emoji] = []
    //criar a var do emoji selecionado quando o botao é pressionado
    @Published var selectedEmoji: Emoji? = nil
    
    private let repository = EmojiRepository()
    
    func fetchEmojis(from url: String){
        //Buscar a lista de emojis na url:
        repository.fetchEmojis(from: url) { emojis in
            DispatchQueue.main.async{
                self.emojis = emojis
            }
        }
    }
    
    func selectRandomEmoji(){
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
                                                 
