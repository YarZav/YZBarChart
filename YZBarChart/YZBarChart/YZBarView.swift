//
//  YZBarView.swift
//  YZBarChart
//
//  Created by admin on 16/05/2019.
//  Copyright © 2019 YZO. All rights reserved.
//

import UIKit

public protocol YZBarViewDelegate: class {
    func getBarChartHeight() -> Double
}

// MARK: - YZBarView
open class YZBarView: UIView {
    
    /// Model for display data (constain X and Y value for axis)
    public var viewModel: YZBarViewModel
    public weak var delegate: YZBarViewDelegate?
    
    private var bar = UIView()
    private var maxViewModel: YZBarViewModel?
    private var heightBarConstraint: NSLayoutConstraint?
    
    //Init - isLastBar (draw right vertical line if needed), model - model for display, maxModel - model with maximum value by Y value (depends on max Y axis value)
    public init(isLastBar: Bool, viewModel: YZBarViewModel, maxViewModel: YZBarViewModel?) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.maxViewModel = maxViewModel
        self.createUI(isLastBar: isLastBar)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.viewModel = YZBarViewModel(config: YZBarConfiguration(), model: YZBarModel(x: 0, y: 0, descriptionX: ""))
        super.init(coder: aDecoder)
        self.createUI(isLastBar: true)
    }
}

// MARK: - Pubilcs
extension YZBarView {
    
    public func didTouch(_ touched: Bool) {
        if touched {
            self.backgroundColor = self.viewModel.config.bckgroundColor
            self.bar.backgroundColor = self.viewModel.config.barTouchColor
        } else {
            self.backgroundColor = .clear
            self.bar.backgroundColor = self.viewModel.config.barColor
        }
    }
    
    public func showBar(animated: Bool) {
        let barHeight = self.delegate?.getBarChartHeight() ?? 0
        
        var y: Double = 0.0
        if let maxModel = self.maxViewModel?.model, maxModel.y != 0 {
            let ratio = barHeight / NSDecimalNumber(decimal: maxModel.y).doubleValue
            y = ratio * NSDecimalNumber(decimal: self.viewModel.model.y).doubleValue
        }
        
        self.setNeedsLayout()
        UIView.animate(withDuration: animated ? self.viewModel.config.animateDuration : 0) {
            self.heightBarConstraint?.constant = CGFloat(y)
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Privates
extension YZBarView {
    
    private func createUI(isLastBar: Bool) {
        self.bar.backgroundColor = self.viewModel.config.barColor
        
        let leftLine = UIView()
        leftLine.backgroundColor = self.viewModel.config.separateColor
        
        self.addSubview(leftLine)
        self.addSubview(self.bar)
        
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: leftLine, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftLine, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftLine, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: leftLine, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        
        if isLastBar {
            let rightLine = UIView()
            rightLine.backgroundColor = self.viewModel.config.separateColor
            
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
