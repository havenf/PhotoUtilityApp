import PhotosUI
import SwiftUI

@MainActor
class ImageTransferController {
    static func loadImageData(from item: PhotosPickerItem) async -> Data? {
        return try? await item.loadTransferable(type: Data.self)
    }
}
