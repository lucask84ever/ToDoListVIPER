//
//  Task.swift
//  ToDoListVIPER
//
//  Created by Lucas on 18/04/25.
//

import Foundation

struct Task {
    let id: UUID
    let title: String
    var isDone: Bool
    let createdAt: Date
    var completedAt: Date?
}
