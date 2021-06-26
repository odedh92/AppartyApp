//
//  ChatMessage.swift
//  Apparty
//
//  Created by עודד האינה on 25/03/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MessageKit

class ChatMessage: FirebaseModel {
    
    enum Category:String{
        case text , image
    }
    
    
    let category: Category
    let messageID: String
    let uid: String
    let chatRoomID : String
    let userName: String
    var text: String?
    
    let sentDate: Date

    var dict: [String:Any]{
        var dict = ["messageID":messageID,
                    "userID":uid,
                    "userName":userName,
                    "chatRoomID":chatRoomID,
                    "sentDate":Self.formatter.string(from: sentDate),
                    "category":category.rawValue
        ]
        if let text = text{
            dict["text"] = text
        }
        return dict
    }
    
    required init?(dict: [String : Any]) {
        guard let messageID = dict["messageID"]as? String,
              let userID = dict["userID"]as? String,
              let userName = dict["userName"]as? String,
              let chatRoomID = dict["chatRoomID"]as? String,
              let dateRaw = dict ["sentDate"]as? String,
              let date = Self.formatter.date(from:dateRaw)
        else{return nil}
        
        self.messageID = messageID
        self.uid = userID
        self.userName = userName
        self.sentDate = date
        self.chatRoomID = chatRoomID
        
        self.text = dict ["text"] as? String
        
        if let rawValue = dict ["category"] as? String , let category = Category(rawValue:rawValue){
            self.category = category
        }else{
            self.category = .text
        }
    }
    
    init (text: String){
        guard let user  = Auth.auth().currentUser else {
            fatalError()
        }
        
        self.messageID = UUID().uuidString
        self.uid = user.uid
        self.userName = user.displayName ?? ""
        self.text =  text
        self.sentDate = Date()
        self.category = .text
        self.chatRoomID = text
    }
    init (category: Category){
        guard let user  = Auth.auth().currentUser else {
            fatalError()
        }
        self.messageID = UUID().uuidString
        self.uid = user.uid
        self.userName = user.displayName ?? ""
        self.text =  nil
        self.sentDate = Date()
        self.category = .text
        self.chatRoomID = text ?? " "
    }

}

extension ChatMessage{
    var storageRef: StorageReference{
        return Storage.storage().reference().child("messageImages").child(text ?? "")
    }
    
    func save(in room: ChatRoom){
        let dbRef = room.messagesRef.child(messageID)
        dbRef.setValue(dict)
    }
    func upload(imageData data: Data, callback : @escaping (Error?)->Void){
        let filName = UUID().uuidString + ".jpg"
        
        self.text = filName
        
        storageRef.putData(data , metadata:nil) {(meta, error ) in
            callback(error)
        }
    }
}

struct SSender: SenderType {
    var senderId: String
    var displayName: String
    
}

extension ChatMessage: MediaItem {
    var url: URL? {
        nil
    }
    
    var image: UIImage? {
        return nil
    }
    
    var placeholderImage: UIImage {
        return UIImage()
    }
    
    var size: CGSize {
        return CGSize(width: 200,height: 200)
    }
}

extension ChatMessage: MessageType {
    var sender: SenderType {
        SSender(senderId: self.uid, displayName: self.userName )
    }
    var messageId: String {
        messageID
    }
    var kind: MessageKind {
        if let text = self.text, text.containsOnlyEmoji {
            return MessageKind.emoji(text)
    }
        if self.category == .image {
            return MessageKind.photo(self)
        }
        return .text(self.text ?? "")
}
}
