//
//  BlankContactsView.swift
//  MyPeople
//
//  Created by Wilfred Lalonde on 2023-03-05.
//

import SwiftUI

struct ZeroContactsView: View {
    var body: some View {
        VStack {
            Text("👀 Zero Contacts")
                .font(.largeTitle.bold())
            Text("It seems empty here...create some contacts!")
                .font(.callout)
        }
    }
}

struct BlankContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ZeroContactsView()
    }
}
