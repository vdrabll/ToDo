//
//  ToDoTask+CoreDataProperties.swift
//  ToDoList
//
//  Created by Виктория Федосова on 02.08.2023.
//
//

import Foundation
import CoreData
 
@objc(ToDoTask)
public class ToDoTask: NSManagedObject {

}

extension ToDoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoTask> {
        return NSFetchRequest<ToDoTask>(entityName: "ToDoTask")
    }

    @NSManaged public var id: UUID
    @NSManaged public var isChecked: Bool
    @NSManaged public var title: String

}

extension ToDoTask : Identifiable {

}
