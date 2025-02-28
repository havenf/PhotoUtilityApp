import SwiftUI
import SwiftData
import PhotosUI

struct UpdateEditPhotoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var imageData: Data? = nil
    @State private var imageSelection: PhotosPickerItem? = nil
    @State private var showCamera: Bool = false
    @State private var cameraError: CameraPermission.CameraError?

    // When editing an existing photo, pass its value; for a new photo, pass nil.
    let photo: Photo?
    
    

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
                    // Separate button for taking a photo via the camera.
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
                    // Separate PhotosPicker for choosing an image from the library.
                    PhotosPicker(selection: $imageSelection) {
                        Label("Choose from Library", systemImage: "photo.on.rectangle")
                    }
                    .padding(.vertical, 8)
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
            // When the selection changes, delegate to the controller.
            .onChange(of: imageSelection) { newSelection, _ in
                guard let item = newSelection else { return }
                Task {
                    if let data = await ImageTransferController.loadImageData(from: item) {
                        imageData = data
                    }
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
