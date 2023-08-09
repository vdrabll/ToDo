//
//  ToDoListMainScreen.swift
//  ToDoList
//
//  Created by Виктория Федосова on 02.08.2023.
//

import SwiftUI
import CoreData

struct ToDoListView: View {
	private enum Constants {
		static let sectionNotCompletedName = "not completed"
		static let sectionCompletedName = "completed"
		static let add = "+"
		static let circle = "circle"
		static let circleFill = "checkmark.circle.fill"
		static let subheadline = " %i completed, %i incompleted"
	}
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \ToDoTask.title, ascending: true)],
		animation: .default)
	
	private var tasks: FetchedResults<ToDoTask>
	
	var body: some View {
		NavigationStack {
			VStack() {
				HStack() {
					VStack() {
						Text(Date(), style: .date)
							.font(
								Font.custom("Inter", size: 32)
									.weight(.bold)
							)
							.frame(maxWidth: .infinity, alignment: .leading )
							.padding(EdgeInsets(top: 0,
												leading: 20,
												bottom: 0,
												trailing: 0))
						
						Text(String(format: Constants.subheadline,
									(tasks.filter({$0.isChecked != false})).count,
									(tasks.filter({$0.isChecked != false})).count))
						.font(.subheadline)
						.frame(maxWidth: .infinity, alignment: .leading )
						.padding(EdgeInsets(top: 0,
											leading: 20,
											bottom: 0,
											trailing: 0))
					
					 }
					
					NavigationLink(Constants.add) {
						TaskEditView(task: nil)
					}
					.padding(EdgeInsets(top: 0,
										leading: 0,
										bottom: 0,
										trailing: 40))
				}
				
				List {
					Section(Constants.sectionNotCompletedName) {
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
							self.deleteTodo(index)
						}
					}
					Section(Constants.sectionCompletedName) {
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
							self.deleteTodo(index)
						}
					}
				}
			}
		}
	}
}

extension ToDoListView {
	func saveContext() {
		do {
			try managedObjectContext.save()
		} catch {
			print(String(error.localizedDescription))
		}
	}
	
	private func deleteTodo(_ index: IndexSet) { withAnimation {
		let todo: ToDoTask? = index.map {
			tasks [$0]
		}.first
		if (todo != nil) {
			managedObjectContext.delete(todo!)
			saveContext()
		}
	 }
  }
}

struct ToDoListView_Previews: PreviewProvider {
	static var previews: some View {
		ToDoListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}

