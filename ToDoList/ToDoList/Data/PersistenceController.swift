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
			
			let task2 = ToDoTask(context: viewContext)
			task2.title = "task false - \(item)"
			task2.id = UUID()
			task2.isChecked = false
		}
		
		do {
			try viewContext.save()
		} catch {
			print(String(describing: error.localizedDescription))
		}
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
}
