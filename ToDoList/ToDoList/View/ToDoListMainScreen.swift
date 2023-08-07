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
		NavigationStack {
			VStack {
				VStack(alignment: .leading) {
				 HStack(spacing: 140) {
					 VStack {
						 Text(Date(), style: .date)
							 .font(.title)
						 Text(" \( tasks.filter({$0.isChecked != false}).count) completed, \(tasks.filter({$0.isChecked == false}).count) incompleted")
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
								 HStack {
									 Image(systemName: "circle")
										 .onTapGesture {
											 task.isChecked = true
											 do {
												 try managedObjectContext.save()
											 } catch {
												 print(String(error.localizedDescription))
											 }
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
					 Section("completed") {
						 ForEach(tasks) { task in
							 if task.isChecked == true {
								 HStack {
									 Image(systemName: "checkmark.circle.fill")
										 .onTapGesture {
											 task.isChecked = false
											 do {
												 try managedObjectContext.save()
											 } catch {
												 print(String(error.localizedDescription))
											 }
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
	
	func changeStatus() -> Image {
		Image("curcle")
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ToDoListMainScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
