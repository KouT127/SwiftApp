//
//  FirebaseChatView[.swift
//  SwiftApp
//
//  Created by kou on 2018/11/05.
//  Copyright © 2018 kou. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseFirestore

class FirebaseChatView: MessagesViewController {
    
    var messageList: [Message] = []
    var prevSentDate: Date?
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            // messageListにメッセージの配列をいれて
            self.messageList = self.getMessages()
            // messagesCollectionViewをリロードして
            self.messagesCollectionView.reloadData()
            // 一番下までスクロールする
            self.messagesCollectionView.scrollToBottom()
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor.lightGray
        
        // メッセージ入力時に一番下までスクロール
        scrollsToBottomOnKeybordBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        let roomReference = db.collection("rooms")
        //docの名前
        let roomDocRef = roomReference.document("dXS1HoTFRwI3NaDxjZQS").collection("messages")
        roomDocRef.getDocuments{ (documents, error) in
            if let documents = documents {
                print(documents.documentChanges.first?.document.data())
                //                let i = document.dictionaryWithValues(forKeys: ["content", "senderName"])
            } else {
                print("Document does not exist")
            }
        }
//        reference = roomDocRef.collection("messages")
        
        //reference = db.collection(["rooms", id, "messages"].joined(separator: "/"))

    }
    
    
    // ここでFirebaseのメッセージ等を取得する。
    func getMessages() -> [Message] {
        let firestore = Firestore.firestore()
        var messages: [Message] = []
        firestore.collection("rooms").document("dXS1HoTFRwI3NaDxjZQS").collection("messages").addSnapshotListener{ snapShot, error in
            guard let value = snapShot else { return }
            value.documentChanges.forEach { diff in
                if diff.type == .added {
                    let chatDatas = diff.document.data()
                    let chatData = chatDatas
                    guard let content = chatData["content"] as? String else { return }
                    guard let messageId = chatData["messageId"] as? String else { return }
                    guard let senderName = chatData["senderName"] as? String else { return }
                    guard let sentDate = chatData["sentDate"] as? Date else { return }
                    
                    let newMessage = Message(kind: MessageKind.text(content), sender: Sender(id: "1", displayName: senderName), messageId: messageId, content: senderName, date: sentDate)
                    print("newMessage:\(newMessage)")
                    messages.append(newMessage)
                }
            }
        }
        return messages
    }
    
//    func createMessage(text: String) -> MockMessage {
//        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
//                                                                           .foregroundColor: UIColor.black])
//        return MockMessage(attributedText: attributedText, sender: otherSender(), messageId: UUID().uuidString, date: Date())
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func save(_ message: Message) {
        reference?.addDocument(data: ["content": "value"]) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
        }
    }
}

extension FirebaseChatView: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: "123", displayName: "Kou")
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
                
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                                   .foregroundColor: UIColor.white])
                let message = Message(kind: .attributedText(attributedText), sender: currentSender(), messageId: UUID().uuidString, content: text, date: Date())//Message(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                messageList.append(message)
                messagesCollectionView.insertSections([messageList.count - 1])
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
