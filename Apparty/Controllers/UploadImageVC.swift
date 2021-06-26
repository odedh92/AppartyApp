import UIKit
import FirebaseStorage
protocol UploadImageProtocol {
    func addImages(image:UIImage?,image2:UIImage?)
}


struct Apartment {
    
}
class UploadImageVC: UIViewController{
    let picker1 = UIImagePickerController()
    let picker2 = UIImagePickerController()
    
    @IBAction func btnFinish(_ sender: Any) {
        if let image  = imageview1.image, let image2 = imageview2.image {
            delegate?.addImages(image: image, image2: image2)
            showAlertOk(title: "Please wait", message: "While your photos are uploading", vc: self)
        }
    }
    @IBOutlet weak var imageview2: UIImageView!
    @IBOutlet weak var imageview1: UIImageView!
    weak var selectedImage : UIImageView?
    
    
    var delegate:UploadImageProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
     
        picker1.delegate = self
        picker1.allowsEditing = true
        picker2.delegate = self
        picker2.allowsEditing = true
        imageview1.isUserInteractionEnabled = true
        imageview2.isUserInteractionEnabled = true
        imageview1?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChangePic1)))
        
        imageview2?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChangePic2)))
        
    }
    @objc func ChangePic2() {
        let actionSheetDialog = UIAlertController(title: "Choose Source",
                                                  message: nil, preferredStyle: .actionSheet)
        actionSheetDialog.addAction(UIAlertAction(title: "Gallery", style: .default, handler:takeAction))
        actionSheetDialog.addAction(UIAlertAction(title: "Camera", style: .destructive, handler: takeAction2))
        actionSheetDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))//nil!
        
        present(actionSheetDialog, animated: true)
    }
    @objc func ChangePic1() {
        let actionSheetDialog = UIAlertController(title: "Choose Source",
                                                  message: nil, preferredStyle: .actionSheet)
        actionSheetDialog.addAction(UIAlertAction(title: "Gallery", style: .default, handler:takeAction))
        actionSheetDialog.addAction(UIAlertAction(title: "Camera", style: .destructive, handler: takeAction2))
        actionSheetDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))//nil!
        present(actionSheetDialog, animated: true)
    }
    func takeAction(_ action: UIAlertAction){
        if action.title == "Gallery" && UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            picker1.sourceType = .photoLibrary
        }
        present(picker1, animated: true)
    }
    func takeAction2(_ action: UIAlertAction){
        if action.title == "Camera" && UIImagePickerController.isSourceTypeAvailable(.camera){
            picker2.sourceType = .camera
        }
        present(picker2, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            if picker == picker1 {
                imageview1?.contentMode = .scaleAspectFit
                imageview1?.image = chosenImage
            }else {
                imageview2?.contentMode = .scaleAspectFit
                imageview2?.image = chosenImage
            }
           picker.dismiss(animated: true, completion: nil)
       }
}
extension UploadImageVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
}

  

