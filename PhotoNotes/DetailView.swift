//
//  DetailView.swift
//  PhotoNotes
//
//  Created by Anousheh Hasan on 29/02/2024.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    // @Environment(\.dismiss) var dismiss
    
    let importedImage: ImportedImage
    
    var body: some View {
                VStack {
                    Spacer()
                    Image(uiImage: importedImage.image ?? UIImage())
                        .resizable()
                        .scaledToFit()
                    Spacer()
                    Spacer()
            }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ImportedImage.self, configurations: config)
        let example = ImportedImage(image: UIImage(named: "previewImage"), name: "Photo")
        
        return DetailView(importedImage: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
