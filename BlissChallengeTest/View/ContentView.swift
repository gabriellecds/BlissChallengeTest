import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @StateObject private var appleViewModel = AppleViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
      
                if let emoji = viewModel.selectedEmoji {
                    
                    AsyncImage(url: URL(string: emoji.url)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                } else if let avatarURL = viewModel.avatar?.avatarURL,
                          let url = URL(string: avatarURL) {
                    AsyncImage(url: url) { image in
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
                    Text("Random Emoji")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                NavigationLink(destination: EmojiListView()) {
                    Text("Emojis List")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                }
                
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                HStack {
                    TextField("Enter username", text: $viewModel.searchText)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 10)
                        )
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    Button(action: {
                        viewModel.searchAvatar()
                    }) {
                        Text("Search")
                            .font(.title)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.gray)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
                
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                NavigationLink(destination: AvatarListView()) {
                    Text("Avatar List")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                }
                
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                NavigationLink(destination: AppleReposListView()) {
                    Text("Apple Repos")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                }
                
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
            }
            .padding()
            .onAppear() {
                viewModel.fetchEmojis()
            }
        }
    }
}
            
#Preview {
    ContentView()
}
