import SwiftUI

struct AvatarListView: View {
    @State private var savedAvatars: [AvatarEntity] = []
    private let repository = AvatarRepository()
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(savedAvatars, id: \.self) { avatarEntity in
                    VStack {
                        if let urlString = avatarEntity.avatarURL,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 75, height: 75)
                                    .onTapGesture {
                                        repository.deleteAvatar(avatarEntity)
                                        savedAvatars.removeAll { $0.id == avatarEntity.id }
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            savedAvatars = repository.fetchSavedAvatars()
        }
    }
}
