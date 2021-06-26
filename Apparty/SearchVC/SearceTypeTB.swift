//
//  SearceTypeTB.swift
//  Apparty
//
//  Created by עודד האינה on 04/03/2021.
//

import Foundation
protocol SearceTypeTBDelagate {
    func SearceTypeTBDelagate(code:String)
}
class SearceType: UIViewController {
    @IBOutlet weak var TypeTv: UITableView!
        var delegate : SearceTypeTBDelagate! = nil
        var TypeArray: Array<String> = TypeSearch

    override func viewDidLoad() {
        super.viewDidLoad()
        TypeTv.register(UITableViewCell.self, forCellReuseIdentifier: "subtitleCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
    extension SearceType: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.TypeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = TypeArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.selectionStyle = .none

return cell
   }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        DispatchQueue.main.async {
            let str = self.TypeArray[indexPath.row]
            self.delegate.SearceTypeTBDelagate(code: str)
 
            self.dismiss(animated: true, completion: {()->Void in

            });
        }
    }
}

