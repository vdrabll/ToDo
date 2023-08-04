//
//  ContentView.swift
//  ToDoList
//
//  Created by Виктория Федосова on 02.08.2023.
//

import SwiftUI
import CoreData

struct ToDOListMainScreen: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ToDoTask.title, ascending: true)],
		animation: .default)
	private var tasks: FetchedResults<ToDoTask>
	var body: some View {
		VStack {
			VStack(alignment: .leading) {
				HStack(spacing: 140) {
					VStack {
						Text(Date(), style: .date)
							.font(.title)
						Text(" \(tasks.count) complited, \(tasks.count) incomplited")
							.font(.subheadline)
					}
					Button("add") {
						let task = ToDoTask(context: managedObjectContext)
						task.isChecked = Bool.random()
						task.title = "im task in core data coredata "
						task.id = UUID()
						PersistenceController.shared.save()
					}
					.frame(alignment: .bottom)
				}
				List {
					Section("incomplited") {
						ForEach(tasks) { task in
							if task.isChecked == false {
								Text(task.title)
							}
						}
						.onDelete { index in
							self.deleteItem(at: index)
						}
					}
					Section("complited") {
						ForEach(tasks) { task in
							if task.isChecked == true {
								Text(task.title)
									.foregroundColor(.gray)
							}
						}
						.onDelete { index in
							self.deleteItem(at: index)
						}
					}
				}
			}
		}
	}
}

extension ToDOListMainScreen {
	func deleteItem(at offsets: IndexSet) {
		for index in offsets {
			let task = tasks[index]
			managedObjectContext.delete(task)
			PersistenceController.shared.save()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ToDOListMainScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
