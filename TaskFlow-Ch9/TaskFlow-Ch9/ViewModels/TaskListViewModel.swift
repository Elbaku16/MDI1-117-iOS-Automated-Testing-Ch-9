//
//  TaskListViewModel.swift
//  TaskFlow-Ch9
//
//  Created by Andres de la Cruz on 9/30/26.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    private let service: TaskServiceProtocol
    private let notificationScheduler: NotificationsSchedulingProtocol
    
    init(
        service: TaskServiceProtocol = TaskService(),
        notificationScheduler: NotificationsSchedulingProtocol = NotificationsScheduler()
    ){
        self.service = service
        self.notificationScheduler = notificationScheduler
    }
    
    // MARK: Class #3 Functions

    func loadTasks() {
        tasks = service.fetchTasks()
    }
    

    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else { return }
        let removedId = tasks[index].id
        tasks.remove(at: index)
        service.delete(id: removedId)
    }
    
    // MARK: Class #1 Functions
    /// Add task function
    func addTask(title: String, priority: Priority = .medium, dueDate: Date? = nil) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let task = TaskItem(title: trimmed, priority: priority, dueDate: dueDate)
        tasks.append(task)
        if dueDate != nil {
            notificationScheduler.scheduleReminder(for: task)
        }
    }
    
    /// Toggle completion function
    func toggleCompletion(id: UUID) {
        guard let index = index(of: id) else { return }
        tasks[index].isCompleted.toggle()
    }
    
    /// Completed count text
    var completedCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    // MARK: Class #2 TDD
    
    /// Filter tasks by priority
    func tasks(for priority: Priority) -> [TaskItem] {
        tasks.filter { $0.priority == priority }
    }
    
    /// Sorted task by priority
    var tasksSortedByPriority: [TaskItem] {
        let order: [Priority] = [.high, .medium, .low]
        
        return tasks.sorted {
            guard let i = order.firstIndex(of: $0.priority),
                  let j = order.firstIndex(of: $1.priority)
                    else { return false }
            return i < j
        }
    }
    
    // MARK: Assignment 2 - TDD Priority

    /// cambiar prioridad de una tarea
    func setPriority(id: UUID, to priority: Priority) {
        guard let index = index(of: id) else { return }
        tasks[index].priority = priority
    }

    /// Toggle favorite
    func toggleFavorite(id: UUID) {
        guard let index = index(of: id) else { return }
        tasks[index].isFavorite.toggle()
    }
    
    /// Favorite tasks filter
    var favoriteTasks: [TaskItem] {
        tasks.filter { $0.isFavorite }
    }

    // refactor: buscar la tarea por id en un solo lugar
    private func index(of id: UUID) -> Int? {
        tasks.firstIndex(where: { $0.id == id })
    }
    
}
