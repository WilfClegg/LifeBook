//
//  ContactsProvider.swift
//  MyPeople
//
//  Created by Wilfred Lalonde on 2023-03-03.
//

import Foundation
import CoreData
import SwiftUI

final class CoreDataManager {
    
    static  let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var editContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        
        persistentContainer = NSPersistentCloudKitContainer(name: "ContactsDataModel")
//        if EnvironmentValues.isPreview {
//            persistentContainer.persistentStoreDescriptions.first?.url = .init(fileURLWithPath: "/dev/null")
//        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load Core Data: \(error)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func exists(_ contact: Contact, in context: NSManagedObjectContext) -> Contact? {
        try? context.existingObject(with: contact.objectID) as? Contact
    }
    
    func delete(_ contact: Contact, context: NSManagedObjectContext) throws {
        if let existingContact = exists(contact, in: context) {
            context.delete(existingContact)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
    
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
