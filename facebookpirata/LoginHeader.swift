//
//  LoginHeader.swift
//  facebookpirata
//
//  Created by movil7 on 07/11/16.
//  Copyright © 2016 movil7. All rights reserved.
//

import UIKit

class LoginHeader: UIView {

    override func awakeFromNib() {
        
        layer.shadowColor = SHADOW_COLOR
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 1.0
        
        
    }

}
