import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var emojis: [Emoji] = []
    @Published var selectedEmoji: Emoji? = nil
    @Published var avatar: AvatarEntity? = nil
    @Published var searchText: String = ""
    
    private let emojiRepository = EmojiRepository()
    private let avatarRepository = AvatarRepository()
    
    func fetchEmojis(){
        emojiRepository.fetchEmojis { [weak self] fetchedEmojis in
            DispatchQueue.main.async{
                self?.emojis = fetchedEmojis
            }
        }
    }
    
    func selectRandomEmoji(){
        avatar = nil
 
        if !emojis.isEmpty {
            selectedEmoji = emojis.randomElement()
        }
    }
    
    func saveSelectedEmoji(){
        guard let emoji = selectedEmoji else { return }
        emojiRepository.saveEmoji(id: emoji.id, url: emoji.url)
    }
    
    func searchAvatar() {
        selectedEmoji = nil
        
        if let cachedAvatar = avatarRepository.fetchAvatarFromCache(by: searchText) {
            avatar = cachedAvatar
            print("Avatar fetched from cache")
        }
        
        guard !searchText.isEmpty else {
            print ("Search text is empty")
            return
        }
        
        avatarRepository.fetchAvatarFromAPI(by: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let avatar):
                    self?.avatarRepository.saveAvatar(avatar)
             
                    if let savedAvatar = self?.avatarRepository.fetchAvatarFromCache(by: avatar.login) {
                        self?.avatar = savedAvatar
                    }
                case .failure(let error):
                    print("Error fetching avatar \(error)")
                }
            }
        }
    }
}
                                                 
