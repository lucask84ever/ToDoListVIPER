//
//  CompletedTaskListInteractor.swift
//  ToDoListVIPER
//
//  Created by Lucas on 19/04/25.
//

import Foundation

protocol CompletedTaskListInteractorProtocol: AnyObject {
    var presenter: CompletedTaskListPresenterProtocol? { get set }
    var repository: TaskRepositoryProtocol { get set }
    var coreDataRepository: TaskRepositoryProtocol { get set }
    func fetchCompletedTasks()
    
}

class CompletedTaskListInteractor: CompletedTaskListInteractorProtocol {
    var repository: TaskRepositoryProtocol
    var coreDataRepository: TaskRepositoryProtocol
    var presenter: CompletedTaskListPresenterProtocol?
    
    init(repository: TaskRepositoryProtocol, coreDataRepository: TaskRepositoryProtocol) {
        self.repository = repository
        self.coreDataRepository = coreDataRepository
    }
    
    func fetchCompletedTasks() {
        presenter?.didFetchTasks(coreDataRepository.getCompletedTasks())
    }
}
