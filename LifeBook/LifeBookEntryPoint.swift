//
//  LifeBookApp.swift
//  LifeBook
//
//  Created by Wilfred Lalonde on 2023-03-25.
//

import SwiftUI

@main
struct LifeBookEntryPoint: App {
    var body: some Scene {
        WindowGroup {
            ContactListView()
                .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
        }
    }
}
