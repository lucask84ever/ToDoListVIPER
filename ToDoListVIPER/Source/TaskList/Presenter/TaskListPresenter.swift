//
//  TaskListPresenter.swift
//  ToDoListVIPER
//
//  Created by Lucas on 18/04/25.
//

import Foundation

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [Task])
}

class TaskListPresenter: TaskListPresenterProtocol, TaskListInteractorOutputProtocol {
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorInputProtocol?
    var router: TaskListRouterProtocol?

    func viewDidLoad() {
        interactor?.fetchTasks()
    }

    func didTapAddTask(with title: String) {
        interactor?.addTask(title: title)
    }

    func didFetchTasks(_ tasks: [Task]) {
        let pendingTasks = tasks
        view?.showTasks(pendingTasks)
    }
}
