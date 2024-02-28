//
//  PhotoNotesApp.swift
//  PhotoNotes
//
//  Created by Anousheh Hasan on 24/02/2024.
//

import SwiftData
import SwiftUI

@main
struct PhotoNotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ImportedImage.self)
    }
}
