//
//  ViewController.swift
//  facebookpirata
//
//  Created by movil7 on 04/11/16.
//  Copyright © 2016 movil7. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        navigationController?.navigationBar.isHidden = true
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginFacebook(_ sender: UIButton) {
        let loginMannager = FBSDKLoginManager()
        loginMannager.logIn(withReadPermissions: ["email"], from: self) { result, error in
//            print(user)
//            if let user = user, user.isCancelled {
//                print("el usuario a cancelado el Login Por Facebook")
//            }
            
            if error != nil{
                print("No se pudo completar por facebook")
            } else if result?.isCancelled == true {
                print("el usuario a cancelado el Login Por Facebook")
            } else {
                print("login exitoso con facebook")
                
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(_credential: credentials)
                
            }
            
            
        }
    }
    
    func firebaseAuth(_credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: _credential,completion: {
        user, error in
            
            if error != nil{
                print("No se pudo autenticar con FireVase: Error\(error.debugDescription)")
            } else {
                print("se autentico con firebase")
            }
        
        })
        
    }
    
}

