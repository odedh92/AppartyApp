//
//  ChatMessagesViewController.swift
//  Apparty
//
//  Created by עודד האינה on 22/03/2021.
//
import FirebaseFirestore
import UIKit
import FirebaseUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MessageKit
import InputBarAccessoryView

class ChatMessagesViewController: MessagesViewController {
   
    var room : ChatRoom?
    var messages = [ChatMessage]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        
        let button = UIButton(type: .system)
        button.setTitle("📸", for: .normal)
        button.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        
        self.messageInputBar.leftStackView.addArrangedSubview(button)
        self.messageInputBar.setLeftStackViewWidthConstant(to: 40, animated: false)
        
        loadMessages()
    }
    
    @objc func takePhoto(_ sender: UIButton){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    func loadMessages() {
        room?.messagesRef.queryOrdered(byChild: "sentDate").observe(.childAdded, with: { (snapshop) in
            guard let dict  = snapshop.value as? [String:Any], let message  = ChatMessage(dict: dict) else {return}
            self.messages.append(message)
            self.messagesCollectionView.reloadData()
        })
    }
    deinit {
        room?.messagesRef.removeAllObservers()
    }
}
extension ChatMessagesViewController : MessagesDataSource {
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func currentSender() -> SenderType {

        guard let user = Auth.auth().currentUser else {
            return Sender(senderId: currentSender().senderId , displayName:currentSender().displayName ) // סטרינגים ריקים  במקום
        }
        return Sender(senderId: user.uid , displayName: user.displayName ?? "")
    }
}
extension ChatMessagesViewController : MessagesLayoutDelegate {
    
}
extension ChatMessagesViewController : MessagesDisplayDelegate {
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let id = Auth.auth().currentUser?.uid else {return}
        var realOwner = id
        if message.sender.senderId != id {
            realOwner = message.sender.senderId
        }
        let utils = FirebaseUtils()
        utils.getUserImage(with: realOwner) { (image) in
            DispatchQueue.main.async {
                avatarView.image = image
            }
        }
        
    }
}
    
extension ChatMessagesViewController : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.inputTextView.text = ""
        inputBar.inputTextView.resignFirstResponder()
        
        let message = ChatMessage(text: text)
        if let room = self.room {
            message.save(in: room)
        }
    }
}

extension ChatMessagesViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[.imageURL]
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
