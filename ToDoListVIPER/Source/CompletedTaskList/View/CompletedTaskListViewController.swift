//
//  CompletedTaskListViewController.swift
//  ToDoListVIPER
//
//  Created by Lucas on 19/04/25.
//

import UIKit

protocol CompletedTaskListPresenterProtocol {
    
    var view: TaskListViewProtocol? { get set }
    var presenter: CompletedTaskListPresenterProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }
    
    func viewDidLoad()
    func didFetchTasks(_ tasks: [Task])
}

class CompletedTasksViewController: UIViewController, TaskListViewProtocol {
    
    private var completedTasks: [Task] = []
    var presenter: CompletedTaskListPresenterProtocol?
    let completedTaskListTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }

    private func setupNavigationBar() {
        title = "Completas"
    }
    
    private func setupTableView() {
        completedTaskListTableView.dataSource = self
        completedTaskListTableView.delegate = self
        completedTaskListTableView.rowHeight = UITableView.automaticDimension
        completedTaskListTableView.estimatedRowHeight = 120
        completedTaskListTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    
    func showTasks(_ tasks: [Task]) {
        completedTasks = tasks
        completedTaskListTableView.reloadData()
    }
}

extension CompletedTasksViewController: UITableViewDelegate { }

extension CompletedTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let reversedIndex = (completedTasks.count - 1) - indexPath.row
        let task = completedTasks[reversedIndex]
        cell.configure(with: task, canBeSelected: false)
        return cell
    }
}

extension CompletedTasksViewController: ViewCoding {
    func setupHierarchy() {
        view.addSubview(completedTaskListTableView)
    }
    
    func setupConstraints() {
        completedTaskListTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func setupAdditionalConfiguration() {
        completedTaskListTableView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
    }
}
