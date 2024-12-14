import Foundation
import Combine

struct AppleRepos: Identifiable, Decodable {
    var id: Int
    var full_name: String
    var isPrivate: Bool
    
    enum CodingKeys: String, CodingKey{
        case id
        case full_name
        case isPrivate = "private"
    }
}

class AppleReposRepository {
    
    func fetchRepos(forUser username: String, page: Int, size: Int) -> AnyPublisher<[AppleRepos], Error> {
           let urlString = "https://api.github.com/users/\(username)/repos?per_page=\(size)&page=\(page)"
           
           guard let url = URL(string: urlString) else {
               return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
           }
           
           return URLSession.shared.dataTaskPublisher(for: url)
               .map(\.data)
               .decode(type: [AppleRepos].self, decoder: JSONDecoder())
               .mapError { error in
                   print("API Error: \(error.localizedDescription)")
                   return error }
               .eraseToAnyPublisher()
       }
}
