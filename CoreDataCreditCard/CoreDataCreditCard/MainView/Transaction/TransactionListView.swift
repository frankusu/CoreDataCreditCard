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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: true)],
        animation: .default)
    private var transactions: FetchedResults<CardTransaction>
    
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
                AddTransactionForm()
            })
            
            ForEach(transactions) { transaction in
                CardTransactionView(transaction: transaction)
            }
        }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ScrollView {
            TransactionListView()
        }
        .environment(\.managedObjectContext, context)
        
    }
}
