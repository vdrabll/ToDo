//
//  ContentView.swift
//  ToDoList
//
//  Created by Виктория Федосова on 02.08.2023.
//

import SwiftUI
import CoreData

struct ToDOListMainScreen: View {
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
						print("hello")
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
					}
					Section("complited") {
						ForEach(tasks) { task in
							if task.isChecked == true {
								Text(task.title)
									.foregroundColor(.gray)
							}
						}
					}
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ToDOListMainScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
