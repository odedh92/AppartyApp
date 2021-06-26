//
//  SearchPageViewController.swift
//  Apparty
//
//  Created by עודד האינה on 20/02/2021.
//

import UIKit

class SearchPageViewController: UIViewController, UIPopoverPresentationControllerDelegate,SearceTypeTBDelagate , SearceCityTBDelagate , SearceRoomsTBDelagate {
    
    var arrAppartments : [Apertment] = []
    var selectedDealType = TypeSearch[2]
    var selectedCity = CitySearch[4]
    var selectedRooms = RoomsSearch[3]
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var btnRooms: UIButton!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var switchBalcony: UISwitch!
    var selectedBalcony = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    @IBAction func actSearch(_ sender: Any) {
        requestSearchResult()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueName = segue.identifier {
            switch segueName {
            case Segue_To_DetailsSearchReults:
                let apptDetails = segue.destination as! AparmentViewController
                apptDetails.arrReused = sender as! [Apertment]
                break
            default:
                break
            }
        }
    }
    func initView(){
        btnType.setTitle(selectedDealType, for: .normal)
        btnCity.setTitle(selectedCity, for: .normal)
        btnRooms.setTitle(selectedRooms, for: .normal)
    }
    func SearceTypeTBDelagate(code: String) {
//        print("selected",code)
        selectedDealType = code
        btnType.setTitle(selectedDealType, for: .normal);
    }
    func SearceCityTBDelagate(code: String) {
        print("selected",code)
        selectedCity = code
        btnCity.setTitle(selectedCity, for: .normal);
    }
    func SearceRoomsTBDelagate(code: String) {
        print("selected",code)
        selectedRooms = code
        btnRooms.setTitle(selectedRooms, for: .normal);
    }
    
    func Balcony(){
        if switchBalcony.isOn == true{
            selectedBalcony = true
        }else{
            selectedBalcony = false
        }
    }
    @IBAction func btnShowType(_ sender: Any) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "SearceType") as! SearceType
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            let viewForSource = sender as! UIView
            popover.sourceView = viewForSource
            popover.sourceRect = viewForSource.bounds
            popoverContent.preferredContentSize = CGSize(width: 220, height: 140)
            popoverContent.delegate = self
            popover.delegate = self
        }
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func btnShowCity(_ sender: Any) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "SearchCity") as! SearceCity
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            let viewForSource = sender as! UIView
            popover.sourceView = viewForSource
            popover.sourceRect = viewForSource.bounds
            popoverContent.preferredContentSize = CGSize(width: 250, height: 200)
            popoverContent.delegate = self
            popover.delegate = self
        }
        self.present(popoverContent, animated: true, completion: nil)
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }
    }
    @IBAction func btnShowRooms(_ sender: Any) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "SearceRooms") as! SearceRooms
        popoverContent.modalPresentationStyle = .popover
        if let popover = popoverContent.popoverPresentationController {
            let viewForSource = sender as! UIView
            popover.sourceView = viewForSource
            popover.sourceRect = viewForSource.bounds
            popoverContent.preferredContentSize = CGSize(width: 250, height: 200)
            popoverContent.delegate = self
            popover.delegate = self
        }
        self.present(popoverContent, animated: true, completion: nil)
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }
    }
    func requestSearchResult(){
        requstAppBySearchPage(type: selectedDealType, city: selectedCity, rooms: selectedRooms, balcony: switchBalcony.isOn) { (arrAppartmentRes, err) in
            if (err != nil){
                showAlertOk(title: "Error", message: "Error request", vc: self)
            }
            else{
                if arrAppartmentRes.count > 0 {
                    self.performSegue(withIdentifier: Segue_To_DetailsSearchReults , sender: arrAppartmentRes)
                }
                else{
                    showAlertOk(title: ":-(", message: "No Results", vc: self)
                }
                
            }
        }
    }
}





