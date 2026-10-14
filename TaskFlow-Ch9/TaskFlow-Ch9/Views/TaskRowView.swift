//
//  TaskRowView.swift
//  TaskFlow-Ch9
//

import SwiftUI

// refactor: la fila de cada tarea en su propia vista
struct TaskRowView: View {
    let task: TaskItem
    let onComplete: () -> Void

    var body: some View {
        HStack {
            Text(task.title)
            Spacer()
            PriorityLabel(priority: task.priority)
            Button(action: onComplete) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Complete")
            .accessibilityAddTraits(task.isCompleted ? .isSelected : [])
        }
    }
}

// etiqueta de color con la prioridad
struct PriorityLabel: View {
    let priority: Priority

    var body: some View {
        Text(priority.title)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(priority.color.opacity(0.2))
            .clipShape(Capsule())
    }
}

extension Priority {
    // color segun la prioridad
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

#Preview {
    List {
        TaskRowView(task: TaskItem(title: "Study for exam", priority: .high)) { }
        TaskRowView(task: TaskItem(title: "Buy Groceries", isCompleted: true, priority: .low)) { }
    }
}
