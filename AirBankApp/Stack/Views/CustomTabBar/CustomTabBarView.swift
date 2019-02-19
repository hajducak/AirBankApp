//
//  CustomTabBarView.swift
//  DevStack
//
//  Created by Viktor Kaderabek on 04/08/2017.
//  Copyright © 2017 Qest. All rights reserved.
//

// Do not fix missing constraints in .xib, otherwise the stack view won't adjust properly

import UIKit

protocol CustomTabBarViewDelegate: class {
    func selectViewController(tag: Int)
}

class CustomTabBarView: XIBView {
    
    var shouldShowNumbers: Bool = false
    
    var buttonMainLabelFont: UIFont = UIFont.systemFont(ofSize: 16)
    var buttonMainLabelFontHighlighted: UIFont = UIFont.systemFont(ofSize: 16)
    
    var buttonMainLabelColor: UIColor = UIColor.white
    var buttonMainLabelColorHighlighted: UIColor = UIColor.white
    
    var buttonNumberLabelFont: UIFont = UIFont.systemFont(ofSize: 16)
    var buttonNumberLabelFontHighlighted: UIFont = UIFont.systemFont(ofSize: 16)
    
    var buttonNumberLabelColor: UIColor = UIColor.white
    var buttonNumberLabelColorHighlighted: UIColor = UIColor.white
    
    var buttonNumberViewBackgroundColor: UIColor = UIColor.clear
    var buttonNumberViewBackgroundColorHighlighted: UIColor = UIColor.clear
    
    var buttonBackgroundColor: UIColor = UIColor.clear
    var buttonBackgroundColorHighlighted: UIColor = UIColor.clear
    
    var stripViewColor: UIColor = UIColor.orange {
        didSet {
            stripView?.backgroundColor = stripViewColor
        }
    }
    var stripViewHeight : CGFloat = 4 {
        didSet {
            stripViewHeightConstratint?.constant = stripViewHeight
        }
    }
    
    @IBOutlet weak var stripViewHeightConstratint: NSLayoutConstraint! {
        didSet {
            stripViewHeightConstratint.constant = stripViewHeight
        }
    }
    
    @IBOutlet weak var stripView: UIView! {
        didSet {
            stripView.backgroundColor = stripViewColor
        }
    }
    
    weak var delegate : CustomTabBarViewDelegate?
    
    var tabBarButtons : Array<CustomTabBarButton> = []
    
    var icons : [UIImage] = []
    
    var availableOptions : Array<String> = [] {
        didSet {
            addButtons(titles: availableOptions, images: icons)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var leadingConstraintStripView: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintStripView: NSLayoutConstraint! 
    
    // MARK: - Initialization process
    
    override var nibName: String {
        get {
            return CustomTabBarView.nameOfClass
        }
    }
    
    override func configureViews() {
        widthConstraintStripView.constant = scrollView.contentSize.width / max(CGFloat(tabBarButtons.count), 1)
    }
    
    func select(_ index: Int, animated: Bool = false) {
        if tabBarButtons.count > index {
            selectViewController(tabBarButtons[index], animated: animated)
        }
    }
    
    private func removeButtonsFromStackView() {
        for view in buttonsStackView.arrangedSubviews {
            buttonsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        tabBarButtons = []
    }
    
    private func addButtons(titles: Array<String>, images: [UIImage]) {
        
        removeButtonsFromStackView()
        
        for (index, title) in titles.enumerated() {
            let btn = CustomTabBarButton()
            btn.mainLabel.text = NSLocalizedString(title, comment: "")
            btn.mainLabel.font = buttonMainLabelFont
            btn.mainLabel.textColor = buttonMainLabelColor
            btn.iconImageView.image = images[index]
            if index == 2 {
                btn.iconViewWidth.constant = 27
            } else {
                btn.iconViewWidth.constant = 24
            }
            btn.view.backgroundColor = buttonBackgroundColor
            btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.btnSelected(_:))))
            btn.tag = index
            buttonsStackView.addArrangedSubview(btn)
            tabBarButtons.append(btn)
        }
    }
    
    @objc private func btnSelected(_ sender: UITapGestureRecognizer? = nil) {
        if let btn = sender?.view as? CustomTabBarButton, !btn.button.isSelected {
            selectViewController(btn, animated: true)
        }
    }
    
    func selectViewController(_ sender: CustomTabBarButton, animated: Bool) {
        for btn in tabBarButtons {
            if btn == sender {
                btn.button.isSelected = true
                btn.mainLabel.font = buttonMainLabelFontHighlighted
                btn.mainLabel.textColor = buttonMainLabelColorHighlighted
                btn.view.backgroundColor = buttonBackgroundColorHighlighted
                leadingConstraintStripView.constant = btn.frame.origin.x
                scrollToButton(btn)
            } else {
                btn.button.isSelected = false
                btn.mainLabel.font = buttonMainLabelFont
                btn.mainLabel.textColor = buttonMainLabelColor
                btn.view.backgroundColor = buttonBackgroundColor
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: { [weak self] in
                self?.layoutIfNeeded()
                }, completion: nil)
        }
        
        delegate?.selectViewController(tag: sender.tag)
    }
    
    private func scrollToButton(_ btn: CustomTabBarButton) {
        var x = btn.frame.origin.x + btn.frame.width / 2 - UIScreen.main.bounds.width / 2
        if x < 0 {
            x = 0
        } else if x > scrollView.contentSize.width - view.bounds.width {
            x = scrollView.contentSize.width - view.bounds.width
        }
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
//    func updateNumbers(_ numbers: [Int]) {
//        for index in 0...tabBarButtons.count-1 {
//            if numbers.count > index {
//                tabBarButtons[index].numberLabel.text = numbers[index] <= 999 ? "\(numbers[index])" : "999"
//            }
//        }
//        layoutIfNeeded()
//        widthConstraintStripView.constant = scrollView.contentSize.width / max(CGFloat(tabBarButtons.count), 1)
//    }
}
