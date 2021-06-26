//
//  ProfileViewController.swift
//  Apparty
//
//  Created by Oded haina on 29/01/2021.


import UIKit
import FirebaseAuth
import FirebaseFirestore


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    lazy var id:String = FirebaseAuth.Auth.auth().currentUser!.uid
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tblFav: UITableView!
    var name:String?
    var eMail:String?
    var city:String?
    var didSelectImage = false
    
    let imageCache = NSCache<NSString, UIImage>()
    var favApartments:[FavEntity] = {
        return FavCoreData.shared.getFavApp()
    }()
    @IBOutlet weak var ProfileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var url:String?
        getDocument { [weak self] (data) in
            print("Starting")
            self?.name = data["full name"] as? String
            self?.city = data["city"] as? String
            self?.eMail = data["email"] as? String
            url = data["Image"] as? String
            guard let name = self?.name,
                  let city = self?.city,
                  let eMail = self?.eMail else {
                print("Something went wrong")
                return
            }
            DispatchQueue.main.async {
               self?.lblName.text = name
               self?.lblCity.text = city
               self?.lblEmail.text = eMail
               print("Finished updating ui")
           }
                print("URL: ",url)
            guard let urlString = url else {
                print("Invaild url string")
            return
            }
            DispatchQueue.global(qos: .background).async {
                let url = URL(string:(urlString))
                if (url != nil){
                    guard let data = try? Data(contentsOf: url!) else {
                        print("Data corrupted")
                        return}
                    guard let image = UIImage(data:data) else {
                        print("could not fetch image")
                        return}
                    DispatchQueue.main.async {
                        self?.ProfileImage.image = image
                    }
                }else {
                    print("invailed url")
                }
            }
        }
    }
    private func getDocument(callback:@escaping ([String:Any]) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("ProfileDetails").document(self.id)
        print(id, "IDENTIFIERhhyththgy")
            docRef.getDocument { (document, error) in
              if let document = document, let data = document.data(), document.exists {
                    callback(data)
                } else {
                    print("Document does not exist")
                }
    }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueName = segue.identifier {
            
            switch segueName {
            case SegueFromFavApp:
                
                let btn = sender as! UIButton
                let apt = favApartments[btn.tag]
                
                let apt1 = Apertment(City: apt.city, Street: apt.street, Rooms: apt.rooms, Price: apt.price, Type: apt.type, name: nil, Image1: apt.image, Image2: nil, Size: apt.size, hasBalcony: apt.balcony, hasElavator: apt.elavator, Owner: apt.owner)
                
                let apptDetails = segue.destination as! ShowApartmentVC
                apptDetails.appartment = apt1
                break
                
            default:
                break
                
            }
            
        }
    }
}



extension ProfileViewController : FavApartmentProtocol {
    func didUnlike(favApp: FavEntity) {
        FavCoreData.shared.delete(favApp: favApp)
        favApartments = FavCoreData.shared.getFavApp()
        tblFav?.reloadData()
    }
    func showDetails(favApp: FavEntity) {
        let vc:ShowApartmentVC = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ShowApartmentVC") as! ShowApartmentVC
        vc.favappartment = favApp
        present(vc, animated: true)
    }
}

extension ProfileViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favApartments.count
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
        print("another row")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell") as! FavApartmentCell
            let app = favApartments[indexPath.row]
        cell.btnToDetails.tag = indexPath.row
        cell.delegate = self
            cell.FavApartments = app
            let price = app.price
            cell.lblPrice.text = "₪"
            cell.lblPrice.text! += makeNumberStringFormated(number:price)
            cell.lblCity.text = app.city
            cell.lblStreet.text = app.street
            cell.lblRooms.text = app.rooms
            cell.img.image = nil
            if app.elavator  ?? false {
            cell.lblElavator.text = "✓"
            }

            if app.balcony  ?? false {
            cell.lblBalcony.text = "✓"
            }

            if let cachedImage = imageCache.object(forKey: NSString(string:app.image)) {
                cell.img.image = cachedImage
            }
            else{
                DispatchQueue.global(qos: .background).async {
                    let url = URL(string:(app.image))
                    print("The url:",app.image);
                    print("Index",indexPath.row)
                    if (url != nil){
                        let data = try? Data(contentsOf: url!)
                        if data != nil {

                            DispatchQueue.main.async {
                                let image: UIImage = UIImage(data: data!)!
                                self.imageCache.setObject(image, forKey: NSString(string:app.image))
                                 cell.img.image = image
                            }
                        }

                    }
                }
            }
        return cell
    }
    }
