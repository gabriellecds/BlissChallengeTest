import SwiftUI

struct EmojiListView: View{
    @State private var savedEmojis: [EmojiEntity] = []
    private let repository = EmojiRepository()
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(savedEmojis, id: \.self) { emojiEntity in
                    VStack {
                        if let urlString = emojiEntity.url,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) {image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 75, height: 75)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        Text(emojiEntity.id ?? "Unknown")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    //Remover o emoji clicado da memoria
                    .onTapGesture {
                        if let index = savedEmojis.firstIndex(of: emojiEntity) {
                            savedEmojis.remove(at: index)
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            //recarregar de volta os emojis que estao no cache e que foram deletados da memoria
            
            savedEmojis = repository.fetchSavedEmojis()
        }
        .onAppear{
            savedEmojis = repository.fetchSavedEmojis()
        }
    }
}
