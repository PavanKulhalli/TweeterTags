//
//  TweetTVCell.swift
//  TweeterTags
//
//  Created by Pavan Kulhalli on 11/03/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class TweetTVCell: UITableViewCell {
    
    @IBOutlet weak var tweetAvatarImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
