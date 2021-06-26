//
//  FirebaseUtils.swift
//  Apparty
//
//  Created by עודד האינה on 10/05/2021.
//

import Foundation
import FirebaseFirestore

class FirebaseUtils {
    func getUserImage(with id: String, callback: @escaping (UIImage) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("ProfileDetails").document(id)
            docRef.getDocument {(document, error)  in
                if let document = document, let data = document.data(), document.exists {
                    let imageUrlString = data["Image"] as! String
                    DispatchQueue.global(qos: .userInteractive).async {
                    guard let imageURL = URL(string: imageUrlString) else {return}
                    guard let imageData = try? Data(contentsOf: imageURL) else {return}
                    guard let image = UIImage(data: imageData) else {return}
                       callback(image)
                }
                } else {
                    print("Document does not exist")
                }
            }
        
    }
    
}
