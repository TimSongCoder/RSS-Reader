//
//  FeedViewController.swift
//  RSS Reader
//
//  Created by Tim Song on 2018/5/23.
//  Copyright © 2018 Tim Song. All rights reserved.
//

import UIKit
import WebKit

class FeedViewController: UIViewController, WKNavigationDelegate {

    var feed: [String: String]!
    var feedMO: Feed!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if feedMO != nil {
            feed = [String: String]()
            feed[RSSElement.link.rawValue] =  feedMO.link
            feed[RSSElement.title.rawValue] = feedMO.title
            feed[RSSElement.description.rawValue] = feedMO.feedDescription
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(saveNews))
        }
        webView.navigationDelegate = self
        if let feedURLString = feed[RSSElement.link.rawValue], let feedURL = URL(string: feedURLString) {
            webView.load(URLRequest(url: feedURL))
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        self.title = "News Detail"
    }

    @objc func saveNews() {
        print("saveNews")
        let persistentContext = DataController.persistentContainer.viewContext
        let newFeedMO = Feed(context: persistentContext)
        newFeedMO.title = feed[RSSElement.title.rawValue]
        newFeedMO.link = feed[RSSElement.link.rawValue]
        newFeedMO.feedDescription = feed[RSSElement.description.rawValue]
        newFeedMO.saveDate = Date()
        do {
            try persistentContext.save()
            // TODO: Animate the action
            
        } catch {
            print("can not save feed with error: \(error.localizedDescription)")
        }

    }
    
    // MARK: WebView Navigation Delegate
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // Called when the web view begins to receive web content
        print("didCommit navigation")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Called when web content begins to load in a web view
        print("didStartProvisionalNavigation navigation")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // Called when a web view receives a server redirect
        print("didReceiveServerRedirectForProvisionalNavigation navigation")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Called when the web view needs to respond to an authentication challenge.
        print("didReceive challenge:")
        completionHandler(.performDefaultHandling, nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Called when an error occurs during navigation
        print("didFail navigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // Called when an error occurs while the web view is loading content
        print("didFailProvisionalNavigation navigation")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Called when the navigation is complete
        print("didFinish navigation")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        // Called when the web view's web content process is terminated, does not related to a specific navigation/webpage
        print("webViewWebContentProcessDidTerminate")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Decides whether to allow or cancel a navigation
        print("decidePolicyFor navigationAction: \(navigationAction.request.url?.absoluteString ?? "URL: N/A")")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // Decides whether to allow or cancel a navigation after its response is known
        print("decidePolicyFor navigationResponse: \(navigationResponse.canShowMIMEType)")
        decisionHandler(.allow)
    }
}
