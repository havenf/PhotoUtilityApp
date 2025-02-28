import SwiftUI

struct PhotoRowView: View {
    let photo: Photo

    var body: some View {
        NavigationLink(value: photo) {
            HStack {
                if let image = photo.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.trailing, 8)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                }
                Text(photo.name)
                    .font(.headline)
            }
        }
    }
}


