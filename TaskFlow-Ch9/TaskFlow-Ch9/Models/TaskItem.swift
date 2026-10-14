//
//  TaskItem.swift
//  TaskFlow-Ch9
//
//  Created by Andres de la Cruz on 9/30/26.
//

import Foundation

struct TaskItem: Identifiable, Equatable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
    var isFavorite: Bool = false
    var priority: Priority = .medium
    var dueDate: Date? = nil
}

enum Priority: String, CaseIterable {
    case low, medium, high

    // texto pa la etiqueta (low -> Low)
    var title: String { rawValue.capitalized }
}
