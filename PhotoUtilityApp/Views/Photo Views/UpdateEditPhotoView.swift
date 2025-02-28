import SwiftUI
import SwiftData
import PhotosUI

struct UpdateEditPhotoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    // When editing an existing photo, pass its value; for a new photo, pass nil.
    let photo: Photo?
    
    @State private var name: String = ""
    @State private var imageData: Data? = nil
    @State private var imageSelection: PhotosPickerItem? = nil
    @State private var showCamera: Bool = false
    @State private var cameraError: CameraPermission.CameraError?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Photo Details")) {
                    TextField("Enter photo name", text: $name)
                }
                Section(header: Text("Photo")) {
                    if let data = imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                    // Button for taking a photo via the camera.
                    Button("Take Photo") {
                        if let error = CameraPermission.checkPermissions() {
                            cameraError = error
                        } else {
                            showCamera = true
                        }
                    }
                    .padding(.vertical, 8)
                    .sheet(isPresented: $showCamera) {
                        CameraAdapter(selectedImageData: $imageData, onImagePicked: { image in
                            imageData = image.jpegData(compressionQuality: 0.8)
                        })
                    }
                    // PhotosPicker for choosing an image from the library.
                    PhotosPicker(
                        selection: $imageSelection,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("Choose from Library", systemImage: "photo.on.rectangle")
                    }
                    .padding(.vertical, 8)
                    // Use the zero-parameter onChange.
                    .onChange(of: imageSelection) {
                        Task {
                            guard let item = imageSelection else { return }
                            if let data = try? await item.loadTransferable(type: Data.self) {
                                await MainActor.run {
                                    imageData = data
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(photo == nil ? "Add Photo" : "Edit Photo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { savePhoto() }
                        .disabled(name.isEmpty)
                }
            }
            .alert(isPresented: .constant(cameraError != nil)) {
                Alert(
                    title: Text("Camera Error"),
                    message: Text(cameraError?.recoverySuggestion ?? ""),
                    dismissButton: .default(Text("OK"), action: { cameraError = nil })
                )
            }
            .onAppear {
                if let photo = photo {
                    name = photo.name
                    imageData = photo.data
                }
            }
        }
    }
    
    private func savePhoto() {
        if let photo = photo {
            PhotoController.updatePhoto(photo: photo, name: name, data: imageData, modelContext: modelContext)
        } else {
            PhotoController.addPhoto(name: name, data: imageData, modelContext: modelContext)
        }
        dismiss()
    }
}

#Preview {
    UpdateEditPhotoView(photo: nil)
        .modelContainer(for: Photo.self, inMemory: true)
}
