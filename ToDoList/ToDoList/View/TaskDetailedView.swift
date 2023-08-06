//
//  TaskDetailedView.swift
//  ToDoList
//
//  Created by Виктория Федосова on 05.08.2023.
//

import SwiftUI
import CoreData

struct TaskEditView: View {
	@Environment(\.managedObjectContext) var managedObjectContext
	@Environment (\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	@State var passedTask: ToDoTask?
	@State var title: String = ""
	
	init(task: ToDoTask?) {
		if let newtask = task {
			_passedTask = State(initialValue: task)
			_title = State(initialValue: newtask.title)
		} else {
			_title = State(initialValue: " ")
		}
	}
	var body: some View {
		VStack(alignment: .center) {
			Text("Task")
				.font(.system(size: 55))
				.bold()
			Spacer(minLength: 90)
			
			TextField("", text: $title)
				.frame(width: 350.0,
					   height: 50.0 ,
					   alignment: .center)
				.foregroundColor(.gray)
			Spacer(minLength: 150)
			
			
			Button("Save") {
					if passedTask == nil {
						passedTask = ToDoTask(context: managedObjectContext)
					}
				passedTask?.title = title
				passedTask?.id = UUID()
				passedTask?.isChecked = false
				save(context: managedObjectContext)
				presentationMode.wrappedValue.dismiss()
				}
			}
			.font(.system(size: 40))
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
		}
	
	func save(context: NSManagedObjectContext) {
		do {
			try context.save()
		} catch {
			print(String(error.localizedDescription))
		}
	}
	}


struct TaskEditView_Previews: PreviewProvider {
	static var previews: some View {
		TaskEditView(task: nil)
	}
}
