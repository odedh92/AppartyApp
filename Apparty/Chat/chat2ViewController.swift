//
//  chat2ViewController.swift
//  Apparty
//
//  Created by עודד האינה on 21/02/2021.
//

import UIKit
import MessageKit

class chat2ViewController: UIViewController {
    private var messages: [Message] = []
    private var messageListener: UserDefaults?

    
    extension chat2ViewController: MessagesDataSource {
        func currentSender() -> Sender {
           return Sender(id: user.uid, displayName: AppSettings.displayName)
         }


  
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
