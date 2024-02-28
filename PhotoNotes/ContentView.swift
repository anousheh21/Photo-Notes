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
    var name: String?
}

@Observable
class ImportedImages {
    var images = [ImportedImage]()
    
    init(images: [ImportedImage] = [ImportedImage]()) {
        self.images = images
    }
}

struct ContentView: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    @State private var showingAlert = false
    @State private var newImageName = ""
    @State private var currentImage: ImportedImage?
   
    
    @State private var imagesInstance = ImportedImages()
    
    var body: some View {
        NavigationStack {
            VStack {
                if !imagesInstance.images.isEmpty {
                    List {
                        ForEach(imagesInstance.images.indices, id: \.self) { index in
                            HStack {
                                Image(uiImage: imagesInstance.images[index].image ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                
                                Text(imagesInstance.images[index].name ?? "")
                            }
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
                    .alert("Enter image name", isPresented: $showingAlert) {
                        TextField("Enter image name", text: $newImageName)
                        Button("Submit", action: submit)
                    }
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
                        showingAlert.toggle()
                        selectedImage = uiImage
                       
                    }
                   
                } catch {
                    print("Failed to load image: \(error)")
                }
            }
            
        }
       
    }
    
    // Function to submit image and image name to appear on the screen
    func submit() {
        if let image = selectedImage {
            let newImage = ImportedImage(image: image, name: newImageName)
            imagesInstance.images.append(newImage)
            selectedImage = nil
            newImageName = ""
        }
    }

}

#Preview {
    ContentView()
}
