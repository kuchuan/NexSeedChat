//
//  LoginViewController.swift
//  NexSeedChat
//
//  Created by 堀川浩二 on 2019/08/15.
//  Copyright © 2019 堀川浩二. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        GIDSignIn.sharedInstance()?.uiDelegate = self
//        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    


}

extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //ここはネットに書いてある！
        //エラーの確認をする（そもそも機能のエラー）
        //オプショナルバインディングで上記のError!
        if let error = error {
            // errorがnilでない場合（エラーがある場合）
            print("Google Sing Inでエラーが発生しました")
            print(error.localizedDescription) //エラーの情報がわかる
            return //処理の中断
        }
        
        //GooglesignInの準備（トークンの取得、ユーザー情報音取得･･･SNSで認証するときに）
        //ユーザー情報取得（下記のuserにはすでにユーザーがｓ入っている）
        let authentication = user.authentication
        //Googleのトークンの取得
        let credential = GoogleAuthProvider.credential(withIDToken: authentication!.idToken, accessToken: authentication!.accessToken)
        
        //Googleでログインする。firebaseににログイン情報を書き込む
        Auth.auth().signIn(with: credential) { (authDataResoult, error) in
            
            if let error = error {
                print("ログイン失敗")
                print(error.localizedDescription)
            } else {
                print("ログイン成功")
                self.performSegue(withIdentifier: "toChat", sender: nil)
            }
        }
    }
    
    
}
