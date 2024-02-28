//
//  ImportedImage.swift
//  PhotoNotes
//
//  Created by Anousheh Hasan on 28/02/2024.
//

import Foundation
import PhotosUI
import SwiftData

@Model
class ImportedImage {
    @Attribute(.externalStorage) var imageData: Data?
    var name: String?
    
    init(image: UIImage?, name: String? = nil) {
        if let image = image {
            self.imageData = image.jpegData(compressionQuality: 1.0) // Convert UIImage to Data
        }
        self.name = name
    }
    
    // Computed property to convert imageData to UIImage
    var image: UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
