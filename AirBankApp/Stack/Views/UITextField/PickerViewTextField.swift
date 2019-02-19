//
//  PickerViewTextField.swift
//  Volvista
//
//  Created by Marek Hajducak on 18/10/2018.
//  Copyright © 2018 Qest. All rights reserved.
//

import UIKit

protocol UpdateSettingsDelegate: class {
    func didTouchDone()
}

class PickerViewTextField: DesignableTextField, UIPickerViewDelegate  {
    
    var updateDelegate: UpdateSettingsDelegate?
    
    let pickerView = UIPickerView()
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputView = pickerView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/6, width: UIScreen.main.bounds.width, height: 50.0))
        toolBar.layer.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - 20.0)
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.lightGray
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed))
        doneButton.tintColor = UIColor.black
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        self.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        updateDelegate?.didTouchDone()
        resignFirstResponder()
    }
    
}

