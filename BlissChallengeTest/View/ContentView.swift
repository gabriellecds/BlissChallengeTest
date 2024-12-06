import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = EmojiViewModel()
    @State private var selectedEmoji: Emoji? = nil
    
    var body: some View {
        VStack {
            //Verificar se existe um emoji selecionado
            if let emoji = selectedEmoji {
                
                //Se houver, carregar a imagem usando o AsyncImage
                AsyncImage(url: URL(string: emoji.url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Button(action: {
                //se a lista de emojis NAO estiver vazia, mostrar um amoji aleatorio
                if !viewModel.emojis.isEmpty {
                    selectedEmoji = viewModel.emojis.randomElement()
                }
            }) {
                //aparencia do botao
                Text("Get Emoji")
                    .font(.title)
                    .font(.system(size: 25))
                    //espaçamento do texto
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.gray)
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    //espaçamento do botao nas laterais
                    .padding(.horizontal, 20)
            }
        }
        .padding()
        .onAppear() {
            viewModel.fetchEmojis(from: K.emojisURL)
        }
    }
}
            
#Preview {
    ContentView()
}
