//
//  DataController.swift
//  RSS Reader
//
//  Created by Tim Song on 2018/5/23.
//  Copyright © 2018 Tim Song. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Feeds")
        container.loadPersistentStores(completionHandler: {(storeDesc, error) in
            if error != nil {
                print("load data store with error: \(error!.localizedDescription)")
            }
            
        })
        return container
    }()
    
    static func performMigrationIfNecessary() {
        guard let sourceModelURL = Bundle.main.url(forResource: "Feeds", withExtension: "momd") else {
            print("Did not find old version of managed object model")
            return
        }
        guard let destinationModelURL = Bundle.main.url(forResource: "Feeds+2+Add+PubDate", withExtension: "momd") else {
            print("Did not find new version of managed object model: \(Bundle.main.path(forResource: "Feeds 2 Add PubDate", ofType: "xcdatamodel") ?? "N/A")")
            return
        }
        guard let sourceMom = NSManagedObjectModel(contentsOf: sourceModelURL),
            let destinationMom = NSManagedObjectModel(contentsOf: destinationModelURL) else {
                fatalError("Can not create managed object model from specified source files")
        }
        do {
            try NSMappingModel.inferredMappingModel(forSourceModel:  sourceMom, destinationModel: destinationMom)
            try persistentContainer.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: nil, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
            print("Performing lightweight data migration")
        } catch {
            print("Inferred mapping model failed with error: \(error.localizedDescription)")
        }
    }
}
