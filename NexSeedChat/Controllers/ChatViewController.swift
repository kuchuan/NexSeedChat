//
//  ChatViewController.swift
//  NexSeedChat
//
//  Created by 堀川浩二 on 2019/08/15.
//  Copyright © 2019 堀川浩二. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import InputBarAccessoryView //送信ボタンのBarをいろいろ触る

class ChatViewController: MessagesViewController {
    
    //全メッセージを保持する変数
    var  messages: [Message] = [] {
        //変数の中身が変わったら
        didSet{
            //画面を更新する
            messagesCollectionView.reloadData()
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        
        //　FirestoreDB接続
        let db = Firestore.firestore()
        
        
        // messageコレクションを監視する
        db.collection("messages").order(by: "sentDate").addSnapshotListener { (QuerySnapshot,
            Error) in
            
            guard let documents = QuerySnapshot?.documents else {
                return
            }
//            print("送信されました")

        
        
            var messages: [Message] = []
    //
            for document in documents {
                
                let uid = document.get("uid") as! String
                let name = document.get("name") as! String
                let photoUrl = document.get("photoUrl") as! String
                let text = document.get("text") as! String
                let sentDate = document.get("sentDate") as! Timestamp
                
                //クラスのインスタンス化
                //該当するmessageの送信者の作成
                let chatUser = ChatUser(uid: uid, name: name, photoUrl: photoUrl)
                let message = Message(user: chatUser, text: text, messageId: document.documentID, sentDate: sentDate.dateValue())
    //            (user: chatUser, text: text, messageId: document.documntID, sentDate: sentDate.dateValue())
                
                messages.append(message)
                
            
            }
            self.messages = messages
        }
        
    }
    
}


extension ChatViewController:  MessagesDataSource {
    func currentSender() -> SenderType {
        
        //現在ログインしている人を取得
        let user = Auth.auth().currentUser!
        //　ログイン中のユーザーのUID、displyNameを使って、messageKiｔ用に送信須屋の情報を作成
        return Sender(id: user.uid, displayName: user.displayName!)
    }
    
    //画面に表示するメッセージ
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    //画面に表示するメッセージの件数
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}

extension ChatViewController: MessagesLayoutDelegate {
    
}

extension ChatViewController: MessagesDisplayDelegate {
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner!
        
        if isFromCurrentSender(message: message) {
            
            //messageの送信者が自分の場合
            corner = .topRight
        } else {
            
            //messageが送信者の場合が自分の場合
            corner = .topLeft
        }
        
        return.bubbleTail(corner, .curved)
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        
        if isFromCurrentSender(message: message) {
            
            return UIColor(displayP3Red: 100/255, green: 100/255, blue: 255/255, alpha: 1.0)
        } else {
            return .brown
        }
        
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        //全メッセージのうち対象の一つを取得
        let message = messages[indexPath.section]
        
        //取得したmessageの送信者を取得
        let user = message.user
        
        //URL型に変換してurlに代入（ここ難しい）
        let url = URL(string: user.photoUrl)
        
        //　do chachブンはエラーが発生したときに
        do {
            // ＊エラーが発生する可能性があるものを書く
            //urlを元に画像のデータを取得
            let data = try Data(contentsOf: url!)
            //取得したデータを元に、ImageViewを作成
            let image = UIImage(data: data)
            // imageViewと名前を元にアバターアイコン作成
            let avatar = Avatar(image: image, initials: user.name)
            //　作ったアバターアイコンを画面に設置
            avatarView.set(avatar: avatar)
            return
        } catch let err {
            // ＊エラーが発生した場合に実行する処理
            print(err.localizedDescription)
        }
        
    }
    
}

extension ChatViewController: MessageCellDelegate {
    
}

//送信バーに関する設定
extension ChatViewController: InputBarAccessoryViewDelegate {
    
    //送信の
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        //ログインユーザーの取得
        let user = Auth.auth().currentUser!
        
        //Firebasse　に接続
        let db = Firestore.firestore()
        
        //firestioreにmessageや送信者の情報を交換
        db.collection("messages").addDocument(data: [
            "uid": user.uid,
            "name": user.displayName as Any,
            "photoUrl": user.photoURL?.absoluteString as Any,
            "text": text,
            "sentDate": Date() //送信した機器や、送信したその瞬間の日付
            ])
        
        inputBar.inputTextView.text = ""
    }

}
