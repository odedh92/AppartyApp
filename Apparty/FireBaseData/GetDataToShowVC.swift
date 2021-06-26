//
//  GetDataToShowVC.swift
//  Apparty
//
//  Created by עודד האינה on 16/02/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class GetDataToShowVC: UIViewController {

    var db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func getDocument() {
        let docRef = db.collection("APPARTMENTS").document("3z2jnBIrc2KEUdgAO4Mr")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            
}
    }
}
