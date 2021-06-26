

import UIKit

protocol CountryListTableView_Delegate {
    func CountryListTableView_didSelectCode(code:String)
}

class CountryListTableView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var delegate : CountryListTableView_Delegate! = nil
    var dataArray: Array<Dictionary<String, String>> = CountryCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "subtitleCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension CountryListTableView : UITableViewDelegate,UITableViewDataSource
{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        
          let dict = self.dataArray[indexPath.row]
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = dict["name"]
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.text = dict["dial_code"]
        cell.detailTextLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        
        
return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        DispatchQueue.main.async {
            let dict = self.dataArray[indexPath.row]
           self.delegate?.CountryListTableView_didSelectCode(code: dict["dial_code"]!)
            self.dismiss(animated: true, completion: {()->Void in
            });
            
        }
        
        
    }
    
}

