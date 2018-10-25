//
//  NMDatePickerController.swift
//  NMDatePickerDemo
//
//  Created by Natalia Macambira on 21/05/17.
//  Copyright © 2017 Natalia Macambira. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public protocol NMDatePickerDelegate {
    func datePickerSelectButtonAction(dateSelected: Date)
    func datePickerCancelButtonAction()
}

final public class NMDatePickerController: UIView {
    
    private var delegate: NMDatePickerDelegate?
    private var backgroundView: UIView!
    private var contentView = UIView()
    private var views: [String: Any] = [:]
    public var blurEffect: Bool = false
    public var blurEffectStyle: UIBlurEffectStyle = UIBlurEffectStyle.light
    public var titleLabel: UILabel = UILabel()
    public var datePicker: UIDatePicker!
    public var nowButton: UIButton = UIButton(type: .system)
    public var cancelButton: UIButton = UIButton(type: .system)
    public var selectButton: UIButton = UIButton(type: .system)
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(delegate: NMDatePickerDelegate?) {
        super.init(frame: CGRect.zero)
        
        self.delegate = delegate
        self.datePicker = UIDatePicker()
        self.setupView()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        configVerticalConstraintsOfHiddenViews()
        
        DispatchQueue.main.async {
            self.titleLabel.roundCorners(corners: [.topRight,.topLeft], radius: 4)
            self.titleLabel.layer.masksToBounds = true
            
            if self.titleLabel.isHidden {
                self.nowButton.roundCorners(corners: [.topRight,.topLeft], radius: 4)
                self.nowButton.layer.masksToBounds = true
            }
            
            self.cancelButton.roundCorners(corners: [.bottomLeft], radius: 4)
            self.cancelButton.layer.masksToBounds = true
            
            self.selectButton.roundCorners(corners: [.bottomRight], radius: 4)
            self.selectButton.layer.masksToBounds = true
        }
        self.layoutIfNeeded()
        
        if blurEffect {
            if !UIAccessibilityIsReduceTransparencyEnabled() {
                blurBackground(blurEffectStyle)
            }
        }
    }
    
    private func setupView() {        
        let keyWindow = UIApplication.shared.keyWindow
        let keyWindowBounds: CGRect = (keyWindow?.bounds)!
        self.frame = keyWindowBounds
        keyWindow?.addSubview(self)
       
        backgroundView = UIView(frame: keyWindowBounds)
        
        darkBackground()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backgroundView.addGestureRecognizer(tapRecognizer)
        addSubview(backgroundView)
        
        contentViewConfig()
        addSubview(contentView)
        
        show()
    }
    
    private func blurBackground(_ blurEffectStyle: UIBlurEffectStyle) {
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.alpha = 1
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.addSubview(blurEffectView)
    }
    
    private func darkBackground() {
        backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        backgroundView.alpha = 0
    }
    
    private func contentViewConfig() {
        /* ContentView */
        contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 370)
        contentView.addSubview(titleLabel)
        contentView.addSubview(datePicker)
        contentView.addSubview(nowButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(selectButton)
        
        /* Title */
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight(rawValue: 0.2))
        titleLabel.text = "Please choose the date and press 'Select' or 'Cancel'"
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.gray
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.white
        
        /* DatePicker */
        datePicker.backgroundColor = UIColor.white
        
        /* Now button */
        nowButton.setTitle("Now",for: .normal)
        nowButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight(rawValue: 0.3))
        nowButton.backgroundColor = UIColor.white
        nowButton.addTarget(self, action: #selector(nowButtonPressed(_:)), for: .touchUpInside)
        
        /* Cancel button */
        cancelButton.setTitle("Cancel",for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight(rawValue: 0.3))
        cancelButton.backgroundColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        
        /* Selection button */
        selectButton.setTitle("Select",for: .normal)
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        selectButton.backgroundColor = UIColor.white
        selectButton.addTarget(self, action: #selector(selectButtonPressed(_:)), for: .touchUpInside)
        
        /* Constraints */
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        nowButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        
        views = [
            "titleLabel": titleLabel,
            "datePicker": datePicker,
            "nowButton": nowButton,
            "cancelButton": cancelButton,
            "selectButton": selectButton
        ]
        
        var allConstraints = [NSLayoutConstraint]()
        
        let titleLabelHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[titleLabel]-16-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += titleLabelHorizontalConstraint
        
        let nowButtonHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[nowButton]-16-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += nowButtonHorizontalConstraint
        
        let datePickerHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[datePicker]-16-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += datePickerHorizontalConstraint
        
        let buttonsHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[cancelButton(==selectButton)]-1-[selectButton]-16-|",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += buttonsHorizontalConstraint
        
        let selectebuttonVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[datePicker]-1-[selectButton(50)]",
            options: [],
            metrics: nil,
            views: views)
        
        allConstraints += selectebuttonVerticalConstraint
        
        NSLayoutConstraint.activate(allConstraints)
    }

    private func configVerticalConstraintsOfHiddenViews() {
        var verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[titleLabel(50)]-1-[nowButton(50)]-1-[datePicker(200)]-1-[cancelButton(50)]-16-|",
            options: [],
            metrics: nil,
            views: views)
        
        if titleLabel.isHidden {
            
            verticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:[titleLabel(0)]-0-[nowButton(50)]-1-[datePicker(200)]-1-[cancelButton(50)]-16-|",
                options: [],
                metrics: nil,
                views: views)
            
        } else if nowButton.isHidden {
            
            verticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:[titleLabel(50)]-1-[nowButton(0)]-0-[datePicker(200)]-1-[cancelButton(50)]-16-|",
                options: [],
                metrics: nil,
                views: views)
            
        } else if titleLabel.isHidden && nowButton.isHidden {
            
            verticalConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:[titleLabel(0)]-0-[nowButton(0)]-0-[datePicker(200)]-1-[cancelButton(50)]-16-|",
                options: [],
                metrics: nil,
                views: views)
        }
        
        NSLayoutConstraint.activate(verticalConstraints)
    }
    
    @objc private func nowButtonPressed(_ sender: UIButton) {
        datePicker.date = Date()
    }
    
    @objc private func cancelButtonPressed(_ sender: UIButton) {
        dismiss()
        delegate?.datePickerCancelButtonAction()
    }
    
    @objc private func selectButtonPressed(_ sender: UIButton) {
        dismiss()
        let date = self.datePicker.date
        delegate?.datePickerSelectButtonAction(dateSelected: date)
    }
    
    private func show() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
            self.contentView.frame = CGRect(x: 0, y: self.frame.height - self.contentView.frame.height, width: self.frame.width, height: self.contentView.frame.height)
            self.backgroundView.alpha = 1.0
        })
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
            self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.contentView.frame.height)
            self.backgroundView.alpha = 0
            
        }) { (Bool) -> Void in
            self.removeFromSuperview()
        }
    }
}

private extension UIView {
    final func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
