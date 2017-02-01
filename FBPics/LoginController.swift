//
//  LoginController.swift
//  FBPics
//
//  Created by Sudhanshu Ambadipudi on 1/19/17.
//  Copyright © 2017 Sudhanshu Ambadipudi. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 5
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if FBSDKAccessToken.current() != nil {
            let logOut = sender.titleLabel?.text
            if logOut == "Log Out" {
                sender.setTitle("Tap to Log In", for: .normal)
                FBSDKLoginManager().logOut()
                
            }
            return
        }
        let login = FBSDKLoginManager()
        let permissions = ["email", "public_profile", "user_photos"]
        login.logIn(withReadPermissions: permissions, from: self, handler: { (result, error) -> Void in
            if(error != nil){
                FBSDKLoginManager().logOut()
            } else if(result?.isCancelled)!{
                FBSDKLoginManager().logOut()
            } else{
                sender.setTitle("Log Out", for: .normal)
                self.performSegue(withIdentifier: "loadingSegue", sender: self)
            }
        })
    }
    
}

