//
//  ContentView.swift
//  TaskFlow-Ch9
//
//  Created by Andres de la Cruz on 9/30/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskListViewModel()
    @State private var newTaskTitle: String = ""
    @State private var newTaskPriority: Priority = .medium

    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    TextField("New task...", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("Add Task")
                    Button("Add") {
                        viewModel.addTask(title: newTaskTitle, priority: newTaskPriority)
                        newTaskTitle = ""
                    }
                    .accessibilityIdentifier("add_task_button")
                    // si esta vacio no deja agregar
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                .padding(.top)

                // elegir prioridad antes de agregar
                Picker("Priority", selection: $newTaskPriority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.title).tag(priority)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityIdentifier("priority_picker")
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.tasks) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleCompletion(id: task.id)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggleCompletion(id: task.id)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { viewModel.removeTask(at: $0) }
                    }
                }
                
                Text("Completed: \(viewModel.completedCount)/\(viewModel.tasks.count)")
                    .font(.footnote)
                    .padding(.bottom)
            }
            .navigationTitle("TaskFlow")
        }
    }
}

#Preview {
    ContentView()
}
