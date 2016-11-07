//
//  LoginButton.swift
//  facebookpirata
//
//  Created by movil7 on 07/11/16.
//  Copyright © 2016 movil7. All rights reserved.
//

import UIKit

class LoginButton: UIButton {

    
    override func awakeFromNib() {
        layer.backgroundColor = UIColor(red: 255/255.0, green: 100/255.0, blue: 155/255.0, alpha: 1).cgColor
        layer.cornerRadius = 5
        layer.shadowColor = SHADOW_COLOR
        layer.shadowRadius = 5
        tintColor = UIColor.white
    
    }
    

}
