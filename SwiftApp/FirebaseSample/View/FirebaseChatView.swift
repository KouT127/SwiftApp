//
//  FirebaseChatView.swift
//  SwiftApp
//
//  Created by kou on 2018/11/05.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseFirestore
import RealmSwift

class FirebaseChatView: MessagesViewController {
    
    var messageList: [Message] = []
    var prevSentDate: Date?
    var documentId: String?

    private let db = Firestore.firestore()
    private let accessor: Accessor = .shared
    private var uid: String?
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = accessor.realm.objects(AuthUser.self).first?.uid
        
        self.setFirebaseListener()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor.lightGray
        
        // メッセージ入力時に一番下までスクロール
        scrollsToBottomOnKeybordBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }
    
    
    // ここでFirebaseのメッセージ等を取得する。
    private func setFirebaseListener(){
        let documentId = self.documentId ?? ""
        db.collection("rooms")
            .document(documentId)
            .collection("messages")
            .order(by: "sentDate", descending: false)
            .addSnapshotListener{ snapShot, error in
                guard let value = snapShot else { return }
                value.documentChanges.forEach { diff in
                    if diff.type == .added || diff.type == .modified {
                        let data = diff.document.data()
                        guard let content = data["content"] as? String else { return }
                        guard let messageId = data["messageId"] as? String else { return }
                        guard let senderId = data["senderId"] as? String else { return }
                        guard let senderName = data["senderName"] as? String else { return }
                        guard let sentDate = data["sentDate"] as? Date else { return }
                    
                        let sender = senderId == self.uid ? self.currentSender() : Sender(id: senderId, displayName: senderName) 
                        let newMessage = Message(kind: MessageKind.text(content), sender: sender, messageId: messageId, content: senderName, date: sentDate)
                        self.messageList.append(newMessage)
                        self.messagesCollectionView.insertSections([self.messageList.count - 1])
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom()
                    }
                }
        }
    }
    
//    func createMessage(text: String) -> MockMessage {
//        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
//                                                                           .foregroundColor: UIColor.black])
//        return MockMessage(attributedText: attributedText, sender: otherSender(), messageId: UUID().uuidString, date: Date())
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FirebaseChatView: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: uid ?? "", displayName: "Kou")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    // 日毎に表示
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if let prevSentData = prevSentDate {
            if prevSentData > message.sentDate {
                self.prevSentDate = message.sentDate
                return cellTopReturnString(date: message.sentDate)
            }
            return nil
        } else {
            prevSentDate = message.sentDate
            return cellTopReturnString(date: message.sentDate)
        }
    }
    
    private func cellTopReturnString(date: Date) -> NSAttributedString {
        return NSAttributedString(
            string: MessageKitDateFormatter.shared.string(from: date),
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                         NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }
    
    // メッセージの上に文字を表示
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    // メッセージの下に文字を表示
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = message.sentDate.toString("HH:mm", timeZone: true)//formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

extension FirebaseChatView: MessagesDisplayDelegate {
    
    // メッセージの色を変更
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    // メッセージの背景色を変更している
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ?
            UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) :
            UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    // メッセージの形を設定
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
    // アイコンの設定
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //TODO: 画像
        let avatar = Avatar(initials: String(message.sender.displayName.prefix(1)))
        avatarView.set(avatar: avatar)
    }
}


// 各ラベルの高さを設定
extension FirebaseChatView: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension FirebaseChatView: MessageCellDelegate {
    //画像やUrlで遷移用
//    func didTapMessage(in cell: MessageCollectionViewCell) {
//        print("Message tapped")
//    }
}

extension FirebaseChatView: MessageInputBarDelegate {
    // メッセージ送信ボタンをタップした時の挙動
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                
                let message: [String: Any] = ["content":text,
                                              "messageId": "123",
                                              "senderId": uid ?? "",
                                              "senderName":"Kou",
                                              "sentDate": FieldValue.serverTimestamp()]
                
                db.collection("rooms")
                    .document(documentId ?? "")
                    .collection("messages")
                    .addDocument(data: message)
                
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                                   .foregroundColor: UIColor.white])
                let displayMessage = Message(kind: .attributedText(attributedText), sender: currentSender(), messageId: UUID().uuidString, content: text, date: Date())//Message(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
//                messageList.append(displayMessage)
//                messagesCollectionView.insertSections([messageList.count - 1])
            }
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
}

//if let image = component as? UIImage {
//    
//    let imageMessage = Message(image: image, sender: currentSender(), messageId: UUID().uuidString, date: Date())
//    messageList.append(imageMessage)
//    messagesCollectionView.insertSections([messageList.count - 1])
//    
//} else 
