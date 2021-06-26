//
//  RoomTableViewCell.swift
//  Apparty
//
//  Created by עודד האינה on 24/03/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RoomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!


    func populate(room:ChatRoom){
       // titleLabel.text = room.title
        ownerLabel.text =  room.ownerName2
        let db = Firestore.firestore()
        let currentUserId = FirebaseAuth.Auth.auth().currentUser!.uid
        var realOwnerId = currentUserId
    
        if (realOwnerId == room.ownerId) {
            realOwnerId = room.ownerId2
        }else {
            realOwnerId = room.ownerId
        }
        let docRef = db.collection("ProfileDetails").document(realOwnerId)
        docRef.getDocument { [weak self] (document, error)  in
            if let document = document, let data = document.data(), document.exists {
                let ownerName = data["full name"] as! String
                DispatchQueue.main.async {
                    self?.titleLabel.text = "Chat With: " + ownerName
                }
            }
        }
        let utils = FirebaseUtils()
        utils.getUserImage(with: realOwnerId) {[weak self] (image) in
            DispatchQueue.main.async {
                self?.roomImageView.image = image
            }
        }

}
}
