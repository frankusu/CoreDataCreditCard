//
//  MainView.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-26.
//

import SwiftUI

struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timeStamp , ascending: true)],
        animation: .default)
    
    private var cards: FetchedResults<Card>
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if !cards.isEmpty {
                    TabView{
                        ForEach(cards) { card in
                            CreditCardView()
                                .padding(.bottom, 50)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil, content: {
                        AddCardForm()
                    })
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading:
                HStack {
                    addItemButton
                    deleteAllButton
                },
                trailing: addCardButton)
        }
        
    }
    
    private var deleteAllButton: some View {
        Button(action: {
            cards.forEach { card in
                viewContext.delete(card)
                
                do {
                    try viewContext.save()
                } catch {
                    //error stuff
                }
            }
        }, label: {
            Text("Delete All")
        })
    }
    
    private var addItemButton: some View {
        Button(action: {
            withAnimation {
//                let viewContext = PersistenceController.shared.container.viewContext
                let card = Card(context: viewContext)
                card.timeStamp = Date()
                
                do {
                    try viewContext.save()
                } catch {
                    //error handling
                }
            }
        }, label: {
            Text("Add Item")
        })
    }
    
    struct CreditCardView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Apple Blue Visa Card")
                    .font(.system(size: 24, weight: .semibold))
                
                HStack {
                    Image("visa")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                        .clipped()
                    Spacer()
                    Text("Balance: $5,000")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text("1234 1234 1234 1234")
                
                Text("Credit Limit: $50,000")
                
                HStack{ Spacer() }
                
                
                
            }
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(colors: [
                    Color.blue.opacity(0.6),
                    Color.blue
                ], startPoint: .center, endPoint: .bottom)
            )
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
            
        }
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
