
import UIKit

class BaseRegisterVC: UIViewController ,UIPopoverPresentationControllerDelegate, CountryListTableView_Delegate{

    @IBOutlet weak var constraintBottomButton: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - KEYBOARD notification
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if constraintBottomButton.constant == 20
            {
                constraintBottomButton.constant = keyboardSize.height + 8
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if constraintBottomButton.constant != 20
            {
                constraintBottomButton.constant = 20
                self.view.layoutIfNeeded()
            }
            
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func showPopover(sender: AnyObject) {
        
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "CountryListVC") as! CountryListTableView
        
        popoverContent.modalPresentationStyle = .popover
        
        if let popover = popoverContent.popoverPresentationController {
            
            let viewForSource = sender as! UIView
            popover.sourceView = viewForSource
            popover.sourceRect = viewForSource.bounds
            popoverContent.preferredContentSize = CGSize(width: 250, height: 200)
            popoverContent.delegate=self
            popover.delegate = self
        }
        
        self.present(popoverContent, animated: true, completion: nil)
        
    }
    func CountryListTableView_didSelectCode(code: String) {
        print("Selected country")
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
