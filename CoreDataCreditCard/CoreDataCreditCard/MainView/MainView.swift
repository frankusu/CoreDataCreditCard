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
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                } else {
                    emptyMessagePrompt
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
    
    private var emptyMessagePrompt: some View {
        VStack {
            Text("You currently have no cards in the system.")
                .padding(.horizontal, 48)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            
            Button {
                shouldPresentAddCardForm.toggle()
            } label: {
                Text("+ Add your first card")
                    .foregroundColor(Color(.systemBackground))
            }
            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            .background(Color(.label))
            .cornerRadius(5)
        }
        .font(.system(size: 22, weight: .semibold))
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
