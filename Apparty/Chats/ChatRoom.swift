//
//  ChatRoom.swift
//  Apparty
//
//  Created by עודד האינה on 22/03/2021.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class ChatRoom : FirebaseModel{
    let id : String
    let title : String
    let ownerId : String
    let ownerName : String
    let ownerId2 : String
    let ownerName2 : String
    
    let createdAt : Date
    var imageUrl : String?

    
    init(title: String, ownerId: String, ownerName: String, imageUrl : String,ownerId2 : String,ownerName2 : String) {
        id = UUID().uuidString
        self.title = title
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.createdAt = Date()
        self.imageUrl = imageUrl
        self.ownerId2 = ownerId2
        self.ownerName2 = ownerName2
    }
    
    init(id: String,title: String, ownerId: String, ownerName: String, imageUrl : String,ownerId2 : String,ownerName2 : String) {
        self.id = id
        self.title = title
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.createdAt = Date()
        self.imageUrl = imageUrl
        self.ownerId2 = ownerId2
        self.ownerName2 = ownerName2
    }
    
    required init?(dict:[String:Any]){
        guard let id = dict ["id"] as? String,
        let title = dict ["title"] as? String,
        let ownerId = dict ["ownerId"] as? String,
        let ownerId2 = dict ["ownerId2"] as? String,
        let ownerName = dict ["ownerName"] as? String,
        let ownerName2 = dict ["ownerName2"] as? String,
        let dateString = dict ["createdAt"] as? String else {
            return nil
        }
        self.id = id
        self.title = title
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.ownerId2 = ownerId2
        self.ownerName2 = ownerName2
    
        guard let date = ChatRoom.formatter.date(from: dateString) else{
            return nil
        }
        self.createdAt = date
    }
  
    
    var dict : [String:Any]{
        var dict = ["id":id ,
                    "title":title,
                    "ownerId":ownerId,
                    "ownerName":ownerName,
                    "ownerId2":ownerId2,
                    "ownerName2":ownerName2]
        
        let dateString = ChatRoom.formatter.string(from: createdAt)
        dict["createdAt"] = dateString
        
        if let imageUrl = imageUrl {
            dict ["imageURL"] = imageUrl
        }
        return dict
    }
}

extension ChatRoom{
    
    var messagesRef:DatabaseReference{
        return Database.database().reference().child("messages").child(id)
    }
    
    static var ref :DatabaseReference {
        return Database.database().reference().child("ChatRooms")
    }
    
    var imageRef : StorageReference {
        return Storage.storage().reference().child("ChatRooms").child(id + ".jpg")
    }
    
    func save(callback: @escaping (Error? , Bool)->Void){
        ChatRoom.ref.child(self.id).setValue(dict){ (error , dbRef) in
            if let error = error {
              callback(error,false)
                return
            }
            callback(nil,true)
        }
    }
    
    static func chatRooms(uid:String, callback: @escaping ([ChatRoom]) -> Void){
        var rooms:[ChatRoom] = []

               ChatRoom.ref.queryOrderedByKey().observe(.childAdded) { (snapshop) in
                let value = snapshop.value as? NSDictionary
                
                      let title =  value?["title"] as? String ?? ""
                      let id =  value?["id"] as? String ?? ""
                      let ownerId = value?["ownerId"] as? String ?? ""
                      let ownerName = value?["ownerName"] as? String ?? ""
                      let ownerId2 = value?["ownerId2"] as? String ?? ""
                      let ownerName2 = value?["ownerName2"] as? String ?? ""
                      let imageUrl = value?[ "imageUrl"] as? String ?? ""
                if ownerId == uid || ownerId2 == uid {
                    rooms.append(ChatRoom(id:id,title: title, ownerId: ownerId, ownerName: ownerName, imageUrl: imageUrl, ownerId2: ownerId2, ownerName2: ownerName2))
                }
                callback(rooms)
               }
                
    }

    func save(image:UIImage , callback:@escaping (Error? , Bool)->Void){
        guard let data = image.jpegData(compressionQuality: 1) else{
            callback(nil,false)
            return
        }
        imageRef.putData(data,metadata: nil){(metadata,error) in
            if let error = error {
                callback(error,false)
                return
            }
            self.imageUrl = self.id + ".jpg"
        
        
            ChatRoom.ref.child(self.id).setValue(self.dict){ (error , dbRef) in
            if let error = error {
              callback(error,false)
                return
            }
            callback(nil,true)
        }
    }
    }
    }
