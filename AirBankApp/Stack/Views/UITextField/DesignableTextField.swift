//
//  DesignableTextField.swift
//  UpDigital
//
//  Created by e.d.neutrum on 24/09/2018.
//  Copyright © 2018 Qest. All rights reserved.
//
import UIKit

@IBDesignable

class DesignableTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDoneButtonOnKeyboard()
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
//    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//        var textRect = super.rightViewRect(forBounds: bounds)
//
//    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateLeftView()
        }
    }
    
    
    @IBInspectable var rightText: String? {
        didSet {
            updateRightViewText()
        }
    }
    
    func updateLeftView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    func updateRightView() {
        if let image = rightImage {
            let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 23, y: 0, width: 12, height: 40))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            rightViewContainer.addSubview(imageView)
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            rightView = rightViewContainer
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
    
    func updateRightViewText() {
        if let textToRight = rightText {
            let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
            rightViewMode = UITextField.ViewMode.always
//            let imageView = UIImageView(frame: CGRect(x: 23, y: 0, width: 12, height: 40))
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = image
            let labelView = UILabel(frame: CGRect(x: 23, y: 0, width: 55, height: 40))
            labelView.text = textToRight
            labelView.contentMode = .center
            labelView.font = labelView.font.withSize(12)
            labelView.textColor = UIColor.lightGray
            rightViewContainer.addSubview(labelView)
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            rightView = rightViewContainer
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
