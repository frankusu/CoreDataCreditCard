//
//  AddCardForm.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-27.
//

import SwiftUI

struct AddCardForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var cardNumber = ""
    @State private var limit = ""
    
    @State private var cardType = "Visa"
    
    @State private var month = 1
    @State private var year = Calendar.current.component(.year, from: Date())
    
    @State private var color = Color.blue
    
    let currentYear = Calendar.current.component(.year, from: Date())
    var body: some View {
        NavigationView {
            
            Form {
                Section(content: {
                    TextField("Name", text: $name)
                    TextField("Credit Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $limit)
                        .keyboardType(.numberPad)
                    
                    Picker("Type", selection: $cardType) {
                        ForEach( ["Visa", "Mastercard", "Discovery", "Citibank"], id: \.self) { cardType in
                            Text(cardType).tag(cardType)
                        }
                    }
                    
                    
                }, header: { Text("Card Info") })
                
                Section(content: {
                    Picker("Month", selection: $month) {
                        ForEach(1..<13) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                    
                    Picker("Year", selection: $year) {
                        ForEach(currentYear..<currentYear + 20, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                }, header: {
                    Text("Expiration")
                })
                
                Section(content: {
                    ColorPicker(selection: $color, label: { Text("Color")})
                }, header: {
                    Text("Color")
                })
                
            }
                .navigationTitle("Add Credit Card")
                .navigationBarItems(leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }))
        }
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
//        AddCardForm()
        MainView()
    }
}
