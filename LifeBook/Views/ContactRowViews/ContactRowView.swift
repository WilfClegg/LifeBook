//
//  ContactRowView.swift
//  MyPeople
//
//  Created by Wilfred Lalonde on 2023-03-04.
//

import SwiftUI
import iPhoneNumberField

struct ContactRowView: View {
    
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var contact: Contact
    @ObservedObject var numbersOnlyAlgorithm = NumbersOnlyAlgorithm()
    let phonePrefix = "tel://"
    
    @State var callThisNumber: String = ""
    @State var sendThisEmail: String = ""
    
    let dbManager: CoreDataManager
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if contact.contactType == "Company" {
                    CompanyContactView(contact: contact)
                } else {
                    if contact.contactType == "Medical" {
                        MedicalContactView(contact: contact)
                    } else {
                        PersonContactView(contact: contact)
                    }
                }
            }  //  HStack
        }  //  VStack
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button {
                toggleFave()
                
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundColor(contact.isFavorite ? .yellow : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
}

private extension ContactRowView {
    func toggleFave() {
        contact.isFavorite.toggle()
        
        do {
            try dbManager.persist(in: moc)
        } catch {
            print("Error when changing favorite flag: \(error)")
        }
    }
}

//struct ContactRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        let previewDBmanager = CoreDataManager.shared
//        ContactRowView(contact: .singlePreview(context: previewDBmanager.viewContext), dbManager: previewDBmanager)
//    }
//}
