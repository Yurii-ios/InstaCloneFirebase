//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Yurii Sameliuk on 11/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func logoutButton(_ sender: UIButton) {
        // wuchod polzoatelia z priloženija
        do {
        try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            let nserror = error as NSError
            fatalError("\(nserror), \(nserror.userInfo)")
        }
    }
    
}

