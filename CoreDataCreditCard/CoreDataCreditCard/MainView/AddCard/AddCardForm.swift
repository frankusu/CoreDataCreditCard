//
//  AddCardForm.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-27.
//

import SwiftUI

struct AddCardForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
    let card: Card?
    
    init(card: Card? = nil) {
        self.card = card
        
        _name = State(initialValue: self.card?.name ?? "")
        _cardNumber = State(initialValue: self.card?.number ?? "")
        
        _cardType = State(initialValue: self.card?.type ?? "Visa")
        
        if let limit = card?.limit {
            _limit = State(initialValue: String(limit))
        }
        
        _month = State(initialValue: Int(self.card?.expMonth ?? 1))
        _year = State(initialValue: Int(self.card?.expYear ?? Int16(currentYear)))
        
        if let data = self.card?.color, let uiColor = UIColor.color(data: data) {
            let c = Color(uiColor: uiColor)
            _color = State(initialValue: c)
        }
    }
    
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
            .navigationTitle(self.card != nil ? self.card?.name ?? "" : "Add Credit Card")
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            let card = self.card != nil ? self.card! : Card(context: viewContext)
            
            card.name = self.name
            card.number = self.cardNumber
            card.limit = Int32(self.limit) ?? 0
            card.expMonth = Int16(self.month)
            card.expYear = Int16(self.year)
            card.timestamp = Date()
            card.color = UIColor(self.color).encode()
            card.type = cardType
            
            do {
                try viewContext.save()
                
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Failed to persist new card \(error)")
            }
        }, label: {
            Text("Save")
        })
    }
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
//        AddCardForm()
        MainView()
    }
}
