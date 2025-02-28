import SwiftUI
import SwiftData

struct PhotoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showUpdateEdit: Bool = false
    
    let photo: Photo

    var body: some View {
        VStack {
            Text(photo.name)
                .font(.largeTitle)
            if let image = photo.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
            HStack {
                Button("Edit") {
                    showUpdateEdit = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button("Delete", role: .destructive) {
                    PhotoController.deletePhoto(photo: photo, modelContext: modelContext)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Photo Details")
        .sheet(isPresented: $showUpdateEdit) {
            // Pass the current photo to update its details.
            UpdateEditPhotoView(photo: photo)
        }
    }
}


