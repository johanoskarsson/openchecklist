//
//  ChecklistItem.swift
//  OpenChecklist
//
//  Created by Johan Oskarsson on 9/15/25.
//

import Foundation
import SwiftData

@Model
final class ChecklistItem {
    var text: String = ""
    var isCompleted: Bool = false
    var createdAt: Date = Date()
    var checklist: Checklist?

    init(text: String, checklist: Checklist? = nil) {
        self.text = text
        self.isCompleted = false
        self.createdAt = Date()
        self.checklist = checklist
    }
}