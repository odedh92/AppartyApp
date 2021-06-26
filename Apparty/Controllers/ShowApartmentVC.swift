//
//  ShowApartmentVC.swift
//  Apparty
//
//  Created by עודד האינה on 24/02/2021.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase


protocol ShowApartmentProtocol {
    func didAddChatRoom(room:ChatRoom)
}
class ShowApartmentVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblRooms: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgLeft: UIImageView!
    @IBOutlet weak var imgRight: UIImageView!
    var appartment : Apertment?
    var favappartment: FavEntity?
    var locationName:String?
    var delegate:ShowApartmentProtocol?
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        func setRegion(location:CLLocation){
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
        let address = self.lblCity.text! + " " + self.lblStreet.text!
        print(address)
        geocoder.geocodeAddressString(address) {[weak self] (arr, error) in
                
                    if let arr = arr, let place = arr.first{
                        if let location = place.location{
                            let coordinate = location.coordinate
                            let Annotation = MKPointAnnotation()
                            Annotation.coordinate = coordinate
                            Annotation.title = address
                            self?.mapView.addAnnotation(Annotation)
                            setRegion(location: location)
                        }
                    }
    }
     }
    func makeNumberStringFormated(number:String)->String{
        guard let d = Double(number) else {return NumberFormatter().string(from: NSNumber())!}
        let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
        let formattedValue = formatter.string(from: NSNumber(value: d))!
        return formattedValue;
    }
    func setData(){
        lblStreet.text = appartment?.Street ?? favappartment?.street
        if let price = appartment?.Price {
            lblPrice.text = "₪"
            lblPrice.text! += makeNumberStringFormated(number:price)
        }
        lblCity.text = appartment?.City ?? favappartment?.city
        lblRooms.text = appartment?.Rooms ?? favappartment?.rooms
        lblSize.text = appartment?.Size ?? favappartment?.size
        lblType.text = appartment?.Type ?? favappartment?.type
        DispatchQueue.global(qos: .background).async {[weak self] in
            let url = URL(string:(self?.appartment?.Image1 ?? self?.favappartment?.image ?? ""))
            print("The url:",url?.absoluteString);
            if (url != nil){
                let data = try? Data(contentsOf: url!)
                if data != nil {
                    DispatchQueue.main.async {
                        self?.imgLeft.image = UIImage(data: data!)
                    }
                }
            
            }
        }
        DispatchQueue.global(qos: .background).async {[weak self] in
            let url = URL(string:(self?.appartment?.Image2 ?? self?.favappartment?.image ?? ""))
            print("The url:",url?.absoluteString);
            if (url != nil){
                let data = try? Data(contentsOf: url!)
                if data != nil {
                    DispatchQueue.main.async {
                        self?.imgRight.image = UIImage(data: data!)
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                self?.imgRight.removeFromSuperview()
                }
            }
        }
    }
    @IBAction func btnCall(_ sender: UIButton) {
        callNumber(phoneNumber:(appartment?.PhoneNumber)!)
    }
    
    func getChatRoom(owner1:String,owner2:String,callback:@escaping (Bool) -> Void){
        var arr:[DataSnapshot] = []
        var bool = false
        var found = false
        Database.database().reference().child("ChatRooms").observe(.value) { (snapshot) in
            guard let dict = snapshot.children.allObjects as? [DataSnapshot] else {
                    return}
            if bool {return}
                for elem in dict {
                    arr.append(elem)
                }
            
            for s in arr {
                if bool {
                    return
                }
                let owner1Db = s.childSnapshot(forPath: "ownerId").value as! String
                let owner2Db = s.childSnapshot(forPath: "ownerId2").value as! String
                if owner1 == owner1Db && owner2 == owner2Db {
                    bool = true
                }
            }
            if found {
                return
            }
            callback(bool)
            found = true
        }
    }
    func createChat(sender: UIButton) {
        guard let owner = appartment?.Owner else {return}

         guard let user = Auth.auth().currentUser else {
             showLabel(title: "Must be logged in")
             return
         }
         sender.isEnabled = false
        
        getChatRoom(owner1: user.uid, owner2: owner) { (exists) in

            if exists {
                showAlertOk(title: "Chat Alert", message: "You already have a chat room with this owner", vc: self)
                return
            }else {
                let room = ChatRoom(title: self.appartment?.City ?? " " , ownerId: user.uid , ownerName: "Oded", imageUrl: user.photoURL?.absoluteString ?? "", ownerId2: (owner) , ownerName2: " ")
                     room.save {[weak self] (error,succsess) in
                         if let err = error {
                             print("ERROR", err.localizedDescription)
                         }
                         if succsess{
                            self?.dismiss(animated: true,completion: {
                                self?.delegate?.didAddChatRoom(room:room)
                            })
                         }else{
                             self?.showError(title: "Please try again")
                             sender.isEnabled = true
                         }
                     }
            }
        }
    }
    @IBAction func btnChat(_ sender: UIButton) {
        createChat(sender: sender)
    }
    private func callNumber(phoneNumber:String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
}
