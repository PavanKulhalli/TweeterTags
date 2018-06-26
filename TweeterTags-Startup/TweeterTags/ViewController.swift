//
//  ViewController.swift
//  TweeterTags
//
//  Created by COMP47390-41550 on 21/01/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let request = TwitterRequest(search: "#UCD", count: 8)
        request.fetchTweets { (tweets) -> Void in
            DispatchQueue.main.async { () -> Void in
                for tweet in tweets {
                    print(tweet.text)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

