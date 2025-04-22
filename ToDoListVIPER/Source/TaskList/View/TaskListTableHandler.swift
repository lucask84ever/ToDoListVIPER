//
//  TaskListTableHandler.swift
//  ToDoListVIPER
//
//  Created by Lucas on 18/04/25.
//

import Foundation
import UIKit

final class TaskListTableHandler: NSObject, UITableViewDelegate, UITableViewDataSource {
    var tasks: [Task] = []

    var didSelectTask: ((Task) -> Void)?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTask?(tasks[indexPath.row])
    }
}
