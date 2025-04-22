//
//  CompletedTaskListRouter.swift
//  ToDoListVIPER
//
//  Created by Lucas on 19/04/25.
//

import UIKit

class CompletedTaskListRouter: TaskListRouterProtocol {
    static func createModule(taskRepository: TaskRepository, coreDataRepository: CoreDataTaskRepository) -> UIViewController {
        let view = CompletedTasksViewController()
        let presenter = CompletedTaskListPresenter()
        let interactor = CompletedTaskListInteractor(repository: taskRepository, coreDataRepository: coreDataRepository)
        let router = CompletedTaskListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}
