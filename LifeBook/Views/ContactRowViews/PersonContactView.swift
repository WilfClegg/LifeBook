//
//  PersonContactView.swift
//  LifeBook
//
//  Created by Wilfred Lalonde on 2023-03-20.
//

import SwiftUI

struct PersonContactView: View {
    
    @ObservedObject var contact: Contact
    @ObservedObject var numbersOnlyAlgorithm = NumbersOnlyAlgorithm()
    let phonePrefix = "tel://"
    
    @State var callThisNumber: String = ""
    @State var sendThisEmail: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Image("PersonImage")
                    .resizable()
                    .foregroundColor(Color.themeBlue)
                    .frame(width: 15, height: 15)
                if contact.birthdayAdded {
                    Text(contact.formattedName)
                } else {
                    Text(contact.name)
                }
            }  //  HStack
            .font(.system(size: 20, design: .rounded).bold())
            .foregroundColor(.black)
            
            HStack {
                Text(contact.phoneNumber)
                    .font(.callout)
                    .foregroundColor(Color(red: 104/255, green: 24/255, blue: 79/255))
                Spacer()
                if contact.birthdayAdded {
                    Text(contact.dob.displayFormat)
                        .foregroundColor(Color(red: 104/255, green: 24/255, blue: 79/255))
                        .bold()
                }
            }  //  HStack
        }  //  VStack
    }
}

private extension Date {
    var displayFormat: String {
        self.formatted(.dateTime.month(.wide).day(.twoDigits))
    }
}

