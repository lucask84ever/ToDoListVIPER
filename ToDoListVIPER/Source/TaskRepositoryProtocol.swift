//
//  TaskRepositoryProtocol.swift
//  ToDoListVIPER
//
//  Created by Lucas on 21/04/25.
//

import Foundation

protocol TaskRepositoryProtocol {
    var tasks: [Task] { get }
    func add(_ task: Task)
    func toggleCompletion(for task: Task)
    func getCompletedTasks() -> [Task]
    func getPendingTasks() -> [Task]
}
