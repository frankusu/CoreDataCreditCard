//
//  AddTransactionForm.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-28.
//

import SwiftUI

struct AddTransactionForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
    let card: Card
    
    @State private var photoData: Data?
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    
    @State private var shouldPresentPhotoPicker = false
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    NavigationLink("Many to Many", destination: {
                        Text("Many").navigationTitle(Text("New Title"))
                    })
                }, header: { Text("Information")})
                
                
                Section(content: {
                    Button {
                        shouldPresentPhotoPicker.toggle()
                    } label: {
                        Text("Select Photo")
                    }
                    .fullScreenCover(isPresented: $shouldPresentPhotoPicker, content: {
                        PhotoPickerView(photoData: $photoData)
                    })
                }, header: {
                    Text("Photo/Receipt")
                })
                
                if let photoData = photoData, let image = UIImage(data: photoData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                
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
            let transaction = CardTransaction(context: viewContext)
            transaction.name = self.name
            transaction.timestamp = self.date
            transaction.amount = Float(self.amount) ?? 0
            transaction.photoData = self.photoData
            
            transaction.card = self.card
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch let customError {
                print("Failed to save transaction: \(customError)")
            }
            
        } label: {
            Text("Save")
        }
    }
}
