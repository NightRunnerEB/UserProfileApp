//
//  UserProfileAppApp.swift
//  UserProfileApp
//
//  Created by Евгений Бухарев on 20.03.2024.
//

import SwiftUI

@main
struct UserProfileAppApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
