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
    @State private var selectedCategories = Set<TransactionCategory>()
    
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }, header: { Text("Information")})
                
                
                Section(content: {
                    NavigationLink(destination: {
                        CategoriesListView(selectedCategories: $selectedCategories).navigationTitle("Categories")
                                                .environment(\.managedObjectContext, viewContext)
                    }, label: { Text("Select categories") })
                    
                    let sortByTimestampCategories = Array(selectedCategories).sorted(by: {$0.timestamp?.compare($1.timestamp ?? Date()) == .orderedDescending })
                    
                    ForEach(sortByTimestampCategories) { category in
                        HStack(spacing: 12) {
                            if let data = category.colorData, let uiColor = UIColor.color(data: data) {
                                let color = Color(uiColor)
                                Spacer()
                                    .frame(width: 30, height: 10)
                                    .background(color)
                            }
                            Text(category.name ?? "")
                        }
                    }
                    
                }, header: { Text("Categories") })
                
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
            transaction.categories = self.selectedCategories as NSSet
            
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
