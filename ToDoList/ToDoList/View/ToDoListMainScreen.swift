//
//  ToDoListMainScreen.swift
//  ToDoList
//
//  Created by Виктория Федосова on 02.08.2023.
//

import SwiftUI
import CoreData

struct ToDoListMainScreen: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \ToDoTask.title, ascending: true)],
		animation: .default)
	
	private var tasks: FetchedResults<ToDoTask>
	var body: some View {
		NavigationStack() {
			VStack() {
				VStack(alignment: .leading) {
				 HStack(spacing: 140) {
					 VStack {
						 Text(Date(), style: .date)
							 .font(.title)
						 Text(" \(tasks.count) completed, \(tasks.count) incompleted")
							 .font(.subheadline)
					 }
					 
					 .frame(alignment: .bottom)
					 NavigationLink("+") {
						 TaskEditView(task: nil)
					 }
				 }
				 List {
					 Section("not completed") {
						 ForEach(tasks) { task in
							 if task.isChecked == false {
								 NavigationLink(task.title) {
									 TaskEditView(task: task)
								 }
							 }
						 }
						 .onDelete { index in
							 self.deleteItem(at: index)
						 }
					 }
					 Section("completed ") {
						 ForEach(tasks) { task in
							 if task.isChecked == true {
								 NavigationLink(task.title) {
									 TaskEditView(task: task)
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
}

extension ToDoListMainScreen {
	
	
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
