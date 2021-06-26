//
//  ApartmentTableViewCell.swift
//  Apparty
//
//  Created by עודד האינה on 17/02/2021.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

protocol ApartmentTableViewProtocol {
    func didSaveApp(app: Apertment)
    func showDetails(app:Apertment)
}

class ApartmentTableViewCell: UITableViewCell {
    let db = Firestore.firestore()
    var Apertment:Apertment?
    var delegate:ApartmentTableViewProtocol?
    @IBOutlet weak var lblBalcony: UILabel!
    @IBOutlet weak var lblElavator: UILabel!
    @IBOutlet weak var lblRooms: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnToDetails: UIButton!
    @IBOutlet weak var like: UIButton!
   
    @IBAction func btnAddFav(_ sender: UIButton) {
        like.setImage(UIImage(named: "icons8-like"), for: UIControl.State.normal)
        if let app = Apertment {
            delegate?.didSaveApp(app: app)
        }
    }
    @IBAction func btnSend(_ sender: UIButton) {
        if let app = Apertment {
            print("REach")
            delegate?.showDetails(app: app)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lblElavator.text = "x"
        lblBalcony.text = "x"
    }
    }

