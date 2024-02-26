//
//  ContentView.swift
//  PhotoNotes
//
//  Created by Anousheh Hasan on 24/02/2024.
//

import PhotosUI
import SwiftUI

struct ImportedImage {
    let image: UIImage?
    let name: String
}

struct ContentView: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    //@State  private var images: [UIImage] = []
    
    @State private var images: [ImportedImage] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                if !images.isEmpty {
                    List {
                        ForEach(images.indices, id: \.self) { index in
                            Image(uiImage: images[index].image ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        }
                    }
                } else {
                    ContentUnavailableView("Photo Notes Library Empty", systemImage: "photo.badge.plus", description: Text("Tap plus button to import a photo"))
                }
            }
            .navigationTitle("Photo Notes")
            .toolbar {
                ToolbarItem {
                    PhotosPicker(selection: $pickerItem) {
                        Image(systemName: "plus")
                    }
                    .onChange(of: pickerItem, loadImage)
                }
            }
        }
    }
    
    // Function to load image into app
    func loadImage() {
        Task {
            if let pickerItem = pickerItem {
                do {
                    // Attempt to load the selected item as Data
                    let data = try await pickerItem.loadTransferable(type: Data.self)
                    // Convert the loaded Data into a UIImage
                    if let uiImage = UIImage(data: data!) {
                       // selectedImage = uiImage
                        let newImage = ImportedImage(image: uiImage, name: "Image")
                        images.append(newImage)
                    }
                } catch {
                    // Handle any errors that occur during loading
                    print("Failed to load image: \(error)")
                }
            }
        }
    }

}

#Preview {
    ContentView()
}
