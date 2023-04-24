//
//  ContactDetailView.swift
//  MyPeople
//
//  Created by Wilfred Lalonde on 2023-03-04.
//

import SwiftUI
import iPhoneNumberField

struct ContactDetailView: View {
    
    let contact: Contact
    
    var body: some View {
        
        VStack {
            
            if contact.contactType == "Company" {
                CompanyDetailView(contact: contact)
            } else {
                if contact.contactType == "Medical" {
                    MedicalDetailView(contact: contact)
                } else {
                    PersonDetailView(contact: contact)
                }
            }
        }
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactDetailView(contact: .singlePreview())
        }
    }
}
