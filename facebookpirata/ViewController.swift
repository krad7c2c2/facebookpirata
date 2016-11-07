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
import SwiftKeychainWrapper



class ViewController: UIViewController {

    
    
    @IBOutlet weak var txtEmail: SexiTextField!
    @IBOutlet weak var txtContrasena: SexiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        navigationController?.navigationBar.isHidden = true
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
        if KeychainWrapper.standard.string(forKey: "EMAIL_UID") != nil ||  KeychainWrapper.standard.string(forKey: "FACE_UID") != nil {
            
        print("ya estabas logueado MMM")
        }
        
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
                KeychainWrapper.standard.set((user?.email)!, forKey: "FACE_UID")

            }
        
        })
        
    }
    
    
    @IBAction func botonLogin(_ sender: UIButton) {
        
        if let correo = txtEmail.text, let contrasena = txtContrasena.text {
        
            FIRAuth.auth()?.createUser(withEmail: correo, password: contrasena, completion: {
            user, error in
                
                if error != nil, let err = error as? NSError {
                    if err.code == ERROR_PASSWORD_NOT_LONG {
                        print("ingrear uno de mas de 6 caracteres")
                    } else if err.code == ERROR_ACCOUNT_ALREDY_USE {
                        print("la cuenta de correo ya esta siendo usado")
                       
                        FIRAuth.auth()?.signIn(withEmail: correo, password: contrasena, completion: {
                            user, error in
                            if error != nil, let err = error as? NSError {
                                if err.code == ERROR_INVALID_PASSWORD {
                                    print("El password ingresado no es valido")
                                } else {
                                    //ir al siguiente VC
                                    print("login email exitoso")
                                    KeychainWrapper.standard.set(correo, forKey: "EMAIL_UID")
                                }
                            } else {
                                //ir al siguiente VC
                                print("login email exitoso")
                                KeychainWrapper.standard.set(correo, forKey: "EMAIL_UID")
                            }
                        })
                        
                    }
                } else {
                    print("usuario\(user?.displayName)")
                    KeychainWrapper.standard.set(correo, forKey: "EMAIL_UID")
                    //ir al siguiente VC
                }
            
            })
            
        } else {
            print("facor de introducir usuario o contraseña")
        }
        
    }
    
    
}

