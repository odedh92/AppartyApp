//
//  FirebaseHandler.swift
//  Apparty
//
//  Created by עודד האינה on 10/03/2021.
//

import Foundation

import FirebaseFirestore
import FirebaseAuth
typealias CompletionHandler_Appartments = (_ arrResult:[Apertment], _ error:Error?) -> Void

func signOutFirebase(){
    let firebaseAuth = Auth.auth()
do {
  try firebaseAuth.signOut()
} catch let signOutError as NSError {
  print ("Error signing out: %@", signOutError)
}
}
func requestGetAllAppartments( callback :@escaping CompletionHandler_Appartments){
    
    let docRef = Firestore.firestore().collection("APPARTMENTS")
    var arrAppartments : [Apertment] = []
    docRef.getDocuments(completion: { (querySnapshot, err) in
        
        if let err = err {
            print("Error getting documents: \(err)")
            callback(arrAppartments,err);
        } else {
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                let result = Result {
                    try document.data(as: Apertment.self)
                }
                
                switch result {
                case .success(let appartment):
                    if let app = appartment {
                        arrAppartments.append(app);
                    } else {
                        print("Document does not exist")
                    }
                case .failure(let error):
                    print("Error decoding city: \(error)")
                }
                
            }
            
            callback(arrAppartments,nil);
        }
    })
    
}





func requstAppInCity(city:String ,callback :@escaping CompletionHandler_Appartments ){
    var arrAppartments : [Apertment] = []
    let docRef = Firestore.firestore().collection("APPARTMENTS")
       
        docRef.whereField("City", isEqualTo: city)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                callback(arrAppartments,err);
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let result = Result {
                        try document.data(as: Apertment.self)
                       }
                    switch result {
                     case .success(let appartment):
                         if let app = appartment {
                            arrAppartments.append(app);
                         } else {
                             print("Document does not exist")
                         }
                     case .failure(let error):
                         print("Error decoding city: \(error)")
                     }
                    
                   }
                
                callback(arrAppartments,nil);
               }
        };

                }

func requstAppByType(type:String ,callback :@escaping CompletionHandler_Appartments ){
    var arrAppartments : [Apertment] = []
    let docRef = Firestore.firestore().collection("APPARTMENTS")
       
    docRef.whereField("Type", isEqualTo: type)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                callback(arrAppartments,err);
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let result = Result {
                        try document.data(as: Apertment.self)
                       }
                    switch result {
                     case .success(let appartment):
                         if let app = appartment {
                            arrAppartments.append(app);
                         } else {
                             print("Document does not exist")
                         }
                     case .failure(let error):
                         print("Error decoding city: \(error)")
                     }
                    
                   }
                
                callback(arrAppartments,nil);
               }
        };

                }

func requstAppBySearchPage(type:String? , city:String?,rooms:String?,balcony: Bool ,callback :@escaping CompletionHandler_Appartments ){
    var arrAppartments : [Apertment] = []
    let docRef = Firestore.firestore().collection("APPARTMENTS")

    docRef.whereField("City", isEqualTo: city!)
        .whereField("Rooms", isEqualTo: rooms!)
        .whereField("Type", isEqualTo: type!)
        .whereField("hasBalcony", isEqualTo: balcony)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                callback(arrAppartments,err);
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let result = Result {
                        try document.data(as: Apertment.self)
                       }
                    switch result {
                     case .success(let appartment):
                         if let app = appartment {
                            arrAppartments.append(app);
                         } else {
                             print("Document does not exist")
                         }
                     case .failure(let error):
                         print("Error decoding city: \(error)")
                     }
                    
                   }
                
                callback(arrAppartments,nil);
               }
        };

                }

func requstAppSubletTlv(type:String , city:String,callback :@escaping CompletionHandler_Appartments ){
    var arrAppartments : [Apertment] = []
    let docRef = Firestore.firestore().collection("APPARTMENTS")
       
    docRef.whereField("Type", isEqualTo: "Sublet" ?? "").whereField("City", isEqualTo: "Tel aviv" ?? "")
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                callback(arrAppartments,err);
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let result = Result {
                        try document.data(as: Apertment.self)
                       }
                    switch result {
                     case .success(let appartment):
                         if let app = appartment {
                            arrAppartments.append(app);
                         } else {
                             print("Document does not exist")
                         }
                     case .failure(let error):
                         print("Error decoding city: \(error)")
                     }
                    
                   }
                
                callback(arrAppartments,nil);
               }
        };

                }


protocol FirebaseModel {
    var dict : [String:Any]{get}
    init? (dict:[String:Any])
}

extension FirebaseModel{
    static var formatter : ISO8601DateFormatter{
        let formatter = ISO8601DateFormatter()
        
        formatter.formatOptions =  [.withInternetDateTime , .withFractionalSeconds]
        return formatter
    }
}

