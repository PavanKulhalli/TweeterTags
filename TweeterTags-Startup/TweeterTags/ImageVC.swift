//
//  ImageVC.swift
//  TweeterTags
//
//  Created by Pavan Kulhalli on 11/03/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class ImageVC: UIViewController,UIScrollViewDelegate {
    var tweetImageURL:URL? = nil { didSet { } };
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var tweetImageActivityIndicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return tweetImageView
    }
    
    private func updateUI()
    {
        /*
        let data = try? Data(contentsOf: tweetImageURL!)
        if let imageData = data {
            tweetImageView.image = UIImage(data: imageData)
        }
        */
        tweetImageActivityIndicatorView.startAnimating()
        tweetImageView.downloadImage(from: ((tweetImageURL)?.absoluteString)!) { (err) in
            if err != nil {
                // error handler
            }
            self.tweetImageActivityIndicatorView.stopAnimating()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
