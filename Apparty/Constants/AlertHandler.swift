

import Foundation
import UIKit


func showAlertOk(title:String ,message:String,vc:UIViewController){
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
        
    }))
    vc.present(alert,animated: true);

}
