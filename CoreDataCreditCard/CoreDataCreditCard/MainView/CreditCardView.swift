//
//  CreditCardView.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-28.
//

import SwiftUI

struct CreditCardView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var refreshId = UUID() // force refresh when edit is saved
    var card: Card
    
    @State private var shouldShowActionSheet = false
    @State private var shouldShowEditSheet = false
    
    private func handleDelete() {
        viewContext.delete(card)
        
        do {
            try viewContext.save()
        } catch {
            print("cannot delete card \(error)")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text(card.name ?? "")
                    .font(.system(size: 24, weight: .semibold))
                Spacer()
                Button {
                    shouldShowActionSheet.toggle()
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 28, weight: .bold))
                }
                .confirmationDialog("dodododo", isPresented: $shouldShowActionSheet, actions: {
                    Button(role: .none, action: { shouldShowEditSheet.toggle()}, label: { Text("Edit")})
                    Button(role: .destructive ,action: { handleDelete() }, label: {
                        //TODO: deleting last card in list crashes the app
                        Text("Delete Card")
                    })
                }, message: {
                    Text("Credit card \(self.card.name ?? "") will be deleted")
                })
            }
            
            
            
            HStack {
                let imageName = card.type?.lowercased() ?? ""
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                    .clipped()
                Spacer()
                Text("Balance: $5,000")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Text(card.number ?? "")
            
            Text("Credit limit $\(card.limit)")
            
            HStack{ Spacer() }
        }
        .foregroundColor(.white)
        .padding()
        .background(VStack { // background modifier needs a view so just use a vstack
            if let colorData = card.color,
               let uiColor = UIColor.color(data: colorData),
               let actualColor = Color(uiColor: uiColor) {
                LinearGradient(colors: [
                    actualColor.opacity(0.6),
                    actualColor
                ], startPoint: .center, endPoint: .bottom)
            } else {
                Color.purple
            }
        })
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.black.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.top, 8)
        .fullScreenCover(isPresented: $shouldShowEditSheet, content: {
            AddCardForm(card: self.card)
        })
        
    }
}
