import SwiftData
import UIKit

@Model
final class Photo {
    @Attribute(.externalStorage) var data: Data?
    
    var name: String
    var image: UIImage? {
        guard let data = data else { return nil }
        return UIImage(data: data)
    }
    
    init(name: String, data: Data? = nil) {
        self.name = name
        self.data = data
    }
}

