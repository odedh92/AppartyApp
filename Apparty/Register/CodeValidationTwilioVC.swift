//
//  CodeValidationTwilioVC.swift
//  Apparty
//
//  Created by Oded haina on 03/02/2021.
//

import UIKit
import Firebase
class CodeValidationTwilioVC: BaseRegisterVC {

    var verificationID : String = ""
    @IBOutlet weak var txtCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func actSendCode(_ sender: Any) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",verificationCode: txtCode.text!)
        Auth.auth().signIn(with: credential) { (resultData, error) in
            if ((error) != nil) {
              return
            }
        }
    }
}
