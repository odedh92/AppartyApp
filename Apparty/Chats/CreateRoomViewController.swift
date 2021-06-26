//
//  CreateRoomViewController.swift
//  Apparty
//
//  Created by עודד האינה on 22/03/2021.
////
//
//import UIKit
//import FirebaseAuth
//
//class CreateRoomViewController: UIViewController{
//
//    @IBOutlet weak var titleTextField: UITextField!
//    @IBOutlet weak var roomImageView: UIImageView!
//    var apt : Apertment?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
//        let dialog = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        func handler(_ action:UIAlertAction){
//            let picker = UIImagePickerController()
//            picker.allowsEditing = true
//            if let title = action.title , title == "Camra" && UIImagePickerController.isSourceTypeAvailable(.camera){
//                picker.sourceType = .camera
//            }else{
//                picker.sourceType = .photoLibrary
//            }
//            self.present(picker, animated: true, completion: nil)
//        }
//        dialog.addAction(UIAlertAction(title: "Gallery", style: .default, handler:handler(_:)))
//        dialog.addAction(UIAlertAction(title: "Camera", style: .destructive, handler: handler(_:)))
//        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))//nil!
//
//        present(dialog, animated: true, completion: nil)
//    }
//    @IBAction func createRoom(_ sender: UIButton) {
//        guard let title = titleTextField.text , title.count > 0 else {
//            showLabel(title: "title must be no empty")
//           return
//        }
//
//        guard let user = Auth.auth().currentUser else {
//            showLabel(title: "Must be logged in")
//            return
//        }
//        sender.isEnabled = false
//        let room = ChatRoom(title: title, ownerId: user.uid , ownerName: "Oded", imageUrl: user.photoURL?.absoluteString ?? "", ownerId2: (apt?.Owner!)! , ownerName2: "Oded")
//        if let image = roomImageView.image{
//            room.save(image:image) { (error,succsess) in
//                if let err = error {
//                    print("ERROR",err.localizedDescription)
//                }
//                if succsess{
//                    showAlertOk(title: "Success", message: "Room Created", vc: self)
//                    self.navigationController?.popViewController(animated: true)
//                }else{
//                    self.showError(title: "Please try again")
//                    sender.isEnabled = true
//                }
//            }
//        }else{
//            room.save { (error,succsess) in
//                if let err = error {
//                    print("ERROR", err.localizedDescription)
//                }
//                if succsess{
//                    self.navigationController?.popViewController(animated: true)
//                }else{
//                    self.showError(title: "Please try again")
//                    sender.isEnabled = true
//                }
//            }
//        }
//    }
//
//}
//extension CreateRoomViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        if let image = info[.editedImage] as? UIImage{
//            self.roomImageView.image = image
//        }
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
//

