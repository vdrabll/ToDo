//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Виктория Федосова on 02.08.2023.
//

import SwiftUI

@main
struct ToDoListApp: App {
	let persistenceController = PersistenceController.shared
	
    var body: some Scene {
        WindowGroup {
			ToDOListMainScreen()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
