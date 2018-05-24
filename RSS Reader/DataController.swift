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
}
