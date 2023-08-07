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
			.frame(width: 200.0, height: 50.0)
	
		}
		.padding(13.0)
		.font(.system(size: 40))
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
			.accentColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
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
