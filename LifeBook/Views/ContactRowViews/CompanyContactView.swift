//
//  CompanyContactView.swift
//  LifeBook
//
//  Created by Wilfred Lalonde on 2023-03-20.
//

import SwiftUI

struct CompanyContactView: View {
    
    @ObservedObject var contact: Contact
    @ObservedObject var numbersOnlyAlgorithm = NumbersOnlyAlgorithm()
    @State var callThisNumber: String = ""
    let phonePrefix = "tel://"
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Image("CompanyImage")
                    .resizable()
                    .foregroundColor(Color.themeBlue)
                    .frame(width: 15, height: 15)
                
                Text(contact.name)
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundColor(.black)
            }
            
            
            Text(contact.phoneNumber)
                .font(.callout)
                .foregroundColor(Color(red: 104/255, green: 24/255, blue: 79/255))
            
        }  //  VStack
    }
}
