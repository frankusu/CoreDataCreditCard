//
//  AddTransactionForm.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-28.
//

import SwiftUI

struct AddTransactionForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    NavigationLink("Many to Many", destination: {
                        Text("Many").navigationTitle(Text("New Title"))
                    })
                }, header: { Text("Information")})
                
                
                Section(content: {
                    Button {
                        
                    } label: {
                        Text("Select Photo")
                    }
                }, header: {
                    Text("Photo/Receipt")
                })
                
            }
            .navigationTitle("Add transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            
            
        }
    }
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
    private var saveButton: some View {
        Button {
            
        } label: {
            Text("Save")
        }
    }
}
