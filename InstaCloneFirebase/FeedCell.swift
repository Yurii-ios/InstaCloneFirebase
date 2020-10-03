//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Yurii Sameliuk on 14/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    // nyjna dlia realizacii ispolzowat sistemy lajkow
    @IBOutlet weak var hidenLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func likeButton(_ sender: UIButton) {
        
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) {
            // yweli4iwaem lajk na + 1. "likes" - eto nazwanie w baze dannux
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            // mu tolko obnowliaem dannue lajkow , ne izmeniaja drygix dannux w baze. ---WAŽNO! esli ne dodadim -  setData(likeStore, merge: true) to ydalim wse dannue w daze krome lajkow!!!!----
            fireStoreDatabase.collection("Posts").document(hidenLabel.text!).setData(likeStore, merge: true)
            
        }
        
        }
}
