import SwiftData
import UIKit

@Model
final class Photo {
    var name: String
    @Attribute(.externalStorage) var data: Data?
    
    init(name: String, data: Data? = nil) {
        self.name = name
        self.data = data
    }
    
    var image: UIImage? {
        guard let data = data else { return nil }
        return UIImage(data: data)
    }
}

