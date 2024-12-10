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
                }
            }
            .padding()
        }
        .onAppear{
            savedEmojis = repository.fetchSavedEmojis()
        }
    }
}
