//
//  Checklist.swift
//  OpenChecklist
//
//  Created by Johan Oskarsson on 9/15/25.
//

import Foundation
import SwiftData

enum ChecklistType: String, CaseIterable, Codable {
    case todo = "todo"
    case persistent = "persistent"

    var displayName: String {
        switch self {
        case .todo:
            return "Todo List"
        case .persistent:
            return "Checklist"
        }
    }

    var description: String {
        switch self {
        case .todo:
            return "Items disappear when checked off"
        case .persistent:
            return "Items remain but show as checked"
        }
    }
}

@Model
final class Checklist {
    var name: String = ""
    var checklistType: ChecklistType = ChecklistType.todo
    var createdAt: Date = Date()
    @Relationship(deleteRule: .cascade) var items: [ChecklistItem]? = []

    init(name: String, type: ChecklistType) {
        self.name = name
        self.checklistType = type
        self.createdAt = Date()
        self.items = []
    }
}
