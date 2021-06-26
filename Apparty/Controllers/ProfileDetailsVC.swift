//
//  ProfileDetailsVC.swift
//  Apparty
//
//  Created by עודד האינה on 02/04/2021.
//

import UIKit

class ProfileDetailsVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? ProfileViewController else {return}
        dest.name = txtName.text
        dest.eMail = txtEmail.text
        dest.city = txtCity.text
    }
}
