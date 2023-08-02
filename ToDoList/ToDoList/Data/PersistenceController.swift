//
//  PersistenceController.swift
//  ToDoList
//
//  Created by Виктория Федосова on 02.08.2023.
//

import Foundation
import CoreData

struct PersistenceController {
	static let shared = PersistenceController()
	let container: NSPersistentContainer
	
	static var preview: PersistenceController = {
		let controller = PersistenceController(inMemory: true)
		for _ in 0..<10 {
			let task = Task(context: controller.container.viewContext)
			task.title = "task "
			
		}
		return controller
	}()
	
	init(inMemory: Bool = false) {
		
		container = NSPersistentContainer(name: "ToDoListModel")
		
		if inMemory {
			container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Error: \(error.localizedDescription)")
			}
		}
	}
	
	func save() {
		let context = container.viewContext

		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print(String(describing: error.localizedDescription))
			}
		}
	}
}
