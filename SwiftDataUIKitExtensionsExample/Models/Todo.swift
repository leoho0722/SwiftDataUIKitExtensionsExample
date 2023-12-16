//
//  Todo.swift
//  SwiftDataUIKitExtensionsExample
//
//  Created by Leo Ho on 2023/12/17.
//

import Foundation
import SwiftData

@Model
class Todo {
    
    @Attribute(.unique)
    var id: String = UUID().uuidString
    
    var taskName: String
    
    var time: Double
    
    init(taskName: String, time: Double) {
        self.taskName = taskName
        self.time = time
    }
}
