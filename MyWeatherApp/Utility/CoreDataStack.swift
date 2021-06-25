//
//  CoreDataStack.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 25/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    static let name = "MyWeatherApp"
    static let shared = CoreDataStack(modelName: CoreDataStack.name)
    
    private let modelName: String
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    func fetch() -> [Favorites] {
        return Favorites.fetchOne(from: mainContext)
    }
    
    @discardableResult
    func insert(name: String) -> Bool {
        return Favorites.insert(into: mainContext, name: name)
    }
}

extension CoreDataStack {
    static func createContainer(_ completion: @escaping (NSPersistentContainer) -> ()) {
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        
        let container = NSPersistentContainer(name: CoreDataStack.name)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            guard error == nil else { fatalError("Failed to load store: \(error!)") }
            
            DispatchQueue.main.async {
                completion(container)
            }
        }
    }
    
    func saveContext () {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String {get}
    static var defaultSortDescriptors: [NSSortDescriptor] {get}
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name ?? ""
    }
}
