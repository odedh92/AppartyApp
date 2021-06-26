
//  UserDetailsViewController.swift
//  Apparty
//  Created by עודד האינה on 02/04/2021.

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UserDetailsViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var imageUrl:String?
    lazy var id:String = FirebaseAuth.Auth.auth().currentUser!.uid
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var ProfileImage: UIImageView!
    let picker = UIImagePickerController()
    @IBAction func btnProfilePic(_ sender: Any) {
        picker.delegate = self
        picker.allowsEditing = true
        let actionSheetDialog = UIAlertController(title: "Choose Profile Image",
                                                  message: nil, preferredStyle: .actionSheet)
        actionSheetDialog.addAction(UIAlertAction(title: "Gallery", style: .default, handler:takeAction1))
        actionSheetDialog.addAction(UIAlertAction(title: "Camera", style: .destructive, handler: takeAction))
        actionSheetDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        present(actionSheetDialog, animated: true)
    }
    
    func takeAction1(_ action: UIAlertAction){
        if action.title == "Gallery" && UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true)
    }
    func takeAction(_ action: UIAlertAction){
        if action.title == "Camera" && UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
           ProfileImage.contentMode = .scaleAspectFit
           ProfileImage.image = chosenImage
           picker.dismiss(animated: true, completion: nil)
       }
    
    @IBAction func seProfileData(_ sender: Any) {
        sendData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)

    }
    func sendData(){
        if let image  = ProfileImage.image{
            self.addImages(image: image)
        }
    }

    func sendDataToFireBase(dict:[String:Any]){
        let db = Firestore.firestore()
        db.collection(DATABASE_USER).document(id).setData(dict){ (error) in
            if (error != nil){
                DispatchQueue.main.async {
                    
                
                self.showAlertOk(title: "Error", message: error.debugDescription, vc: self)
                }
            }
            else{
                DispatchQueue.main.async {
                self.showAlertOk(title: "Enjoy!", message: "", vc: self)
                }
            }
        }
    }

func showAlertOk(title:String ,message:String,vc:UIViewController){
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
        
    }))
    vc.present(alert,animated: true);

}
    func actUploadImage(image:UIImage?, completion: @escaping (String) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var string:String = ""
        let data =  image?.jpegData(compressionQuality: 1)
            let rand = Int64.random(in: 1..<900000000)

            let apartRefImage = storageRef.child("Apartments/ProfilePic\(rand)jpg")
        if let data = data {
       apartRefImage.putData(data, metadata: nil) {[weak self] (metadata, error) in
        apartRefImage.downloadURL { (url, error) in

        guard let url = url else {
            print("Error while uploading")
            return}
        string = url.absoluteString
                apartRefImage.downloadURL { (url, error) in
                guard let url = url else {
                    return}
                string = url.absoluteString
                print("Finished")
                completion(string)
                self?.imageUrl = string
                }
            }}
            
        }else {
                completion(string)
            }}
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func addImages(image: UIImage?) {
        DispatchQueue.global(qos:.userInteractive).async {
        self.actUploadImage(image: image) {[weak self] (url) in
            DispatchQueue.main.async {
            self?.imageUrl = url
                guard let user = Auth.auth().currentUser else {
                    DispatchQueue.main.async {
                        if let vc = self {
                            vc.showAlertOk(title: "Error", message: "Please try again later", vc: vc)
                        }
                    }
                    return}
                let dictToSend = [
                    "full name":self?.txtName.text ?? "Guest",
                    "city":self?.txtCity.text ?? "UnKnown",
                    "email":self?.txtEmail.text ?? "",
                    "Image":self?.imageUrl ?? "No Url",
                    "Owner": user.uid,
                ] as [String : Any]
                DispatchQueue.global(qos: .userInteractive).async {
                self?.sendDataToFireBase(dict: dictToSend)
                }
                            
            }
           
        }
        }
    }
}

