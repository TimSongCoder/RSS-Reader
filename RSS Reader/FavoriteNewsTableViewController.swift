//
//  FavoriteNewsTableViewController.swift
//  RSS Reader
//
//  Created by Tim Song on 2018/5/23.
//  Copyright © 2018 Tim Song. All rights reserved.
//

import UIKit
import CoreData

class FavoriteNewsTableViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController<Feed>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let feedsFetchReqeust: NSFetchRequest<Feed> = Feed.fetchRequest()
        feedsFetchReqeust.sortDescriptors = [NSSortDescriptor(key: "saveDate", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: feedsFetchReqeust, managedObjectContext: DataController.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Can not fetch saved feeds with error thrown: \(error)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteFeedCell")!
        let feed = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = feed.title
        cell.detailTextLabel?.text = feed.feedDescription
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = fetchedResultsController.object(at: indexPath)
        if let feedWebViewController =  self.storyboard?.instantiateViewController(withIdentifier: "FeedWebViewController") as? FeedViewController {
            // Dependency injection
            feedWebViewController.feedMO = feed
            self.navigationController?.pushViewController(feedWebViewController, animated: true)
        }
    }
}
