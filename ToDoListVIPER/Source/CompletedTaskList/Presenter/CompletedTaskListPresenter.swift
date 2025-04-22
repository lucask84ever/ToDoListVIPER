//
//  CompletedTaskListPresenter.swift
//  ToDoListVIPER
//
//  Created by Lucas on 19/04/25.
//

import Foundation

class CompletedTaskListPresenter: CompletedTaskListPresenterProtocol {
    var presenter: CompletedTaskListPresenterProtocol?
    var view: TaskListViewProtocol?
    var interactor: CompletedTaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    func didFetchTasks(_ tasks: [Task]) {
        view?.showTasks(tasks)
    }
    
    
    func viewDidLoad() {
        interactor?.fetchCompletedTasks()
    }
}
