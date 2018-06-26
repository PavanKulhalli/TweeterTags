//
//  RecentsTVC.swift
//  TweeterTags
//
//  Created by Pavan Kulhalli on 12/03/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class RecentsTVC: UITableViewController {
    
    private let defaults = UserDefaults.standard
    var savedTwitterQueryArray = [""]
    
    private struct Identifiers {
        static let showTweetsTVC : String = "showTweetsTVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedTwitterQueryArray = (defaults.stringArray(forKey: "SavedTwitterQueryArray") ?? [String]()).reversed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        savedTwitterQueryArray = (defaults.stringArray(forKey: "SavedTwitterQueryArray") ?? [String]()).reversed()
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedTwitterQueryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recents Cell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = savedTwitterQueryArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 0
        if let navigationVC = tabBarController?.selectedViewController as? UINavigationController {
            navigationVC.popToRootViewController(animated: true)
            if let destinationVC = navigationVC.visibleViewController! as? TweetsTVC {
                destinationVC.twitterQueryText = savedTwitterQueryArray[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let barViewControllers = segue.destination as! UITabBarController
    //        let destinationViewController = barViewControllers.viewControllers?[0] as! TweetsTVC
    //        destinationViewController.twitterQueryText = savedTwitterQueryArray[(tableView.indexPathForSelectedRow?.row)!]
    //       }
    
}
