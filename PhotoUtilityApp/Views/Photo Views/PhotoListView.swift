import SwiftUI
import SwiftData

struct PhotoListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query var photos: [Photo]
    
    @Binding var selectedPhoto: Photo?
    @Binding var showAddPhoto: Bool

    var body: some View {
        Group {
            if photos.isEmpty {
                VStack {
                    Spacer()
                    Text("No photos yet.\nTap '+' to add a photo.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
            } else {
                List(selection: $selectedPhoto) {
                    ForEach(photos) { photo in
                        PhotoRowView(photo: photo)
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            let photo = photos[index]
                            PhotoController.deletePhoto(photo: photo, modelContext: modelContext)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddPhoto = true
                } label: {
                    Label("Add Photo", systemImage: "plus")
                }
            }
        }
    }
}
