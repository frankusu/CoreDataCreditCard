//
//  MainView.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-26.
//

import SwiftUI

struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    @State private var shouldShowAddTransactionForm = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp , ascending: true)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: true)],
        animation: .default)
    private var transactions: FetchedResults<CardTransaction>
    
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
                    
                    Text("Get started by adding your first transaction")
                    
                    Button {
                        shouldShowAddTransactionForm.toggle()
                    } label: {
                        Text("+ Transaction")
                            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                            .background(Color(.label))
                            .foregroundColor(Color(.systemBackground))
                            .font(.headline)
                            .cornerRadius(5)
                    }
                    .fullScreenCover(isPresented: $shouldShowAddTransactionForm, content: {
                        AddTransactionForm()
                    })
                    
                    ForEach(transactions) { transaction in
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(transaction.name ?? "")
                                        .font(.headline)
                                    if let date = transaction.timestamp {
                                        Text(dateFormatter.string(from: date))
                                    }
                                }
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .font(.system(size: 24))
                                    }
                                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                                    
                                    Text(String(format: "$%.2f", transaction.amount ))
                                }
                            }
                            
                            if let photoData = transaction.photoData, let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                            }
                            
                        }
                        .foregroundColor(Color(.label))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                        .padding()
                    }
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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none // TODO: what if I comment this out ?
        return formatter
    }()
    
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
                card.timestamp = Date()
                
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
