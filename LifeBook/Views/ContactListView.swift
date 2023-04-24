//
//  ContentView.swift
//  MyPeople
//
//  Created by Wilfred Lalonde on 2023-03-03.
//
//  Personal Access Token for GitHub: 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

import SwiftUI
import MessageUI

struct FilterConfig: Equatable, Hashable {
    
    //  Supports the Favorite Filter Menu
    enum Filter {
        case Favorite, Person, Company, Medical, All
    }
    var filterType: Filter = .All
    //*******************************
    
    //  Supports the Search Bar
    var query: String = ""
}
//*******************************

//  Supports the Sort Menu
enum Sort {
    case ascending, descending
}
//*******************************

struct ContactListView: View {
    
    //    @FetchRequest(fetchRequest: Contact.fave()) private var contacts
    @FetchRequest(fetchRequest: Contact.all()) private var contacts
    
    @State private var contactToEdit: Contact?
    @State private var filterConfig: FilterConfig = .init()
    @State private var sort: Sort = .ascending
    @State private var faveDefault: Bool = false
    @State var navTitle: String = "Favorites"
    @State private var filterMenuSelection: String = ""
    @State private var sortMenuSelection: String = ""
    
    var DBmanager = CoreDataManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                if contacts.isEmpty {
                    ZeroContactsView()      //  Displays a view, asking the user to add contacts.
                } else {
                    
                    List {
                        ForEach(contacts) { contact in
                            
                            ZStack(alignment: .leading) {
                                NavigationLink(destination: ContactDetailView(contact: contact)) {
                                    EmptyView()     //  This overlays an empty space, that offers the tap/link to detail.
                                }
                                .opacity(0)
                                //***************************************
                                
                                ContactRowView(contact: contact, dbManager: DBmanager)
                                    .swipeActions(allowsFullSwipe: false) {
                                        
                                        
                                        Button(role: .destructive) {        //  DELETE FUNCTION
                                            do {
                                                try DBmanager.delete(contact, context: DBmanager.editContext)
                                            } catch {
                                                print("Error deleting: \(error)")
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(Color(red: 204/255, green: 0/255, blue: 0/255))
                                        
                                        
                                        Button {                            //  EDIT FUNCTION
                                            contactToEdit = contact
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(Color(red: 0/255, green: 153/255, blue: 0/255))
                                    }
                            }
                        }
                    }
                }
            }
            .searchable(text: $filterConfig.query)      //  Brings up the search bar on the view.
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        contactToEdit = .emptyPreview(context: DBmanager.editContext)
                    } label: {
                            Image(systemName: "doc.fill.badge.plus")
                                .renderingMode(.original)
                                .foregroundColor(Color.themeDarkCranberry)
                                .font(.largeTitle)
                     }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section {
                            Text("Filter")
                            
                            Picker(selection: $filterConfig.filterType) {
                                Text("Favorite").tag(FilterConfig.Filter.Favorite)
                                Text("Person").tag(FilterConfig.Filter.Person)
                                Text("Company").tag(FilterConfig.Filter.Company)
                                Text("Medical").tag(FilterConfig.Filter.Medical)
                                Text("All").tag(FilterConfig.Filter.All)
                            } label: {
//                                Text("Filter")
                            }
                            
                        }
                        Section {
                            Text("Sort Contacts")
                            
                            Picker(selection: $sort) {
                                Text("Ascending").tag(Sort.ascending)
                                Text("Descending").tag(Sort.descending)
                            } label: {
                                //                                Text("Sort")
                            }
                        }
                        
                    } label: {
                            Image(systemName: "doc.fill.badge.ellipsis")
                                .renderingMode(.original)
                                .foregroundColor(Color.themeDarkLilac)
                                .font(.largeTitle)
                    }
                }
            }
            .sheet(item: $contactToEdit, onDismiss: {
                contactToEdit = nil
                
            }, content: { contact in
                NavigationStack {
                    CreateContactView(vm: .init(provider: DBmanager, contact: contact))
                }
            })
            .navigationTitle("LifeBook: \(String(describing: filterConfig.filterType))")
            .onChange(of: filterConfig) { newConfig in
                contacts.nsPredicate = Contact.configureFilter(with: newConfig)
            }
            
            .onChange(of: sort) { newSort in
                contacts.nsSortDescriptors = Contact.sort(order: newSort)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let preview = CoreDataManager.shared
//        ContactListView(DBmanager: preview)
//            .environment(\.managedObjectContext, preview.viewContext)
//            .previewDisplayName("Sample Contacts data")
//            .onAppear { Contact.multiPreview(count: 10, in: preview.viewContext)}
//        
//        let blankPreview = CoreDataManager.shared
//        ContactListView(DBmanager: blankPreview)
//            .environment(\.managedObjectContext, blankPreview.viewContext)
//            .previewDisplayName("No Contacts data")
//    }
//}
