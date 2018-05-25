//
//  FavoriteNewsTableViewController.swift
//  RSS Reader
//
//  Created by Tim Song on 2018/5/23.
//  Copyright © 2018 Tim Song. All rights reserved.
//

import UIKit
import CoreData

class FavoriteNewsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Feed>!
    lazy var dateFormatter: DateFormatter = {
        var tempFormatter = DateFormatter()
        tempFormatter.dateStyle = .short
        tempFormatter.timeStyle = .short
        return tempFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let feedsFetchReqeust: NSFetchRequest<Feed> = Feed.fetchRequest()
        feedsFetchReqeust.sortDescriptors = [NSSortDescriptor(key: "saveDate", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: feedsFetchReqeust, managedObjectContext: DataController.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Can not fetch saved feeds with error thrown: \(error)")
        }
    }

    // MARK: Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteFeedCell")! as! RSSTableViewCell
        let feed = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = feed.title
        cell.descriptionLabel.text = feed.feedDescription
        cell.publishDateLabel.text = dateFormatter.string(from: feed.saveDate!)
        return cell
    }
    
    // MARK: Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = fetchedResultsController.object(at: indexPath)
        if let feedWebViewController =  self.storyboard?.instantiateViewController(withIdentifier: "FeedWebViewController") as? FeedViewController {
            // Dependency injection
            feedWebViewController.feedMO = feed
            self.navigationController?.pushViewController(feedWebViewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            fetchedResultsController.managedObjectContext.delete(fetchedResultsController.object(at: indexPath))
            do {
                try fetchedResultsController.managedObjectContext.save()
            }catch{
                print("save object deletion with error: \(error.localizedDescription)")
            }
        case .insert:
            fatalError("No implementation for insertion yet")
            break
        case .none:
            break
        }
    }
    
    // MARK: Fetched results controller delegate methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            fatalError("monitoring for change other than deletion or insertion is not implemented yet")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
