//
//  AddCardForm.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-27.
//

import Foundation

struct AddCardForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                Text("Add card form")
                
                TextField("Name", text: $name)
            }
            .navigationTitle("")
        }
    }
}
