//
//  EditContactViewModel.swift
//  MyPeople
//
//  Created by Wilfred Lalonde on 2023-03-04.
//

import Foundation
import CoreData

final class EditContactViewModel: ObservableObject {
    
    @Published var contact: Contact
    let isNew: Bool
    let editDBmanager: CoreDataManager
    private var context: NSManagedObjectContext
    
    init(provider: CoreDataManager, contact: Contact? = nil) {
        self.editDBmanager = provider
        self.context = provider.editContext
        if let contact,
           let existingContactCopy =  provider.exists(contact, in: context) {
            self.contact = existingContactCopy
            self.isNew = false
        } else {
            self.contact = Contact(context: self.context)
            self.isNew = true
        }
     }
    
    func save() throws {
        try editDBmanager.persist(in: context)
    }
}
