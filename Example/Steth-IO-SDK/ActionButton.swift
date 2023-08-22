//
//  ActionButton.swift
//  Example
//
//  Created by alex on 8/19/23.
//  Copyright © 2023 StethIO. All rights reserved.
//

import UIKit

class ActionToolBar: UIView{
    @IBOutlet var buttonStart: ActionButton!
    @IBOutlet var buttonStop: ActionButton!
    @IBOutlet var buttonCancel: ActionButton!
    @IBOutlet var buttonRestart: ActionButton!
    
    
    func isActive(_ enable: Bool) {
        buttonStart.isActive = enable
        buttonStop.isActive = enable
        buttonCancel.isActive = enable
        buttonRestart.isActive = enable
    }
    func reset() {
        self.buttonStart.setTitle("start", for: .normal)
    }
}

@IBDesignable
class ActionButton: UIButton{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
    
    var isActive: Bool{
        set{
            isEnabled = newValue
            alpha = newValue ? 1 : 0.25
        }
        get { isEnabled }
    }
}
