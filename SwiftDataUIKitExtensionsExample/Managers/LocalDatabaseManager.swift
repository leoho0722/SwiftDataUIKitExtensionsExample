//
//  LocalDatabaseManager.swift
//  SwiftDataUIKitExtensionsExample
//
//  Created by Leo Ho on 2023/12/17.
//

import Foundation
import SwiftData

protocol LocalDatabaseCRUD {
    
    associatedtype Model
    
    func create(with object: Model)
    
    func read(finish: @escaping (Result<[Model], Error>) -> Void)
    
    func update(from oldObject: Model, updateTo newObject: Model)
    
    func delete(with object: Model)
}

final class LocalDatabaseManager {
    
    static let shared = LocalDatabaseManager()
    
    private var context: ModelContext?
    private var container: ModelContainer?
    
    var modelDidChangeListener: (() -> Void)? = nil
    
    init() {
        do {
            container = try ModelContainer(for: Todo.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            fatalError("Can't initialize LocalDatabaseManager Object because occurs error. Error: \(error)")
        }
    }
}

extension LocalDatabaseManager: LocalDatabaseCRUD {
    
    func create(with object: Todo) {
        if let context {
            let objectToBeSaved = Todo(taskName: object.taskName, time: object.time)
            context.insert(objectToBeSaved)
            
            if let modelDidChangeListener {
                modelDidChangeListener()
            }
        }
    }
    
    func read(finish: @escaping (Result<[Todo], Error>) -> Void) {
        let descriptor = FetchDescriptor<Todo>()
        if let context {
            do {
                let objects = try context.fetch(descriptor)
                finish(.success(objects))
            } catch {
                finish(.failure(error))
            }
        }
    }
    
    func update(from oldObject: Todo, updateTo newObject: Todo) {
        var objectToBeUpdated = oldObject
        objectToBeUpdated = newObject
        
        if let modelDidChangeListener {
            modelDidChangeListener()
        }
    }
    
    func delete(with object: Todo) {
        let objectToBeDeleted = object
        if let context {
            context.delete(objectToBeDeleted)
            
            if let modelDidChangeListener {
                modelDidChangeListener()
            }
        }
    }
}
