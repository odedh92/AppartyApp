//
//  SearchRooms.swift
//  Apparty
//
//  Created by עודד האינה on 08/03/2021.
//

import Foundation
protocol SearceRoomsTBDelagate {
    func SearceRoomsTBDelagate(code:String)
}
class SearceRooms: UIViewController {
    @IBOutlet weak var RoomsTv: UITableView!
    var delegate : SearceRoomsTBDelagate! = nil
    var RoomsArray: Array<String> = RoomsSearch
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RoomsTv.register(UITableViewCell.self, forCellReuseIdentifier: "subtitleCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
}
    extension SearceRooms: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.RoomsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = RoomsArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.selectionStyle = .none

return cell
   }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        DispatchQueue.main.async {
            let str = self.RoomsArray[indexPath.row]
            self.delegate.SearceRoomsTBDelagate(code: str)
            self.dismiss(animated: true, completion: {()->Void in
            })
        }
    }

}


    

    
    
    
    
    

