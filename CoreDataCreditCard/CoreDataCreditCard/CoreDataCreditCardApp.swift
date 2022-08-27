//
//  CoreDataCreditCardApp.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-26.
//

import SwiftUI

@main
struct CoreDataCreditCardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
