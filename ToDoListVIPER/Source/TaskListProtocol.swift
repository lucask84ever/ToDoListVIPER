//
//  TaskListProtocol.swift
//  ToDoListVIPER
//
//  Created by Lucas on 18/04/25.
//

import UIKit

protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [Task])
}

protocol TaskListRouterProtocol: AnyObject {
    static func createModule(coreDataRepository: CoreDataTaskRepository) -> UIViewController
}
