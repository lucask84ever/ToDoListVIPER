//
//  TaskEntity+Extension.swift
//  ToDoListVIPER
//
//  Created by Lucas on 21/04/25.
//

import Foundation

extension TaskEntity {
    func toModel() -> Task? {
        guard let id = self.id,
              let title = self.title,
              let createdAt = self.createdAt else { return nil }

        return Task(
            id: id,
            title: title,
            isDone: self.isDone,
            createdAt: createdAt,
            completedAt: self.completedAt
        )
    }
}
