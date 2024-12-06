import Foundation

class EmojiViewModel: ObservableObject {
    //criar o array de emojis:
    @Published var emojis: [Emoji] = []
    
    //buscar dados JSON na URL e preencher o array "emojis"
    func fetchEmojis(from urlString: String){
        
        //verificar se a url é válida:
        guard let url = URL(string: urlString) else {
            print("Unvalid URL")
            return
        }
        
        //criar uma tarefa de rede (dataTask)
        URLSession.shared.dataTask(with: url) {data, response, error in
            
            //verificar se houve erro:
            if let e = error {
                print("Error searching for emojis: \(e.localizedDescription)")
                return
            }
            
            //verificar se o dado recebido nao é nulo:
            guard let data = data else {
                print("Empty")
                return
            }
        
            //decodificar o JSON:
            do {
                //dados recebidos transformados em um dicionário de String
                let decodedData = try JSONDecoder().decode([String: String].self, from: data)
                DispatchQueue.main.async {
                    
                    //transformar o dicionário em lista para popular a lista "emojis"
                    self.emojis = decodedData.map { Emoji(id: $0.key, url: $0.value) }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
            
        //iniciar a execução da tarefa de rede (dataTask)
        }.resume()
    }
}
