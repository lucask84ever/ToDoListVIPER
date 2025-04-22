//
//  TaskListInteractor.swift
//  ToDoListVIPER
//
//  Created by Lucas on 18/04/25.
//

import Foundation

protocol TaskListInteractorInputProtocol: AnyObject {
    var presenter: (TaskListPresenterProtocol & TaskListInteractorOutputProtocol)? { get set }
    var coreDataRepository: TaskRepositoryProtocol { get set }
    
    func fetchTasks()
    func addTask(title: String)
    func toggleTask(_ task: Task)
}

class TaskListInteractor: TaskListInteractorInputProtocol {
    var presenter: (TaskListInteractorOutputProtocol & TaskListPresenterProtocol)?
    var coreDataRepository: TaskRepositoryProtocol
    
    init(coreDataRepository: TaskRepositoryProtocol) {
        self.coreDataRepository = coreDataRepository
    }
    
    func fetchTasks() {
        presenter?.didFetchTasks(coreDataRepository.getPendingTasks())
    }

    func addTask(title: String) {
        let newTask = Task(id: UUID(), title: title, isDone: false, createdAt: Date())
        coreDataRepository.add(newTask)
        presenter?.didFetchTasks(coreDataRepository.getPendingTasks())
    }
    
    func toggleTask(_ task: Task) {
        coreDataRepository.toggleCompletion(for: task)
        presenter?.didFetchTasks(coreDataRepository.getPendingTasks())
    }
}
