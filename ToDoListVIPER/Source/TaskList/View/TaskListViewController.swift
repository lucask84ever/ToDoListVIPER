//
//  TaskListViewController.swift
//  ToDoListVIPER
//
//  Created by Lucas on 18/04/25.
//

import SnapKit
import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    var view: TaskListViewProtocol? { get set }
    var interactor: TaskListInteractorInputProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapAddTask(with title: String)
}

final class TaskListViewController: UIViewController, TaskListViewProtocol {
    var presenter: TaskListPresenterProtocol?
    let taskListTableView = UITableView()
    private var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskListTableView.reloadData()
    }

    private func setupNavigationBar() {
        title = "Pending"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
    }

    @objc
    private func didTapAddButton() {
        alertWithTextField(title: "Nova Tarefa",
                           message: "Informe a nova tarefa",
                           placeholder: "Nova tarefa") { [weak self] task in
            if !task.isEmpty {
                self?.presenter?.didTapAddTask(with: task)
            }
        }
    }

    private func setupTableView() {
        taskListTableView.dataSource = self
        taskListTableView.delegate = self
        taskListTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
    }

    func showTasks(_ tasks: [Task]) {
        self.tasks = tasks
        taskListTableView.reloadData()
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(114)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let reversedIndex = (tasks.count - 1) - indexPath.row
        let task = tasks[reversedIndex]
        cell.configure(with: task)
        
        cell.checkboxTapped = { [weak self] in
            guard let self = self else { return }
            self.tasks[reversedIndex].isDone.toggle()
            self.presenter?.interactor?.coreDataRepository.toggleCompletion(for: self.tasks[reversedIndex])
            self.tasks = self.presenter?.interactor?.coreDataRepository.getPendingTasks() ?? []
            self.showTaskCompletedToast()
            self.taskListTableView.reloadData()
        }

        return cell
    }
}

extension TaskListViewController {
    public func alertWithTextField(title: String? = nil,
                                   message: String? = nil,
                                   placeholder: String? = nil,
                                   completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion("") })
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            if let textFields = alert.textFields,
               let tf = textFields.first,
               let result = tf.text {
                completion(result)
                
            } else {
                completion("")
            }
        })
        navigationController?.present(alert, animated: true)
    }
    
    private func showTaskCompletedToast() {
        let label = UILabel()
        label.text = "Task Done!"
        label.textAlignment = .center
        label.backgroundColor = .systemGreen
        label.textColor = .white
        label.alpha = 0
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(40)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            label.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.2, options: [], animations: {
                label.alpha = 0
            }) { _ in
                label.removeFromSuperview()
            }
        }
    }
}

extension TaskListViewController: ViewCoding {
    func setupHierarchy() {
        view.addSubview(taskListTableView)
    }
    
    func setupConstraints() {
        taskListTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func setupAdditionalConfiguration() {
        taskListTableView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
    }
}
