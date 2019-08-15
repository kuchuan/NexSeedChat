//
//  Message.swift
//  NexSeedChat
//
//  Created by 堀川浩二 on 2019/08/15.
//  Copyright © 2019 堀川浩二. All rights reserved.
//

import MessageKit

struct Message: MessageType {
    
    // 送信者
    let user: ChatUser
    
    // 本文
    let text: String
    
    // メッセージごとに振られた固有ID(messageKitではIDを必ずmessageId西ナイト駄目
    let messageId: String
    
    // 送信日時
    let sentDate: Date
    
    var sender: SenderType {
        return Sender(id: user.uid, displayName: user.name)
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
