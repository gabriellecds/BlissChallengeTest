import SwiftUI
import Combine

struct AppleReposListView: View {
    @StateObject private var appleViewModel = AppleViewModel()
    @State private var page: Int = 1
    
    var body: some View {
        VStack {
            // A List exibirá todos os repositórios carregados
            List(appleViewModel.repos) { repo in
                VStack(alignment: .leading) {
                    Text(repo.full_name)
                        .font(.headline)
                }
                .padding()
            }
           
            if appleViewModel.repos.count < 100 {
                ProgressView()
                    .onAppear {
                        // Carregar mais repositórios quando o 'ProgressView' for exibido
                        appleViewModel.loadAppleRepos(page: page, size: 10)
                    }
            }
        }
        .onAppear {
            // Quando a tela aparecer pela primeira vez, carregar os primeiros repositórios
            appleViewModel.loadAppleRepos(page: page, size: 10)
        }
    }
}
