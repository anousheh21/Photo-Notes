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
    @State private var selectedImage: Image?
    @State private var images: [Image] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    if let selectedImage {
                        // Get rid of the code inside this if block and instead place a function, that will also be run when the user taps the plus button in the toolbar
                        // PUT LIST HERE???
                        selectedImage
                            .resizable()
                            .scaledToFit()
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
                        // add image function goes here?
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
            selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
        }
    }
}

#Preview {
    ContentView()
}
