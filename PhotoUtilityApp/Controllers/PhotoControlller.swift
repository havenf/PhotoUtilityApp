import SwiftData
import SwiftUI

@MainActor
class PhotoController {
    static func addPhoto(name: String, data: Data?, modelContext: ModelContext) {
        withAnimation {
            let newPhoto = Photo(name: name, data: data)
            modelContext.insert(newPhoto)
            try? modelContext.save()
        }
    }
    
    static func updatePhoto(photo: Photo, name: String, data: Data?, modelContext: ModelContext) {
        withAnimation {
            photo.name = name
            photo.data = data
            try? modelContext.save()
        }
    }
    
    static func deletePhoto(photo: Photo, modelContext: ModelContext) {
        withAnimation {
            modelContext.delete(photo)
            try? modelContext.save()
        }
    }
}


