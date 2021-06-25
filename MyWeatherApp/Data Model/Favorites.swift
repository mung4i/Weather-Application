//
//  Favorites.swift
//  MyWeatherApp
//
//  Created by Martin Mungai on 25/06/2021.
//  Copyright © 2021 Martin Mungai. All rights reserved.
//

import Foundation
import CoreData

public class Favorites: NSManagedObject, Managed {
    @NSManaged public var name: String?

    static func fetchOne(from context: NSManagedObjectContext) -> [Favorites] {
        let request = Favorites.sortedFavoritesFetchRequest
        return try! context.fetch(request)
    }
    
    static func insert(into context: NSManagedObjectContext, name: String) -> Bool {
        let favorite = NSEntityDescription.insertNewObject(forEntityName: Favorites.entityName, into: context) as! Favorites
        favorite.name = name
        
        return favorite.save()
    }
    
    static var sortedFavoritesFetchRequest: NSFetchRequest<Favorites> {
        let request = NSFetchRequest<Favorites>(entityName: Favorites.entityName)
        request.sortDescriptors = defaultSortDescriptors
        
        return request
    }
    
    private func save() -> Bool {
        guard let context = managedObjectContext else { return false }
        do {
            try context.save()
        } catch {
            NSLog("*** Error saving Token: \(error)")
            return false
        }
        return true
    }
}
