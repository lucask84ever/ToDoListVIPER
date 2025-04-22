//
//  CoreDataTaskRepository.swift
//  ToDoListVIPER
//
//  Created by Lucas on 21/04/25.
//

import CoreData

final class CoreDataTaskRepository: TaskRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    private var observers = NSHashTable<AnyObject>.weakObjects()
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func tasksFromFetch(_ fetchRequest: NSFetchRequest<TaskEntity>) -> [Task] {
        let results = (try? context.fetch(fetchRequest)) ?? []
        return results.compactMap { $0.toModel() }
    }
    
    var tasks: [Task] {
        tasksFromFetch(TaskEntity.fetchRequest())
    }
    
    func getCompletedTasks() -> [Task] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isDone == true")
        request.sortDescriptors = [NSSortDescriptor(key: "completedAt", ascending: true)]
        return tasksFromFetch(request)
    }

    func getPendingTasks() -> [Task] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isDone == false")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return tasksFromFetch(request)
    }

    func add(_ task: Task) {
        let entity = TaskEntity(context: context)
        entity.id = task.id
        entity.title = task.title
        entity.isDone = task.isDone
        entity.createdAt = task.createdAt
        entity.completedAt = task.completedAt
        CoreDataStack.shared.saveContext()
    }

    func toggleCompletion(for task: Task) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        if let entity = (try? context.fetch(request))?.first {
            entity.isDone.toggle()
            entity.completedAt = entity.isDone ? Date() : nil
            CoreDataStack.shared.saveContext()
        }
    }
}
