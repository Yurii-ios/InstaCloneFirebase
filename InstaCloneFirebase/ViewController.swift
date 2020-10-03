//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Yurii Sameliuk on 10/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // 4tobu priloženije zapominalo logirowaniwe poslednego polzowatelia w SceneDelegate nyžno dobawit kod.
        // SMOTRI SceneDelegate!!
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
       
        if passwordtextField.text != "" && emailTextField.text != "" {
            // logirawanie yže zaregistrirowanogo polzowatelia
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordtextField.text!) { (authData, error) in
                
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(title: "Error", message: "Username/Password?", preferredStyle: UIAlertController.Style.alert)
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        // proweriaem ne pystaja li stroka s emejlom i parolem
        if emailTextField.text != "" && passwordtextField.text != "" {
            // sozdanie auntentifikacii nowogo polzowatelia
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordtextField.text!) { (authData, error) in
                
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error", preferredStyle: UIAlertController.Style.alert)
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            makeAlert(title: "Error", message: "Username/Password?", preferredStyle: UIAlertController.Style.alert)
            
        }
    }
    
    func makeAlert(title: String, message: String, preferredStyle: UIAlertController.Style ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}



