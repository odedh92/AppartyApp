

import UIKit

protocol TermsVC_Delegate {
    func TermsVC_Accepted(bool:Bool)
}


class TermsVC: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblTop: UILabel!
     var delegate : TermsVC_Delegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
      
    @IBAction func actAccept() {
        delegate?.TermsVC_Accepted(bool: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actCancel() {
        delegate?.TermsVC_Accepted(bool: false)
    self.dismiss(animated: true, completion: nil)
    }
    
}
