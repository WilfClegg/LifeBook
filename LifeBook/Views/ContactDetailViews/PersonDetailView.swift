//
//  PersonDetailView.swift
//  LifeBook
//
//  Created by Wilfred Lalonde on 2023-03-24.
//

import SwiftUI

struct PersonDetailView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var contact: Contact
    @ObservedObject var numbersOnlyAlgorithm = NumbersOnlyAlgorithm()
    @State private var sendThisEmail: String = ""
    @State var callThisNumber: String = ""
    
    var body: some View {
        
        List {
            Section("General") {
                HStack {
                    Image("PersonImage")
                        .resizable()
                        .foregroundColor(Color.themeBlue)
                        .frame(width: 15, height: 15)
                    Text("\(contact.contactType) Contact")
                    Spacer()
                    Image(systemName: "star")
                        .font(.title3)
                        .symbolVariant(.fill)
                        .foregroundColor(contact.isFavorite ? .yellow : .gray.opacity(0.3))
                }  //  HStack
                
                HStack {
                    Button(action: {
                        numbersOnlyAlgorithm.filteredPhone = contact.phoneNumber
                        callThisNumber = "tel://" + numbersOnlyAlgorithm.filteredPhone
                        
                        guard let url = URL(string: callThisNumber) else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                    }.buttonStyle(.bordered)
                    
                    Text(contact.phoneNumber)
                        .font(.callout)
                }  //  HStack
                
                HStack {
                    Button(action: {
                        numbersOnlyAlgorithm.filteredPhone = contact.phoneNumber2
                        callThisNumber = "tel://" + numbersOnlyAlgorithm.filteredPhone
                        
                        guard let url = URL(string: callThisNumber) else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                    }.buttonStyle(.bordered)
                    
                    Text(contact.phoneNumber2)
                        .font(.callout)
                }  //  HStack
                
                HStack {
                    Button(action: {
                        sendThisEmail = contact.email
                        if let url = URL(string: "mailto:\(sendThisEmail)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image(systemName: "envelope.fill")
                            .font(.title2)
                    }.buttonStyle(.bordered)
                    
                    Text(contact.email)
                        .font(.callout)
                }  //  HStack
                
                if contact.birthdayAdded {
                    HStack {
                        Text("Birthday")
                        Text(contact.dob, style: .date)
                    }  //  HStack
                }
            }  //  Section
            
            Section("Notes") {
                Text(contact.notes)
            }  //  Section
            
        }  //  List
        .navigationTitle( contact.formattedName )
    }
}

private extension Date {
    var displayFormat: String {
        self.formatted(.dateTime.month(.wide).day(.twoDigits))
    }
}

