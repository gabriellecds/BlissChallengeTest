import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = EmojiViewModel()
    
    var body: some View {
        VStack {
            //Verificar se existe um emoji selecionado
            if let emoji = viewModel.selectedEmoji {
                
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
                viewModel.selectRandomEmoji()
                viewModel.saveSelectedEmoji()
            }) {
                //aparencia do botao
                Text("Random Emoji")
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
                viewModel.fetchEmojis()
        }
    }
}
            
#Preview {
    ContentView()
}
