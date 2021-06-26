//
//  FavApartmentCell.swift
//  Apparty
//
//  Created by עודד האינה on 13/03/2021.
//

import Foundation
protocol FavApartmentProtocol {
    func didUnlike(favApp:FavEntity)
    func showDetails(favApp:FavEntity)
}
class FavApartmentCell: UITableViewCell {
    var FavApartments :FavEntity?
    var delegate:FavApartmentProtocol?
    @IBOutlet weak var lblBalcony: UILabel!
    @IBOutlet weak var lblElavator: UILabel!
    @IBOutlet weak var lblRooms: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnToDetails: UIButton!
    @IBOutlet weak var like: UIButton!
    
    @IBAction func Unlike(_ sender: UIButton) {
        guard let favApp = FavApartments else {return}
        delegate?.didUnlike(favApp: favApp)
    }
    
    @IBAction func ShowDetails(_ sender: UIButton) {
        guard let favApp = FavApartments else {return}
        delegate?.showDetails(favApp: favApp)
    }
    
}
