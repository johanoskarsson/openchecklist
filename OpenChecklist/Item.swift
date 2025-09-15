//
//  Item.swift
//  OpenChecklist
//
//  Created by Johan Oskarsson on 9/15/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
