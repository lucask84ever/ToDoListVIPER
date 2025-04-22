//
//  TaskRepository.swift
//  ToDoListVIPER
//
//  Created by Lucas on 21/04/25.
//

import Foundation

final class TaskRepository: TaskRepositoryProtocol {
    private(set) var tasks: [Task] = []
    
    init() {
        
    }

    func add(_ task: Task) {
        tasks.append(task)
    }

    func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }

    func getCompletedTasks() -> [Task] {
        return tasks.filter { $0.isDone }
    }
    
    func getPendingTasks() -> [Task] {
        return tasks.filter { !$0.isDone }
    }
}
