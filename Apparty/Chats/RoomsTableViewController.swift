//
//  RoomsTableViewController.swift
//  Apparty
//
//  Created by עודד האינה on 22/03/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RoomsTableViewController: UITableViewController {

    var rooms: [ChatRoom]?
    var toOpen:ChatRoom?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UITableViewHeaderFooterView()
//        let marginGuide = header.contentView
//        let label = UILabel()
//        self.tableView.sectionHeaderHeight = 70
//        label.text = "AppartyChat"
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        header.contentView.backgroundColor = Constants.refs.appColor
//        header.backgroundView = nil
//        header.backgroundColor = Constants.refs.appColor
//        header.contentView.addSubview(label)
//        var constraint = label.widthAnchor.constraint(equalToConstant: 220)
//        constraint.isActive = true
//        constraint = label.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor)
//        constraint.isActive = true
//        constraint = label.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor)
//        constraint.isActive = true
//        return header
//    }
    func openRoom(toOpen:ChatRoom) {
        performSegue(withIdentifier: SegueToChatRoom_new, sender: toOpen)
        self.toOpen = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        if let uid = FirebaseAuth.Auth.auth().currentUser?.uid {
            ChatRoom.chatRooms(uid:uid) { (rooms) in
                self.rooms = rooms
                
                self.tableView?.reloadData()
            }
        }
        if let toOpen = toOpen {
            openRoom(toOpen: toOpen)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RoomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomTableViewCell
        cell.populate(room: (rooms?[indexPath.row])!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueToChatRoom_new, sender: rooms?[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueName = segue.identifier {
            
            switch segueName {
            case SegueToChatRoom:
                
                let chatVC = segue.destination as! ChatContainerVC
                chatVC.room = sender as? ChatRoom
                break
                
            case SegueToChatRoom_new:
                
                let chatVC = segue.destination as! ChatMessagesViewController
                chatVC.room = sender as? ChatRoom
                break
            default:
                break
            }
        }
    }
}
