//
//  ViewController.swift
//  RSS Reader
//
//  Created by Tim Song on 2018/4/28.
//  Copyright © 2018 Tim Song. All rights reserved.
//

import UIKit

class RSSTableViewController: UITableViewController, XMLParserDelegate {

    var items = [[String: String]]()
    var temporaryItem = [String: String]()
    var temporaryItemTitle = ""
    var temporaryItemDescription = ""
    var temporaryItemLink = ""
    var temporaryItemPubDate = ""
    var currentParsingElement: RSSElement = .unknown
    var isParsingItem = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Now: \(dateFormatter.string(from: Date())) using locale [\(dateFormatter.locale.identifier)] with current locale [\(Locale.current.identifier)]")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: "https://developer.apple.com/news/rss/news.rss"),
                let xmlParser = XMLParser(contentsOf: url) else {
                    print("Invalid rss feed")
                    return
            }
            xmlParser.delegate = self
            xmlParser.parse()
        }
    }

    // MARK: XML Parser Delegates
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        guard let element = RSSElement(rawValue: elementName) else {
            return
        }
        currentParsingElement = element
        
        switch currentParsingElement {
        case .item:
            temporaryItem.removeAll()
        case .title:
            temporaryItemTitle = ""
        case .description:
            temporaryItemDescription = ""
        case .link:
            temporaryItemLink = ""
        case .pubDate:
            temporaryItemPubDate = ""
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentParsingElement {
        case .item:
            break
        case .title:
            temporaryItemTitle.append(string)
        case .description:
            temporaryItemDescription.append(string)
        case .link:
            temporaryItemLink.append(string)
        case .pubDate:
            temporaryItemPubDate.append(string)
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let element = RSSElement(rawValue: elementName) else {
            return
        }
        switch element {
        case .item:
            temporaryItem[RSSElement.title.rawValue] = String(temporaryItemTitle[temporaryItemTitle.startIndex ..< temporaryItemTitle.index(of: "\n")!])
            temporaryItem[RSSElement.description.rawValue] = temporaryItemDescription
            temporaryItem[RSSElement.link.rawValue] = String(temporaryItemLink[temporaryItemLink.startIndex ..< temporaryItemLink.index(of: "\n")!])
            temporaryItem[RSSElement.pubDate.rawValue] = String(temporaryItemPubDate[temporaryItemPubDate.startIndex ..< temporaryItemPubDate.index(of: "\n")!])
            items.append(temporaryItem)
        case .title, .description, .link, .pubDate:
            break;
        default:
            break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        // Parsing finished.
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        print(items.count)
    }
    
    // MARK: Table delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSItemCell")! as! RSSTableViewCell
        let itemForRow = items[indexPath.row]
        cell.titleLabel.text = itemForRow[RSSElement.title.rawValue]
        cell.publishDateLabel.text = Formatters.userCurrentDateFormatter.string(from: Formatters.rssDateFormatter.date(from: itemForRow[RSSElement.pubDate.rawValue]!)!)
        cell.descriptionLabel.text = itemForRow[RSSElement.description.rawValue]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = items[indexPath.row]
        if let feedWebViewController =  self.storyboard?.instantiateViewController(withIdentifier: "FeedWebViewController") as? FeedViewController {
            // Dependency injection
            feedWebViewController.feed = feedItem
            self.navigationController?.pushViewController(feedWebViewController, animated: true)
        }
    }
}

