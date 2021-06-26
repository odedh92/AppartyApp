//
//  NavigatorVC.swift
//  Apparty
//
//  Created by Oded haina on 03/02/2021.
//

import UIKit
import Firebase

class NavigatorVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//deleteUser()
//userSignOut()
        navigate()
    }
    func userSignOut(){
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("Couldn't create the audio player for file")
        }
    }
 
    func navigate(){
        if AppDelegate.user != nil {
            self.performSegue(withIdentifier: Segue_To_MainApp2, sender: nil)

        } else {
            self.performSegue(withIdentifier: Segue_To_PhoneNumberSignUp, sender: nil)
        }
    }
}



