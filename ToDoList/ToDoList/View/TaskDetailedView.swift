//
//  TaskDetailedView.swift
//  ToDoList
//
//  Created by Виктория Федосова on 05.08.2023.
//

import SwiftUI
import CoreData

struct TaskEditView: View {
	
	private enum Constants {
		static let buttonTitle = "Save"
		static let title = "Task"
	}
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@Environment (\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	@State var passedTask: ToDoTask?
	@State var title: String = ""
	
	init(task: ToDoTask?) {
		if let newTask = task {
			_passedTask = State(initialValue: newTask)
			_title = State(initialValue: newTask.title)
		} else {
			_title = State(initialValue: " ")
		}
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(Constants.title)
				.font(.system(size: 40))
				.bold()
			
			Spacer(minLength: 90)
			
			TextField("hidden text", text: $title)
				.tint(.gray)
				.frame(width: 350.0,
					   height: 50.0,
					   alignment: .center)
				.font(.title3)
				.background(Color("textfield.background"))
				.cornerRadius(10.0)
			Spacer(minLength: 150)
			
			Button(action: saveTask) {
				Text(Constants.buttonTitle)
					.padding(
						EdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 0))
					.font(.title)
					.frame(maxWidth: 300)
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
		.background(.clear)
		.font(.system(size: 40))
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
	}
	
	func saveTask() {
		if passedTask == nil { // вынести в отдельную функцию
			passedTask = ToDoTask(context: managedObjectContext)
			passedTask?.id = UUID()
		}
		passedTask?.title = title
		passedTask?.isChecked = false
		save(context: managedObjectContext)
		presentationMode.wrappedValue.dismiss()
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
