//
//  RentInHaifaViewController.swift
//  Apparty
//
//  Created by עודד האינה on 09/03/2021.
//

import UIKit
import FirebaseUI
import FirebaseFirestore


//protocol Searches {
//    func requestAppInCity(_in: String)
//}

enum FunctionToDo {
    case RentInAshdod
    case RentInHaifa
    case TLV_Sublet
    case Sell
    case Sublet
    case Rent
}
class RentInHaifaViewController: UIViewController{
    
//    var City:String!
    var arrAppartments : [Apertment] = []
    let db = Firestore.firestore()
    let imageCache = NSCache<NSString, UIImage>()
    @IBOutlet weak var tbl: UITableView!
    
    var funcToDo : FunctionToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if funcToDo == nil  {
            RentInAshdod()
        }
        else {
            switch funcToDo {
            case .RentInAshdod:
                RentInAshdod()
                break
                
            case .TLV_Sublet:
                TLV_Sublet()
                break
                
            case .RentInHaifa:
            requstAppInHaifa()
            break
                
            case .Sell:
            getAppartmentsForSell()
            break
                
            case .Sublet:
            getAppartmentsForSublet()
            break
                
            case .Rent:
            getAppartmentsForRent()
            break
            default:
                break
            }
        }
        
    }
    func getAppartmentsForSell(){
        db.collection("APPARTMENTS").whereField("Type", isEqualTo: "For Sell")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
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
                                self.arrAppartments.append(app);
                             } else {
                                 print("Document does not exist")
                             }
                         case .failure(let error):
                             print("Error decoding city: \(error)")
                         }
                       }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                    }
                   }
            };
                    }

    func getAppartmentsForSublet(){
        db.collection("APPARTMENTS").whereField("Type", isEqualTo: "For Sublet")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
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
                                self.arrAppartments.append(app);
                             } else {
                                 print("Document does not exist")
                             }
                         case .failure(let error):
                             print("Error decoding city: \(error)")
                         }
                       }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                    }
                   }
            };
                    }

    func getAppartmentsForRent(){
        db.collection("APPARTMENTS").whereField("Type", isEqualTo: "For Rent")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
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
                                self.arrAppartments.append(app);
                             } else {
                                 print("Document does not exist")
                             }
                         case .failure(let error):
                             print("Error decoding city: \(error)")
                         }
                       }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                    }
                   }
            };
                    }


        func requstAppInHaifa(){
            db.collection("APPARTMENTS").whereField("City", isEqualTo: "Haifa").whereField("Type", isEqualTo: "For Sell")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
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
                                    self.arrAppartments.append(app);
                                 } else {
                                     print("Document does not exist")
                                 }
                             case .failure(let error):
                                 // A `City` value could not be initialized from the DocumentSnapshot.
                                 print("Error decoding city: \(error)")
                             }
                           }
                        DispatchQueue.main.async {
                            self.tbl.reloadData()
                        }
                       }
                };
                        }
    
    
    func getAppartments(){
        requestGetAllAppartments { (arrAppartments, err) in
            if (err != nil){
                showAlertOk(title: "Error", message: "Error request", vc: self)
            }
            else{
                self.arrAppartments = arrAppartments;
                DispatchQueue.main.async {
                    self.tbl.reloadData()
                }
            }
        }
    }
    func RentInAshdod(){
        db.collection("APPARTMENTS").whereField("City", isEqualTo: "Ashdod")
            .whereField("Type",isEqualTo: "For Rent")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
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
                                self.arrAppartments.append(app);
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding city: \(error)")
                        }
                    }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                    }
                }
            }
    }
    func TLV_Sublet(){
        db.collection("APPARTMENTS").whereField("City", isEqualTo: "Tel Aviv")
           .whereField("Type",isEqualTo: "For Sublet")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
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
                                self.arrAppartments.append(app);
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding city: \(error)")
                        }
                    }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                    }
                }
            };
    }
}

extension RentInHaifaViewController : ApartmentTableViewProtocol {
    func showDetails(app: Apertment) {
        let vc:ShowApartmentVC = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ShowApartmentVC") as! ShowApartmentVC
        vc.appartment = app
        present(vc, animated: true)
    }
    func didSaveApp(app: Apertment) {
        var alreadyExists:Bool = false
        FavCoreData.shared.getFavApp().forEach { (entity) in
            if entity.isSame(app: app) {
                showAlertOk(title: "Alert", message: "This Apartment is already in your favorites!", vc: self)
                alreadyExists = true
               return
            }
        }
        if !alreadyExists {
        let newFavApp = FavEntity.init(balcony: app.hasBalcony ?? false, city: app.City ?? "", elavator: app.hasElavator ?? false, image: app.Image1 ?? "" , owner: app.Owner ?? "", rooms: app.Rooms ?? "", size: app.Size ?? "", street: app.Street ?? "", type: app.Type ?? "",price: app.Price ?? "")
        FavCoreData.shared.save(favApp: newFavApp)
        if let vc:ProfileViewController = tabBarController?.viewControllers?[2] as? ProfileViewController {
            vc.favApartments = FavCoreData.shared.getFavApp()
            vc.tblFav?.reloadData()
        }
        }
    }
}

extension RentInHaifaViewController:  UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAppartments.count
    }
    func makeNumberStringFormated(number:String)->String{
        guard let d = Double(number) else {return NumberFormatter().string(from: NSNumber())!}
        let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
        let formattedValue = formatter.string(from: NSNumber(value: d))!
        return formattedValue;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell") as! ApartmentTableViewCell
        let app = arrAppartments[indexPath.row];
        if let price = app.Price {
        cell.lblPrice.text = "₪"
        cell.lblPrice.text! += makeNumberStringFormated(number:price)
    }
        cell.lblCity.text = app.City
        cell.lblStreet.text = app.Street
        cell.lblRooms.text = app.Rooms
        cell.btnToDetails.tag = indexPath.row+1
        cell.img.image = nil;
        cell.delegate = self
        cell.Apertment = app
        if app.hasElavator  ?? false {
            cell.lblElavator.text = "✓"
        }
        
        if app.hasBalcony  ?? false {
            cell.lblBalcony.text = "✓"
        }
        
        if let cachedImage = imageCache.object(forKey: NSString(string:app.Image1!)) {
            cell.img.image = cachedImage
        }
        else{
            DispatchQueue.global(qos: .background).async {
                let url = URL(string:(app.Image1!))
                print("The url:",app.Image1!);
                print("Index",indexPath.row)
                if (url != nil){
                    let data = try? Data(contentsOf: url!)
                    if data != nil {
                        
                        DispatchQueue.main.async {
                            let image: UIImage = UIImage(data: data!)!
                            self.imageCache.setObject(image, forKey: NSString(string:app.Image1!))
                            cell.img.image = image
                        }
                    }
                }
            }
        }
        return cell;
    }
}
