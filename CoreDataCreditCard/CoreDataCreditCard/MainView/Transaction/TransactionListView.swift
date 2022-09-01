//
//  TransactionListView.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-30.
//

import SwiftUI

struct TransactionListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var shouldShowAddTransactionForm = false
    
    let card: Card
    var fetchRequest: FetchRequest<CardTransaction>
    
    init(card: Card) {
        self.card = card
        
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [.init(key: "timestamp", ascending: false)],
            predicate: .init(format: "card == %@", self.card))
    }
    
    var body: some View {
        VStack {
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
                AddTransactionForm(card: card)
            })
            
            ForEach(fetchRequest.wrappedValue) { transaction in
                CardTransactionView(transaction: transaction)
            }
        }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static let firstCard: Card? = {
        let context = PersistenceController.shared.container.viewContext
        let request = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        return try? context.fetch(request).first
    }()
    
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ScrollView {
            if let card = firstCard {
                TransactionListView(card: card)
            }
            
        }
        
            .environment(\.managedObjectContext, context)
    }
}
