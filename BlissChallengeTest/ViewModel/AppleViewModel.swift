import SwiftUI
import Combine

class AppleViewModel: ObservableObject {
    @Published var repos: [AppleRepos] = []
    private var cancellables: Set<AnyCancellable> = []
    private let repository = AppleReposRepository()

    // Função para carregar os repositórios
    func loadAppleRepos(page: Int, size: Int) {
        repository.fetchRepos(forUser: "apple", page: page, size: size)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error loading repositories: \(error.localizedDescription)")
                }
            }, receiveValue: { repos in
                self.repos.append(contentsOf: repos)
            })
            .store(in: &cancellables)
    }

    // Função para carregar mais repositórios quando o usuário chega no fim
    func loadMoreReposIfNeeded(page: Int, size: Int) {
        guard let lastRepo = repos.last else { return }
        
        // Detecta se o último item visível foi atingido
        if repos.firstIndex(where: { $0.id == lastRepo.id }) == repos.count - 1 {
            loadAppleRepos(page: page, size: size)
        }
    }
}
