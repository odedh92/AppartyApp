//
//  ChatContainerVC.swift
//  Apparty
//
//  Created by עודד האינה on 25/03/2021.
//

import UIKit

class ChatContainerVC: UIViewController {
    var room : ChatRoom?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func actBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueName = segue.identifier {
            
            switch segueName {
            case SegueToChatRoom_Container:
                
                let chatVC = segue.destination as! ChatMessagesViewController
                chatVC.room = room
                break
                
            default:
                break
                
            }
            
        }
    }

}
