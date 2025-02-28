import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedPhoto: Photo? = nil
    @State private var showAddPhoto: Bool = false

    var body: some View {
        NavigationSplitView {
            PhotoListView(selectedPhoto: $selectedPhoto, showAddPhoto: $showAddPhoto)
        } detail: {
            if let photo = selectedPhoto {
                PhotoDetailView(photo: photo)
            } else {
                Text("Select a photo")
                    .foregroundStyle(.secondary)
            }
        }
        .sheet(isPresented: $showAddPhoto) {
            UpdateEditPhotoView(photo: nil)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Photo.self, inMemory: true)
}
