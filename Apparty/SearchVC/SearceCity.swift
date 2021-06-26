//
//  SearceCity.swift
//  Apparty
//
//  Created by עודד האינה on 08/03/2021.
//

import Foundation
protocol SearceCityTBDelagate {
    func SearceCityTBDelagate(code:String)
}
class SearceCity: UIViewController {
    @IBOutlet weak var cityTv: UITableView!
           var delegate : SearceCityTBDelagate! = nil
           var CityArray: Array<String> = CitySearch

    override func viewDidLoad() {
        super.viewDidLoad()
        cityTv.register(UITableViewCell.self, forCellReuseIdentifier: "subtitleCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
}
    extension SearceCity: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.CityArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = CityArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.selectionStyle = .none

return cell
   }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            DispatchQueue.main.async {
                let str = self.CityArray[indexPath.row]
                self.delegate.SearceCityTBDelagate(code:str)
                self.dismiss(animated: true, completion: {()->Void in
                });
            }
        }
    }
