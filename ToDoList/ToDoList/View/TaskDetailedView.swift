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
		if let newtask = task {
			_passedTask = State(initialValue: task)
			_title = State(initialValue: newtask.title)
		} else {
			_title = State(initialValue: " ")
		}
	}
	var body: some View {
		VStack(alignment: .center) {
			Text(Constants.title)
				.font(.system(size: 40))
				.bold()
			Spacer(minLength: 90)
			
			TextField("", text: $title)
				.frame(width: 350.0,
					   height: 50.0 ,
					   alignment: .center)
				.font(.title3)
				.background(.white)
				.cornerRadius(10.0)
			Spacer(minLength: 150)
			
			
			Button(Constants.buttonTitle) {
				if passedTask == nil {
					passedTask = ToDoTask(context: managedObjectContext)
				}
				passedTask?.title = title
				passedTask?.id = UUID()
				passedTask?.isChecked = false
				save(context: managedObjectContext)
				presentationMode.wrappedValue.dismiss()
			}
			.fontWeight(.medium)
			.tint(.black)
	
		}
		.padding(25.0)
		.font(.system(size: 40))
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
			.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("textfield.background")/*@END_MENU_TOKEN@*/)
			
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
			.padding()
			.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("textfield.background")/*@END_MENU_TOKEN@*/)
	}
}
