//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Yurii Sameliuk on 11/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   // izwlekaem dannue iz Cloud Firestore DATABASE
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
        tableView.reloadData()
        
    }
    
    // ystanawliwaem listnera dlia poly4enija izmenenij w baze dannux 4tobu obnowit dannue w priloženii
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
        // esli w kode mu poly4aem oshubky wremeni Timestamp , to wozmožno nam nyžno primenit eti ystarewshue nastrojki wremeni.
        //        let settings = fireStoreDatabase.settings
        //        settings.areTimestampsInSnapshotsEnabled = true
        //        fireStoreDatabase.settings = settings
        // dobawlenie samogo listnera        // sortirowka po date dobawlenija
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: .alert)
                
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    //o4is4aem soderžumoe masiwowo
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // podklu4aem Prototype Cell k tableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath ) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        //sd_setImage(with: , completed: ) - ispolzyem frejmwork dlia zagryzki izobrajenij iz DataBase WAŽNO! - izobraženie w Main dolžno imet fiksirowanue razmeru , ina4e ono ne bydet wuwedeno na ViewController
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.hidenLabel.text = documentIdArray[indexPath.row]

        return cell
    }
    
    func makeAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
