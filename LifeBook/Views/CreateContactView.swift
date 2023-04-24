//
//  CreateContactView.swift
//  MyPeople
//
//  Created by Wilfred Lalonde on 2023-03-04.
//

import SwiftUI
import iPhoneNumberField

//  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  OpenAI Key

struct CreateContactView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: EditContactViewModel
    
    @State private var newContactMissingData: Bool = false
    
    @State private var isPerson = true
    @State private var isCompany = false
    @State private var isMedical = false
    
    @State private var birthdayChecked: Bool = false

    var body: some View {
        
        List {
            
            Section("CONTACT INFORMATION") {
                VStack {
                                       
                    HStack {
                        Text("Type")
                        Spacer()
                        
                        //************************
                        //  SELECT PERSON CONTACT
                        //************************
                        VStack {
                            Image("PersonImage")
                                .resizable()
                                .colorMultiply(isPerson ? Color.themeBlue : .gray.opacity(0.2))
                                .frame(width: 25, height: 25)
                            
                            Text("Person")
                                .font(.callout)
                                .foregroundColor(isPerson ? Color.themeBlue : .gray.opacity(0.2))
                        }  //  VStack
                        .onTapGesture {
                            isPerson = true
                            isCompany = false
                            isMedical = false
                            vm.contact.contactType = "Person"
                         }
                          Spacer()
                        
                        //************************
                        //  SELECT COMPANY CONTACT
                        //************************
                         VStack {
                             Image("CompanyImage")
                                .resizable()
                                .colorMultiply(isCompany ? Color.themeGreen : .gray.opacity(0.2))
                                .frame(width: 25, height: 25)
                            
                            Text("Company")
                                .font(.callout)
                                .foregroundColor(isCompany ? Color.themeGreen : .gray.opacity(0.2))
                        }  //  VStack
                        .onTapGesture {
                            isCompany = true
                            isPerson = false
                            isMedical = false
                            vm.contact.contactType = "Company"
                        }
                         Spacer()
                        
                        //************************
                        //  SELECT MEDICAL CONTACT
                        //************************
                        VStack {
                            Image("MedicalImage")
                                .resizable()
                                .colorMultiply(isMedical ? Color.themeRed : .gray.opacity(0.2))
                                .frame(width: 25, height: 25)
                            
                            Text("Medical")
                                .font(.callout)
                                .foregroundColor(isMedical ? Color.themeRed : .gray.opacity(0.2))
                        }  //  VStack
                        .onTapGesture {
                            isMedical = true
                            isPerson = false
                            isCompany = false
                            vm.contact.contactType = "Medical"
                        }
                          Spacer()
                    }  //  HStack
                }  //  VStack
                
                TextField("Name", text: $vm.contact.name)
                    .textInputAutocapitalization(.words)
                
                TextField("Email", text: $vm.contact.email)
//                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                HStack {
                    iPhoneNumberField("Phone !", text: $vm.contact.phoneNumber)
//                        .keyboardType(.phonePad)
//                        .textFieldStyle(.roundedBorder)
                    iPhoneNumberField("Phone 2", text: $vm.contact.phoneNumber2)
//                        .keyboardType(.phonePad)
//                        .textFieldStyle(.roundedBorder)
                }
                
                if !isPerson || vm.contact.contactType != "Person" {
                    TextField("WebLink (URL)", text: $vm.contact.webLink)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                }
                
                if isPerson || vm.contact.contactType == "Person" {
                    HStack {
                        Toggle("Birthday?", isOn: $vm.contact.birthdayAdded)
                        if vm.contact.birthdayAdded {
                            DatePicker("", selection: $vm.contact.dob, displayedComponents: [.date])
                                .datePickerStyle(.compact)
                        }
                    }
                }
                
                Toggle("Favorite", isOn: $vm.contact.isFavorite)
            }
            Section("NOTES") {
                VStack {
                    TextField("", text: $vm.contact.notes, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                       
                }
            }
        }
        .navigationTitle(vm.isNew ? "New Contact" : "Update Contact")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    validateNewContact()
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert(" 🛑 Data is missing", isPresented: $newContactMissingData, actions: {}) {
            Text("Please fill in all form fields.")
        }
    }
}

private extension CreateContactView {
    
    func validateNewContact() {
        if vm.contact.isNewContactValid {
            do {
                try vm.save()
                dismiss()
            } catch {
                print("Error when attempting to save to Core Data: \(error)")
            }
        } else {
            newContactMissingData = true
        }
    }
}

struct CreateContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            let preview = CoreDataManager.shared
            CreateContactView(vm: .init(provider: preview))
                .environment(\.managedObjectContext, preview.viewContext)
        }
    }
}
