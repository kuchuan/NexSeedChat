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
        db.collection("messages").addDocument(data: [String : Any])
        
        
    }

}
