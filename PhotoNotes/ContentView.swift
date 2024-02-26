//
//  ContentView.swift
//  PhotoNotes
//
//  Created by Anousheh Hasan on 24/02/2024.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State  private var images: [UIImage] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    if let selectedImage {
                        // Get rid of the code inside this if block and instead place a function, that will also be run when the user taps the plus button in the toolbar
                        // PUT LIST HERE???
                        List {
                            ForEach(images.indices, id: \.self) { index in
                                Image(uiImage: images[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                            }
                        }
                    } else {
                        ContentUnavailableView("Photo Notes Library Empty", systemImage: "photo.badge.plus", description: Text("Tap to import photo"))
                    }
                }
                .onChange(of: pickerItem, loadImage)
            }
            .navigationTitle("Photo Notes")
            .toolbar {
                ToolbarItem {
                    Button {
                        loadImage()
                    } label: {
                        Image(systemName: "plus")
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
                        selectedImage = uiImage
                        images.append(uiImage)
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
