//
//  AddAppDetailsVC.swift
//  Apparty
//
//  Created by עודד האינה on 11/02/2021.
//

import UIKit
import Firebase
import FirebaseFirestore


class AddAppDetailsVC: UIViewController {

    var imageurl1:String?
    var imageurl2:String?
    @IBOutlet weak var btnbtn: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var stackFirst: UIStackView!
    @IBOutlet weak var stackSecond: UIStackView!
    @IBOutlet var arrText: [UITextField]!
    @IBOutlet weak var switchHasElavator: UISwitch!
    @IBOutlet weak var switchHasBalcony: UISwitch!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var phoneNumber : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lines()
        phoneNumber = (Auth.auth().currentUser?.phoneNumber)!
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    @IBAction func actSendData(_ sender: Any) {
        var dictToSend = [
            KEY_city:getValueForTag(tagId: 1),
            "Street":getValueForTag(tagId: 2),
            "Size":getValueForTag(tagId: 3),
            "Rooms":getValueForTag(tagId: 4),
            "Type":getValueForTag(tagId: 5),
            "Price":getValueForTag(tagId: 6),
            "HasElavator":switchHasElavator.isOn,
            "HasBalcony":switchHasBalcony.isOn,
            "Owner": (Auth.auth().currentUser?.uid)!,
            "PhoneNumber": phoneNumber,
            "Image1":"url",
            "Image2":"url",
            "Image3":"url",
        ] as [String : Any]
        firebaseSetDataRequest(dict: dictToSend)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func sendData(){
        var dictToSend = [
            KEY_city:getValueForTag(tagId: 1),
            "Street":getValueForTag(tagId: 2),
            "Size":getValueForTag(tagId: 3),
            "Rooms":getValueForTag(tagId: 4),
            "Type":getValueForTag(tagId: 5),
            "Price":getValueForTag(tagId: 6),
            "HasElavator":switchHasElavator.isOn,
            "HasBalcony":switchHasBalcony.isOn,
            "Owner": (Auth.auth().currentUser?.uid)!,
            "PhoneNumber": phoneNumber,
            "Image1":imageurl1 ?? "No Url",
            "Image2":imageurl2 ?? "No Url",
            "Image3":"url",
        ] as [String : Any]
        firebaseSetDataRequest(dict: dictToSend)
    }
    
    func getValueForTag(tagId:Int)->String{
        for txt in arrText {
            if (txt.tag == tagId){
                return txt.text!
            }
        }
        return ""
    }
    
    func resetFields(){
        switchHasElavator.setOn(false, animated: true)
        switchHasBalcony.setOn(false, animated: true)
        for txt in arrText {
            txt.text = ""
        }
        
    }
    
    func isValidateTextFieldNotEmpty()->Bool{
        for txt in arrText {
            if txt.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return false;
            }
        }
        
        return true;
    }

    func  firebaseSetDataRequest(dict:[String:Any]){
    let db = Firestore.firestore()
        spinner.isHidden = false
        print("1");
        db.collection(DATABASE_APPERTMENTS).addDocument(data: dict) { (error) in
            self.spinner.stopAnimating()
            print("2");
            if (error != nil){
                self.showAlertOk(title: "Error", message: error.debugDescription, vc: self)
            }
            else{
                self.resetFields()
                self.showAlertOk(title: "The Details Accepted!", message: "Your advertising will be published soon.", vc: self)
            }
        }
        print("3");
    }
    func showAlertOk(title:String ,message:String,vc:UIViewController){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
            
        }))
        vc.present(alert,animated: true);

    }

    
    @IBAction func btnSend(_ sender: Any) {
        guard let City = arrText[0].text else {return}
        
        if !isValidateTextFieldNotEmpty() {
            showAlertOk(title: "Missing Data", message: "Please fill all the data!", vc: self)
            return
        }
        sendData()
    }
    func actUploadImage(image:UIImage?,image2:UIImage?, completion: @escaping (String,String) -> Void) {
        print("actUploadImage")
    let storage = Storage.storage()
    let storageRef = storage.reference()
    var string1:String = ""
    var string2:String = ""
    let data =  image?.jpegData(compressionQuality: 1)
        let rand = Int64.random(in: 1..<900000000)

        let apartRefImage = storageRef.child("Apartments/apartment\(rand)jpg")

        if let data = data {
    let uploadTask = apartRefImage.putData(data, metadata: nil) {[weak self] (metadata, error) in
    guard let metadata = metadata else {
        guard let vc = self else {return}
      return
    }
        apartRefImage.downloadURL { (url, error) in

        guard let url = url else {
            print("Error while uploading")
            return}
        string1 = url.absoluteString
        let data2 =  image?.jpegData(compressionQuality: 1)
        if let data2 = data2 {
        let uploadTask = apartRefImage.putData(data2, metadata: nil) {(metadata, error) in
        guard let metadata = metadata else {
            guard let vc = self else {return}
          return
        }
        let size = metadata.size
            apartRefImage.downloadURL { (url, error) in
            guard let url = url else {
                return}
            string2 = url.absoluteString
            print("Finished")
            completion(string1,string2)
            self?.imageurl1 = string1
            self?.imageurl2 = string2
        }}
        }else {
            print("Finished")
            completion(string1,string2)
            self?.imageurl1 = string1
        }
    }}}else {
        completion(string1,string2)
    }}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc =  segue.destination as? UploadImageVC {
            print("true")
            vc.delegate = self
        }
    }
}
extension AddAppDetailsVC : UploadImageProtocol {
    func addImages(image: UIImage?, image2:UIImage?) {
        self.actUploadImage(image: image, image2: image2) {[weak self] (url1, url2) in
            self?.navigationController?.popViewController(animated: true)
            self?.imageurl1 = url1
            self?.imageurl2 = url2
            self?.showAlertOk(title:"Complete", message: "images upload completed", vc: self!)
        }
    }
    func lines(){
        for textFields in arrText{
            var bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: textFields.frame.height - 1, width: textFields.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.white.cgColor
            textFields.borderStyle = UITextField.BorderStyle.none
            textFields.layer.addSublayer(bottomLine)
        }
    }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }



