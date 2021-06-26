//
//  AparmentViewController.swift
//  Apparty
//
//  Created by עודד האינה on 17/02/2021.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

class AparmentViewController: UIViewController{

    var arrReused : [Apertment]?
    var arrAppartments : [Apertment] = []
    let db = Firestore.firestore()
    let imageCache = NSCache<NSString, UIImage>()
    @IBOutlet weak var tbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if arrReused != nil {
            arrAppartments = arrReused!;
            self.tbl.reloadData()            
        }
        else{
            getAppartments()
        }
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
}
extension AparmentViewController : ShowApartmentProtocol {
    func didAddChatRoom(room:ChatRoom) {
        if let vc = self.tabBarController?.viewControllers![3] as? RoomsTableViewController {
            vc.toOpen = room
        }
        self.tabBarController?.selectedIndex = 3
    }
}
extension AparmentViewController : ApartmentTableViewProtocol {
    func showDetails(app: Apertment) {
        let vc:ShowApartmentVC = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ShowApartmentVC") as! ShowApartmentVC
        vc.appartment = app
        vc.delegate = self
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
extension AparmentViewController : UITableViewDataSource , UITableViewDelegate {
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
            let app = arrAppartments[indexPath.row]
            cell.delegate = self
            cell.Apertment = app;
            if let price = app.Price {
            cell.lblPrice.text = "₪"
            cell.lblPrice.text! += makeNumberStringFormated(number:price)
        }
            cell.lblCity.text = app.City
            cell.lblStreet.text = app.Street
            cell.lblRooms.text = app.Rooms
            cell.btnToDetails.tag = indexPath.row+1
            cell.img.image = nil
            cell.like.setImage(nil, for: UIControl.State.normal)
        DispatchQueue.global(qos: .userInteractive).async {
        let isLiked:Bool = FavCoreData.shared.getFavApp().contains { (entity) -> Bool in
            return entity.isSame(app: app)
        }
        DispatchQueue.main.async {
        cell.like.setImage(isLiked ?  UIImage(named: "icons8-like") :  UIImage(named: "icons8-filled_like"), for: .normal)
            }
        }
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
