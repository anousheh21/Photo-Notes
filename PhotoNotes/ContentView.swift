//
//  ContentView.swift
//  PhotoNotes
//
//  Created by Anousheh Hasan on 24/02/2024.
//

import PhotosUI
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ImportedImage.name) var importedImages: [ImportedImage]
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    @State private var showingAlert = false
    @State private var newImageName = ""
    @State private var currentImage: ImportedImage?
    
    var body: some View {
        NavigationStack {
            VStack {
                if !importedImages.isEmpty {
                    List {
                        ForEach(importedImages) { importedImage in
                            NavigationLink(value: importedImage ){
                                HStack {
                                    Image(uiImage: importedImage.image ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                    
                                    Text(importedImage.name ?? "")
                                }
                            }
                        }
                        .onDelete(perform: deleteImage)
                    }
                  
                } else {
                    ContentUnavailableView("Photo Notes Library Empty", systemImage: "photo.badge.plus", description: Text("Tap plus button to import a photo"))
                }
            }
            .navigationTitle("Photo Notes")
            .navigationDestination(for: ImportedImage.self) { importedImage in
                DetailView(importedImage: importedImage)
            }
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
            // importedImages.append(newImage)
            modelContext.insert(newImage)
            selectedImage = nil
            newImageName = ""
        }
    }
    
    // Function to delete an image
    func deleteImage(at offsets: IndexSet) {
        for offset in offsets {
            let image = importedImages[offset]
            modelContext.delete(image)
        }
    }

}

#Preview {
    ContentView()
}
