//
//  YZBarView.swift
//  YZBarChart
//
//  Created by admin on 16/05/2019.
//  Copyright © 2019 YZO. All rights reserved.
//

import UIKit

/// Configuration
public struct YZBarViewConfiguration {
    
    /// Max height of Bar view
    public var maxHeight: Double = 200.0
    
    /// Separate color
    public var separateColor: UIColor = .black
    
    /// Color under bar
    public var bckgroundColor: UIColor = UIColor.white.withAlphaComponent(0.2)
    
    /// Bar color
    public var barColor: UIColor = UIColor(white: 0.8, alpha: 1)
    
    /// Bar color when touch it
    public var barTouchColor: UIColor = .lightGray
    
    /// animateion duration to grow up
    public var animateDuration = TimeInterval(0.3)
    
    public init() { }
}

//MARK: - YZBarViewModel
open class YZBarViewModel {
    
    /// value for X axis
    public var x: String
    
    /// value for Y axis
    public var y: Double
    
    public init(x: String, y: Double) {
        self.x = x
        self.y = y
    }
}

// MARK: - YZBarView
open class YZBarView: UIView {
    
    /// Model for display data (constain X and Y value for axis)
    public var model: YZBarViewModel?
    private var maxModel: YZBarViewModel?
    
    public var bar = UIView()
    
    private var config = YZBarViewConfiguration()
    private var heightBarConstraint: NSLayoutConstraint?
    
    //Init - isLastBar (draw right vertical line if needed), model - model for display, maxModel - model with maximum value by Y value (depends on max Y axis value)
    public init(isLastBar: Bool, model: YZBarViewModel, configuration: YZBarViewConfiguration, maxModel: YZBarViewModel?) {
        super.init(frame: .zero)
        self.config = configuration
        self.model = model
        self.maxModel = maxModel
        self.createUI(isLastBar: isLastBar)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createUI(isLastBar: true)
    }
}

// MARK: - Pubilcs
extension YZBarView {
    
    public func didTouch(_ touched: Bool) {
        if touched {
            self.backgroundColor = self.config.bckgroundColor
            self.bar.backgroundColor = self.config.barTouchColor
        } else {
            self.backgroundColor = .clear
            self.bar.backgroundColor = self.config.barColor
        }
    }
    
    public func showBar(animated: Bool) {
        var y: Double = 0.0
        if let model = self.model {
            if let maxModel = self.maxModel, maxModel.y != 0 {
                let ratio = self.config.maxHeight / maxModel.y
                y = ratio * (model.y)
            }
        }
        
        self.setNeedsLayout()
        UIView.animate(withDuration: animated ? self.config.animateDuration : 0) {
            self.heightBarConstraint?.constant = CGFloat(y)
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Privates
extension YZBarView {
    
    private func createUI(isLastBar: Bool) {
        self.bar.backgroundColor = self.config.bckgroundColor
        
        let leftLine = UIView()
        leftLine.backgroundColor = .darkGray
        
        self.addSubview(leftLine)
        self.addSubview(self.bar)
        
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: leftLine, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftLine, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftLine, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        
        if isLastBar {
            let rightLine = UIView()
            rightLine.backgroundColor = self.config.separateColor
            
            self.addSubview(rightLine)
            
            rightLine.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: rightLine, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: rightLine, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: rightLine, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: rightLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        }
        
        self.bar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.bar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -1).isActive = true
        NSLayoutConstraint(item: self.bar, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: self.bar, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -1).isActive = true
        
        self.heightBarConstraint = NSLayoutConstraint(item: self.bar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.heightBarConstraint?.isActive = true
    }
}
