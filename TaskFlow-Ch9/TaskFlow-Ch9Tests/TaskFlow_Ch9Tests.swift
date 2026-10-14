//
//  TaskFlow_Ch9Tests.swift
//  TaskFlow-Ch9Tests
//
//  Created by Andres de la Cruz on 9/30/26.
//

import XCTest
@testable import TaskFlow_Ch9

final class TaskFlow_Ch9Tests: XCTestCase {

    var viewModel: TaskListViewModel!
    
    override func setUpWithError() throws {
        viewModel = TaskListViewModel()
    }
    
    /// Test #1 - Add task
    func test_addTask_increasesTaskCount() {
        // Arrange
       
        // Act
        viewModel.addTask(title: "Buy groceries")
        
        // Assert
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Buy groceries")
    }

    /// Test #2 - Remove a task
    func test_removeTask_removesCorrectItem() {
        // Arrange
        viewModel.addTask(title: "Task A")
        viewModel.addTask(title: "Task B")
        
        // Act
        viewModel.removeTask(at: 0)
        
        // Assert
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Task B")
    }
    
    /// Test #3 - Toggle Completion
    func test_toggleCompletion_flipsIsCompleted() {
        // Arrange
        viewModel.addTask(title: "Task A")
        let taskId = viewModel.tasks[0].id
        XCTAssertFalse(viewModel.tasks[0].isCompleted)
        
        // Act
        viewModel.toggleCompletion(id: taskId)
        
        // Assert
        XCTAssertTrue(viewModel.tasks[0].isCompleted)
    }
    
    /// Test #4 - Empty title
    func test_addTask_withEmptyTitle_isIgnored() {
        let initialCount = viewModel.tasks.count
        viewModel.addTask(title: "     ")
        XCTAssertEqual(viewModel.tasks.count, initialCount, "A blank title should not create a task")
    }
    
    /// Test #5 - Insertion is order is preserved
    func test_addTask_multipleTask_mantainsInsertionOrder() {
        viewModel.addTask(title: "Task A")
        viewModel.addTask(title: "Task B")
        viewModel.addTask(title: "Task C")
        
        XCTAssertEqual(viewModel.tasks[0].title, "Task A")
        XCTAssertEqual(viewModel.tasks[2].title, "Task C")
    }
    
    /// Test #6 - Toggle twice return to original state
    func test_toggleCompletion_calledTwice_returnToIncompleted() {
        viewModel.addTask(title: "Task A")
        let taskId = viewModel.tasks[0].id
        
        viewModel.toggleCompletion(id: taskId)
        viewModel.toggleCompletion(id: taskId)
        
        XCTAssertFalse(viewModel.tasks[0].isCompleted)
    }
    
    /// Test #7 - New viewModel starts empty
    func test_newViewModel_startWithEmptyTask() {
        XCTAssertTrue(viewModel.tasks.isEmpty)
    }
    
    // MARK: Class #2 TDD
    
    /// Test #8 - Default Priority
    func test_addTask_defaultPriorityIsMedium() {
        viewModel.addTask(title: "Task A")
        XCTAssertEqual(viewModel.tasks[0].priority, .medium)
    }
 
    /// Test #9 - High Priority
    func test_addTask_withHighPriority_storesPriority() {
        viewModel.addTask(title: "Urgent", priority: .high)
        XCTAssertEqual(viewModel.tasks[0].priority, .high)
    }
    
    /// Test #10 - Filter Priority - Create a filter, multiple task with same priority
    /// Arrange: Add low + high + high / Assert: task(for high).count == 2
    func test_tasks_forPriority_returnsOnlyMatchingTasks() {
        // Arrange - Act
        viewModel.addTask(title: "Low", priority: .low)
        viewModel.addTask(title: "High 1", priority: .high)
        viewModel.addTask(title: "High 2", priority: .high)
        
        // Assert
        XCTAssertEqual(viewModel.tasks(for: .high).count, 2)
        XCTAssert(viewModel.tasks(for: .high).allSatisfy { $0.priority == .high })
    }
    
    /// Test #11 - Sort Priority
    func test_taskSortedByPriority_returnsHighFirst() {
        // Arrange
        viewModel.addTask(title: "Low", priority: .low)
        viewModel.addTask(title: "Medium", priority: .medium)
        viewModel.addTask(title: "High 2", priority: .high)
        
        // Act
        let sorted = viewModel.tasksSortedByPriority
        
        // Assert
        XCTAssertEqual(sorted[0].priority, .high)
        XCTAssertEqual(sorted[1].priority, .medium)
        XCTAssertEqual(sorted[2].priority, .low)
    }
    
    /// Test #12 - Test default is favorite false
    func test_addTask_defaultFavoriteFalse() {
        // Act
        viewModel.addTask(title: "Task A", priority: .medium)
        
        // Assert
        XCTAssertFalse(viewModel.tasks[0].isFavorite)
    }
    
    /// Test #13 - ToggleFavorite sets true / (id: UUID) - pass as paremeter, create index
    func test_toggleFavorite_setsIsFavoriteTrue() {
        // Arrange
        viewModel.addTask(title: "Task A", priority: .medium)
        let id = viewModel.tasks[0].id
        
        // Act
        viewModel.toggleFavorite(id: id)
        
        // Assert
        XCTAssertTrue(viewModel.tasks[0].isFavorite)
    }
    
    /// Test #14 - Toggle twice returns to false
    func test_toggleFavorite_setsIsFavoriteFalse() {
        // Arrange
        viewModel.addTask(title: "Task A", priority: .medium)
        let id = viewModel.tasks[0].id
        
        // Act
        viewModel.toggleFavorite(id: id)
        viewModel.toggleFavorite(id: id)
        
        // Assert
        XCTAssertFalse(viewModel.tasks[0].isFavorite)
    }
    
    /// Test #15 - Favorite tasks filters correctly
    func test_favoriteTasks_returnsOnlyFavorites() {
        // Arrange
        viewModel.addTask(title: "Task A", priority: .medium)
        viewModel.addTask(title: "Task B", priority: .medium)
        let starredId = viewModel.tasks[1].id
    
        // Act
        viewModel.toggleFavorite(id: starredId)
        
        // Assert
        XCTAssertEqual(viewModel.favoriteTasks.count, 1)
        XCTAssertEqual(viewModel.favoriteTasks.first?.title, "Task B")
    }
    
    
    // MARK: Class #3 Stubs - Mocks - DI
    
    /// Test #16 - Stub
    func test_loadTasks_returnsStubbedTasks() {
        // Arrange
        let viewModel = TaskListViewModel(service: StubTaskService())
        
        // Act
        viewModel.loadTasks()
        
        // Assert
        XCTAssertEqual(viewModel.tasks.count, 3)
     }
    
    /// Test  #17 - Stub with custom array
    func test_loadTasks_withCustomStubbedData_returnsThatData() {
        let customTasks = [TaskItem(title: "Only one task", priority: .high)]
        let viewModel = TaskListViewModel(service: StubTaskService(stubbedTasks: customTasks))
        
        viewModel.loadTasks()
        
        XCTAssertEqual(viewModel.tasks.first?.title, "Only one task")
    }
    
    /// Test #18 - Mocks
    func test_removeTask_callsServiceDeleteExactlyOne() {
        let mockService = MockTaskService(tasksToReturn: [TaskItem(title: "Sample", priority: .medium)])
        let viewModel = TaskListViewModel(service: mockService)
        
        viewModel.loadTasks()
        viewModel.removeTask(at: 0)
        
        XCTAssertEqual(mockService.deleteCallCount, 1)
    }
    
    /// Test #19 - Test Notifications Scheduling Protocol
    func test_addTask_withDueDate_schedulesReminderExactlyOnce() {
        let mockScheduler = MockNotificationScheduler()
        let viewModel = TaskListViewModel(notificationScheduler: mockScheduler)
        
        viewModel.addTask(title: "Submit report", dueDate: Date().addingTimeInterval(3600))
        
        XCTAssertEqual(mockScheduler.scheduleCallCount, 1)
    }

    // MARK: Assignment 1 - Unit Test

    /// Assignment 1 - Unit test: agregar una tarea
    func testAddingTask() {
        let taskManager = TaskListViewModel()
        taskManager.addTask(title: "Buy Groceries")
        XCTAssertEqual(taskManager.tasks.count, 1)
        XCTAssertEqual(taskManager.tasks[0].title, "Buy Groceries")
    }

    // MARK: Assignment 2 - TDD Priority

    /// test del assignment, adaptado a TaskItem
    func testTaskHasPriority() {
        var task = TaskItem(title: "Complete Homework")
        task.priority = .high
        XCTAssertEqual(task.priority, .high)
    }

    /// cambiarle la prioridad a una tarea que ya existe
    func test_setPriority_changesTaskPriority() {
        viewModel.addTask(title: "Complete Homework")
        let id = viewModel.tasks[0].id

        viewModel.setPriority(id: id, to: .high)

        XCTAssertEqual(viewModel.tasks[0].priority, .high)
    }

    /// si el id no existe no truena ni cambia nada
    func test_setPriority_withUnknownId_doesNothing() {
        viewModel.addTask(title: "Task A", priority: .low)

        viewModel.setPriority(id: UUID(), to: .high)

        XCTAssertEqual(viewModel.tasks[0].priority, .low)
    }

    /// el texto que sale en la etiqueta de la UI
    func test_priority_title() {
        XCTAssertEqual(Priority.high.title, "High")
        XCTAssertEqual(Priority.medium.title, "Medium")
        XCTAssertEqual(Priority.low.title, "Low")
    }
}
