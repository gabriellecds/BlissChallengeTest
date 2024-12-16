import SwiftUI
import Combine

struct AppleReposListView: View {
    @StateObject private var appleViewModel = AppleViewModel()
    @State private var page: Int = 1
    
    var body: some View {
        VStack {
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
                        appleViewModel.loadAppleRepos(page: page, size: 10)
                }
            }
        }
        .onAppear {
            appleViewModel.loadAppleRepos(page: page, size: 10)
        }
    }
}
