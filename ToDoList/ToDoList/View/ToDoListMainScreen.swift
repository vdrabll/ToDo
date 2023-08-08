//
//  ToDoListMainScreen.swift
//  ToDoList
//
//  Created by Виктория Федосова on 02.08.2023.
//

import SwiftUI
import CoreData

struct ToDoListMainScreen: View {
	private enum Constants {
		static let sectionNotComplitedName = "not completed"
		static let sectionComplitedName = "completed"
		static let add = "+"
		static let circle = "circle"
		static let circleFill = "checkmark.circle.fill"
	}
	
	@Environment(\.managedObjectContext) var managedObjectContext	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \ToDoTask.title, ascending: true)],
		animation: .default)
	
	private var tasks: FetchedResults<ToDoTask>
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				HStack(spacing: 140) {
					VStack {
						Text(Date(), style: .date)
							.font(.title)
						Text(" \( tasks.filter({$0.isChecked != false}).count) completed, \(tasks.filter({$0.isChecked == false}).count) incompleted")
							.font(.subheadline) }
					.frame(alignment: .bottom)
					NavigationLink(Constants.add) {
						TaskEditView(task: nil)
					}
				}
				List {
					Section(Constants.sectionNotComplitedName) {
						ForEach(tasks) { task in
							if task.isChecked == false {
								HStack {
									Image(systemName: Constants.circle)
										.onTapGesture {
											task.isChecked = true
											self.saveContext()
										}
									NavigationLink(task.title) {
										TaskEditView(task: task)
									}
								}
							}
						}
						.onDelete { index in
							self.deleteItem(at: index)
						}
					}
					Section(Constants.sectionComplitedName) {
						ForEach(tasks) { task in
							if task.isChecked == true {
								HStack {
									Image(systemName: Constants.circleFill)
										.onTapGesture {
											task.isChecked = false
											self.saveContext()
										}
									NavigationLink(task.title) {
										TaskEditView(task: task)
									}
								}
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

extension ToDoListMainScreen {
	func saveContext() {
		do {
			try managedObjectContext.save()
		} catch {
			print(String(error.localizedDescription))
		}
	}
	
	func deleteItem(at offsets: IndexSet) {
		for index in offsets {
			let task = tasks[index]
			managedObjectContext.delete(task)
			do {
				try managedObjectContext.save()
			} catch {
				print(String(error.localizedDescription))
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ToDoListMainScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
