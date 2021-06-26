//
//  HomeScreenViewController.swift
//  Apparty
//
//  Created by Oded haina on 29/01/2021.
//

import UIKit
import Firebase


class HomeScreenViewController: UIViewController {
 
    var arrAppartments : [Apertment] = []
    @IBAction func SellBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Segue_To_Filtered, sender: FunctionToDo.Sell)
    }
    @IBAction func RentBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Segue_To_Filtered, sender: FunctionToDo.Rent)
    }
    @IBAction func SubletBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Segue_To_Filtered, sender: FunctionToDo.Sublet)
    }
    @IBAction func RentHaifaBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Segue_To_Filtered, sender: FunctionToDo.RentInHaifa)
    }
    
    @IBAction func BuyAshdodBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Segue_To_Filtered, sender: FunctionToDo.RentInAshdod)
    }
    
    @IBAction func SubletTlvBtn(_ sender: UIButton) {
        performSegue(withIdentifier: Segue_To_Filtered, sender: FunctionToDo.TLV_Sublet)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueName = segue.identifier {
            switch segueName {
            case Segue_To_Filtered:
                let apptDetails = segue.destination as! RentInHaifaViewController
                apptDetails.funcToDo = sender as! FunctionToDo
                break
            default:
                break
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.backgroundColor = .clear
        tabBarController?.tabBar.clipsToBounds = true
        self.view.bounds = UIScreen.main.bounds
        let num = "212122.63262362"
        makeNumberStringFormated(number:Double(num)!)
    }
    func makeNumberStringFormated(number:Double)->String{
        let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
        let formattedValue = formatter.string(from: NSNumber(value: number))!
        return formattedValue;
    }
}
