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
        Text(importedImage.name ?? "No name")
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ImportedImage.self, configurations: config)
        let example = ImportedImage(image: UIImage(), name: "Photo")
        
        return DetailView(importedImage: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
