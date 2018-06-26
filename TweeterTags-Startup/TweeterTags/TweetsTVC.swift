//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by Pavan Kulhalli on 03/03/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class TweetsTVC: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var twitterQueryTextField: UITextField!
    private let defaults = UserDefaults.standard
    var tweets = [[TwitterTweet]]()
    var twitterQueryText:String? = "#ucd" {
        didSet {
            self.tweets.removeAll()
            indexPathOfLastSelectedRow = nil
            twitterQueryTextField.text = twitterQueryText
            
            var savedTwitterQueryArray = defaults.stringArray(forKey: "SavedTwitterQueryArray") ?? [String]()
            if !savedTwitterQueryArray.contains(twitterQueryText!) {
                savedTwitterQueryArray.append(twitterQueryText!)
            }
            defaults.set(savedTwitterQueryArray, forKey: "SavedTwitterQueryArray")
            defaults.synchronize()
            refresh()
        }
    }
    
    private struct Identifiers {
        static let tweetsCell: String = "Tweets Cell"
    }
    
    enum StoryboardIdentifiers: String {
        case tweetDetail = "tweetDetail"
        
        init?(_ segue: UIStoryboardSegue) {
            self.init(rawValue: segue.identifier!)
        }
    }
    
    var indexPathOfLastSelectedRow:IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        twitterQueryTextField.text = twitterQueryText
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (tweets.count > 0) {
            if indexPathOfLastSelectedRow != nil {
                tableView.scrollToRow(at: indexPathOfLastSelectedRow!, at: UITableViewScrollPosition.none, animated: true)
                indexPathOfLastSelectedRow = nil
            } else {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func refresh() {
        let request = TwitterRequest(search: twitterQueryText!, count: 8)
        request.fetchTweets { (tweets) -> Void in
            DispatchQueue.main.async { () -> Void in
                for tweet in tweets {
                    self.tweets.append([tweet])
                    //                    print(tweet.text)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets.count
    }
    
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //        return 200
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: Identifiers.tweetsCell, for: indexPath)
        let cell = dequeued as! TweetTVCell
        let tweetVar = tweets[indexPath.row] as [TwitterTweet]
        for tweet in tweetVar {
            print(tweet.text)
            cell.tweetScreenNameLabel.text = tweet.user.description
            
            
            let tweetTextAttributedString = NSMutableAttributedString(string: tweet.text)
            
            let mentions = tweet.userMentions
            for mention in mentions {
                tweetTextAttributedString.setColorForText(mention.keyword, with: UIColor.green)
            }
            
            let hastags = tweet.hashtags
            for hastag in hastags {
                tweetTextAttributedString.setColorForText(hastag.keyword, with: UIColor.blue)
            }
            
            let urls = tweet.urls
            for url in urls {
                tweetTextAttributedString.setColorForText(url.keyword, with: UIColor.red)
            }
            
            let mediaImage = tweet.media
            for image in mediaImage {
                print(image.url)
            }
            
            cell.tweetTextLabel.attributedText = tweetTextAttributedString
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            cell.tweetCreatedLabel.text  = formatter.string(from: tweet.created)
            /*
            let data = try? Data(contentsOf: tweet.user.profileImageURL!)
            if let imageData = data {
                cell.tweetAvatarImageView.image = UIImage(data: imageData)
            }
            */
            
            cell.tweetAvatarImageView.downloadImage(from: ((tweet.user.profileImageURL)?.absoluteString)!) { (err) in
                if err != nil {
                    // error handler
                }
            }
        }
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        twitterQueryText = textField.text
        return true
    }
    
    @IBAction func tableRefreshControllerCalled(_ sender: UIRefreshControl) {
        refresh()
        sender.endRefreshing()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination
        if let navigationVC = destinationVC as? UINavigationController {
            destinationVC = navigationVC.visibleViewController!
        }
        
        switch StoryboardIdentifiers(segue)! {
            
        case .tweetDetail:
            if let mentionsTVC = destinationVC as? MentionsTVC {
                let tweetVar = tweets[(tableView.indexPathForSelectedRow?.row)!] as [TwitterTweet]
                mentionsTVC.tweet = tweetVar
                indexPathOfLastSelectedRow = tableView.indexPathForSelectedRow!
            }
        }
    }
    
    @IBAction func unwindToTweetsTVC(segue: UIStoryboardSegue) {
        //self.performSegue(withIdentifier: "unwindToTweetsTVC", sender: self)
    }
    
}

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
    }
}

extension UIImageView {
    
    func downloadImage(from url : String, completion: ((_ errorMessage: String?) -> Void)?){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest){ (data,response,error) in
            
            if error != nil {
                completion?("error...")
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data:data!)
                completion?(nil)
            }
        }
        
        task.resume()
    }
}


