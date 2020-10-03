//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Yurii Sameliuk on 11/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         selectImage()
      progressView.progress = 0.5
    }
    
    func  selectImage() {
        // pozwoliaem polzowately wzaemodejstwowat s izobraženiem
        userImageView.isUserInteractionEnabled = true
        let imageTagRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage))
        userImageView.addGestureRecognizer(imageTagRecognizer)
        
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        // sozdaem ekzempliar chranilis4a dannux
        let storage = Storage.storage()
        let storageReference = storage.reference()
        // sozdaem folder w obla4nom xranilis4e
        let mediaFolder = storageReference.child("photo")//.child("video")
        // ykazuwaem silu sžatija image
        if let data = userImageView.image?.jpegData(compressionQuality: 0.5) {
            // sozdaem randomnue imena zagryžaemum foto.
            let randomID = UUID().uuidString
            let imageReference = mediaFolder.child("\(randomID).jpeg")
            // otprawliaem dannue w obla4noe chranilis4e
           let taskReference = imageReference.putData(data, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                    
                } else {
                    
                    imageReference.downloadURL { (url, error) in
                        
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            print(imageUrl!)
                            
                            // ADDING Cloud Firestore DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            // need for upload and download data from database
                            var firestoreReference: DocumentReference? = nil
                            // sozdaem clowar r nyjnumi nami zna4enijami, kotorue bydyt otobraženu w tablice bazu dannux
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentTextField.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            // create a new collection in cloud firestore Database
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                
                                if error != nil {
                                    
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: .alert)
                                } else {
                                    self.userImageView.image = UIImage(named: "select")
                                    self.commentTextField.text = " "
                                    // wozwras4aet s ekrana UploadVC na ekran pod indeksom 0 FeedVC
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                    
                }
            }
            // dodaem progressView dlia kontrolia zagruzki
            taskReference.observe(StorageTaskStatus.progress) { (snapshot) in
                guard let pctThere = snapshot.progress?.fractionCompleted else {return}
                print("You are \(pctThere) complete")
                //self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 8)
                self.progressView.progress = Float(pctThere)
            }
        }
        

        
    }
}

   
