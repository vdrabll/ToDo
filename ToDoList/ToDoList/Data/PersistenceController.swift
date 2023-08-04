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
		let viewContext = controller.container.viewContext
		
		for item in 0..<5 {
			let task = ToDoTask(context: viewContext)
			task.title = "task true - \(item)"
			task.id = UUID()
			task.isChecked = true
		}
		
		for item in 0..<5 {
			let task = ToDoTask(context: viewContext)
			task.title = "task false - \(item)"
			task.id = UUID()
			task.isChecked = false
		}
		controller.save()
		return controller
	}()
	
	init(inMemory: Bool = false) {
		container = NSPersistentContainer(name: "ToDoListModel")
		
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error {
				print(String(describing: storeDescription))
				print(String(describing: error))
			}
		}
	}
	
	func save() {
		let context = container.viewContext

		if context.hasChanges {
			do {
				try context.save()
			} catch {
				context.rollback()
				print(String(describing: error.localizedDescription))
			}
		}
	}
}
