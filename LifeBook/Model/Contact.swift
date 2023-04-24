//
//  Contact.swift
//  MyPeople
//
//  Created by Wilfred Lalonde on 2023-03-03.
//

import Foundation
import CoreData

final class Contact: NSManagedObject, Identifiable {
    
    @NSManaged var dob: Date
    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var phoneNumber: String
    @NSManaged var phoneNumber2: String
    @NSManaged var email: String
    @NSManaged var isFavorite: Bool
    @NSManaged var contactType: String
    @NSManaged var typeImage: Data?
    @NSManaged var webLink: String
    @NSManaged var birthdayAdded: Bool
    
    var isNewContactValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !phoneNumber.isEmpty
    }
    
    var isBirthday: Bool {
        let calendar = Calendar.current
        var dobComponents = calendar.dateComponents([.year, .month, .day], from: dob)
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        if (dobComponents.month == 2 && dobComponents.day == 29 && todayComponents.isLeapMonth == false) {
            dobComponents.day = 28 // Set birthday back to 28 for leap babies.
        }

        return (dobComponents.month == todayComponents.month && dobComponents.day == todayComponents.day)

//        Calendar.current.isDateInToday(dob)
    }
    
    var formattedName: String {
        "\(name)\(isBirthday ? "🎈" : "")"
    }
 
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date.now, forKey: "dob")
        setPrimitiveValue(false, forKey: "isFavorite")
    }
}

extension Contact {

    private static var contactsFetchRequest: NSFetchRequest<Contact> {
        NSFetchRequest(entityName: "Contact")
    }
    
    static func fave() -> NSFetchRequest<Contact> {
        let request: NSFetchRequest<Contact> = contactsFetchRequest
        request.sortDescriptors = [  NSSortDescriptor(keyPath: \Contact.name, ascending: true)  ]
        request.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        return request
    }
    
    static func all() -> NSFetchRequest<Contact> {
        let request: NSFetchRequest<Contact> = contactsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Contact.name, ascending: true)
        ]
        return request
    }
    
    static func configureFilter(with config: FilterConfig) -> NSPredicate {
           switch config.filterType {
           case .Favorite:
               return config.query.isEmpty ? NSPredicate(format: "isFavorite == %@", NSNumber(value: true)) :
               NSPredicate(format: "name CONTAINS[cd] %@ AND isFavorite == %@", config.query, NSNumber(value: true))
           case .Person:
               return config.query.isEmpty ? NSPredicate(format: "contactType == %@", "Person") :
               NSPredicate(format: "name CONTAINS[cd] %@ AND contactType == %@", config.query, "Person")
           case .Company:
               return config.query.isEmpty ? NSPredicate(format: "contactType == %@", "Company") :
               NSPredicate(format: "name CONTAINS[cd] %@ AND contactType == %@", config.query, "Company")
           case .Medical:
               return config.query.isEmpty ? NSPredicate(format: "contactType == %@", "Medical") :
               NSPredicate(format: "name CONTAINS[cd] %@ AND contactType == %@", config.query, "Medical")
           case .All:
               return config.query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", config.query)
           }
       }
    

    static func sort(order: Sort) -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Contact.name, ascending: order == .ascending)]
    }
}

extension Contact {
    @discardableResult
    
    static func multiPreview(count: Int, in context: NSManagedObjectContext) -> [Contact] {
        
        var contacts = [Contact]()
        
        for i in 0..<count {
            let contact = Contact(context: context)
            contact.name = "item \(i)"
            contact.email = "test_\(i)"
            contact.isFavorite = Bool.random()
            contact.phoneNumber = "01234567890\(i)"
            contact.dob = Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? .now
            contact.notes = "This is a preview for item \(i)"
            contacts.append(contact)
        }
        return contacts
    }
    
    static func singlePreview(context: NSManagedObjectContext = CoreDataManager.shared.viewContext) -> Contact {
        return multiPreview(count: 1, in: context)[0]
    }
    
    static func emptyPreview(context: NSManagedObjectContext = CoreDataManager.shared.viewContext) -> Contact {
        return Contact(context: context)
    }
}

