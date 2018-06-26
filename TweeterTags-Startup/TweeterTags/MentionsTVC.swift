//
//  MentionsTVC.swift
//  TweeterTags
//
//  Created by Pavan Kulhalli on 11/03/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class imageTVCell: UITableViewCell {
    
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var tweetImageActivityIndicatorView: UIActivityIndicatorView!
    
}


class MentionsTVC: UITableViewController {
    
    var tweet = [TwitterTweet](){ didSet { updateUI() } }
    
    private struct Identifiers {
        static let mentionsCell: String = "Mentions Cell"
        static let imageCell: String = "Image Cell"
        static let unwindToTweetsTVC : String = "unwindToTweetsTVC"
    }
    
    enum StoryboardIdentifiers: String {
        case tweetImageDetail = "tweetImageDetail"
        //        case unwindToTweetsTVC = "unwindToTweetsTVC"
        
        init?(_ segue: UIStoryboardSegue) {
            self.init(rawValue: segue.identifier!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUI()
    {
        title = tweet[0].user.name
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rowsInSection:Int = 0
        if section == 0 {
            rowsInSection = tweet[0].media.count
        } else if section == 1 {
            rowsInSection = tweet[0].hashtags.count
        } else if section == 2 {
            rowsInSection = tweet[0].userMentions.count
        } else if section == 3 {
            rowsInSection = tweet[0].urls.count
        }
        
        return rowsInSection
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleForHeaderInSection:String = ""
        if (section == 0) && (tweet[0].media.count > 0) {
            titleForHeaderInSection = "Images"
        } else if (section == 1) && (tweet[0].hashtags.count > 0) {
            titleForHeaderInSection = "Hashtags"
        } else if (section == 2) && (tweet[0].userMentions.count > 0) {
            titleForHeaderInSection = "Users"
        } else if (section == 3) && (tweet[0].urls.count > 0) {
            titleForHeaderInSection = "URLs"
        }
        return titleForHeaderInSection
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var heightForRow: CGFloat = 0
        if (indexPath.section == 0) {
            heightForRow = 250.0
        } else {
            heightForRow = 44.0
        }
        return heightForRow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        if indexPath.section == 0 {
            let dequeued = tableView.dequeueReusableCell(withIdentifier: Identifiers.imageCell, for: indexPath)
            let imageTVCell = dequeued as! imageTVCell
            /*
             let data = try? Data(contentsOf: tweet[0].media[indexPath.row].url)
             if let imageData = data {
             imageTVCell.tweetImageView.image = UIImage(data: imageData)
             }
             */
            imageTVCell.tweetImageActivityIndicatorView.startAnimating()
            imageTVCell.tweetImageView.downloadImage(from: (tweet[0].media[indexPath.row].url).absoluteString) { (err) in
                if err != nil {
                    // error handler
                }
                imageTVCell.tweetImageActivityIndicatorView.stopAnimating()
            }
            
            cell = imageTVCell
        } else {
            let dequeued = tableView.dequeueReusableCell(withIdentifier: Identifiers.mentionsCell, for: indexPath)
            cell = dequeued
            if indexPath.section == 1 {
                cell.textLabel?.text = tweet[0].hashtags[indexPath.row].keyword
            } else if indexPath.section == 2 {
                cell.textLabel?.text = tweet[0].userMentions[indexPath.row].keyword
            } else if indexPath.section == 3 {
                cell.textLabel?.text = tweet[0].urls[indexPath.row].keyword
            }
        }
        
        // Configure the cell...
        
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            
        } else if indexPath.section == 3 {
            if let url = URL(string: tweet[0].urls[indexPath.row].keyword) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                                                print("Open: \(success)")
                    })
                } else {
                    let success = UIApplication.shared.openURL(url)
                    print("Open: \(success)")
                }
            }
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination
        if let navigationVC = destinationVC as? UINavigationController {
            destinationVC = navigationVC.visibleViewController!
        }
        
        if tableView.indexPathForSelectedRow?.section == 0 {
            
            switch StoryboardIdentifiers(segue)! {
            case .tweetImageDetail:
                if let imageVC = destinationVC as? ImageVC {
                    imageVC.title = tweet[0].user.name
                    imageVC.tweetImageURL = tweet[0].media[(tableView.indexPathForSelectedRow?.row)!].url
                }
            }
        } else {
            
            switch segue.identifier! {
            case Identifiers.unwindToTweetsTVC:
                let destinationVC = segue.destination as! TweetsTVC
                
                if tableView.indexPathForSelectedRow?.section == 1 {
                    destinationVC.twitterQueryText = tweet[0].hashtags[(tableView.indexPathForSelectedRow?.row)!].keyword
                } else if tableView.indexPathForSelectedRow?.section == 2 {
                    destinationVC.twitterQueryText = tweet[0].userMentions[(tableView.indexPathForSelectedRow?.row)!].keyword
                } else if tableView.indexPathForSelectedRow?.section == 3 {
                    
                }
                break
            default:
                break
            }
        }
    }
}


