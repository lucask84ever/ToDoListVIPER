//
//  TaskListRouter.swift
//  ToDoListVIPER
//
//  Created by Lucas on 18/04/25.
//

import UIKit

class TaskListRouter: TaskListRouterProtocol {
    static func createModule(coreDataRepository: CoreDataTaskRepository) -> UIViewController {
        let view = TaskListViewController()
        let presenter: TaskListPresenterProtocol & TaskListInteractorOutputProtocol = TaskListPresenter()
        let interactor: TaskListInteractorInputProtocol = TaskListInteractor(coreDataRepository: coreDataRepository)
        let router: TaskListRouterProtocol = TaskListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}
