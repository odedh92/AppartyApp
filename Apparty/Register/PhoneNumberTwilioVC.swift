

import UIKit
import FirebaseAuth

class PhoneNumberTwilioVC: BaseRegisterVC {
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnPrefix: UIButton!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var btnSeletedApproveTrems: UIButton!
    
    @IBOutlet weak var txtUserName: UITextField!
    var didApprove = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupLayout(){
       
    }
    @IBAction func actOpenTerms(_ sender: Any) {
        self.performSegue(withIdentifier: SegueToTerms, sender: nil)
    }
    @IBAction func actSendPhone() {
        let prefix : String = (btnPrefix.titleLabel?.text)!
        
        if !didApprove
        {
            showAlertOk(title: "Terms and Condition", message: "You must approve terms and condition in order to use Apparty App",vc: self)
            return
        }
        let phoneNumber = prefix+txtPhoneNumber.text!
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate:nil) {
                                                                    verificationID, error in
            if ((error) != nil) {
              return
            }
            self.performSegue(withIdentifier: Segue_To_CodeValidation, sender: verificationID)
    }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueName = segue.identifier {
            switch segueName {
            case SegueToTerms:
                let termsVC  = segue.destination as! TermsVC
                termsVC.delegate = self ;
                break
            case Segue_To_CodeValidation :
                let validateVC  = segue.destination as! CodeValidationTwilioVC
                validateVC.verificationID = sender as! String
                break
            default:
                break
            }
        }
        
    }
    override func CountryListTableView_didSelectCode(code: String) {
        print("Selected country")
        btnPrefix.setTitle(code, for: .normal)
        
    }
}
extension PhoneNumberTwilioVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
extension PhoneNumberTwilioVC : TermsVC_Delegate
{
    func TermsVC_Accepted(bool: Bool) {
        if bool
        {
            btnSeletedApproveTrems.setImage(#imageLiteral(resourceName: "icons8-check_all"), for: .normal)
            didApprove = true
        }
        else
        {
            btnSeletedApproveTrems.setImage(#imageLiteral(resourceName: "icons8-unchecked_checkbox"), for: .normal)
            didApprove = false
        }
    }
}
