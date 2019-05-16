//
//  YZBarChartView.swift
//  YZBarChart
//
//  Created by admin on 16/05/2019.
//  Copyright © 2019 YZO. All rights reserved.
//

import UIKit

// MARK: - Configuration
public struct YZBarChartViewConfiguration {
    
    /// Top description text color
    public var titleTextColor: UIColor = .white
    
    /// Top description text alignment
    public var titleTextAlignment: NSTextAlignment = .center
    
    /// Top description text font
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    /// Bottom separate line color
    public var separateLineColor: UIColor = .black
    
    /// Max count of bars in BarChartView
    public var maxBarCount: Int = 10
    
    public init() { }
}

// MARK: - YZBarChartView
open class YZBarChartView: UIView {
    
    private var config = YZBarChartViewConfiguration()
    private var label = UILabel()
    private var barViews = [YZBarView]()
    private var viewModels = [(model: YZBarViewModel, config: YZBarViewConfiguration)]()
    
    //Init
    public init(configuration: YZBarChartViewConfiguration) {
        super.init(frame: .zero)
        self.config = configuration
        self.createUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createUI()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1, let touch = touches.first, touch.phase == .began {
            self.updateBarView(by: touch)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.updateBarView(by: touch)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for barView in self.barViews {
            barView.didTouch(false)
        }
        
        self.didTouchBarView(nil)
    }
    
    private func didTouchBarView(_ barView: YZBarView?) {
        if let barView = barView, let model = barView.model {
            let numberFormatter = NumberFormatter.numberFormatter(numberStyle: .currency)
            let number = NSNumber(value: model.y)
            self.label.text = numberFormatter.string(from: number)
        } else {
            self.label.text = nil
        }
    }
}

// MARK: - Publics
extension YZBarChartView {
    
    /// Display data
    public func displayViewModels(_ viewModels: [(model: YZBarViewModel, config: YZBarViewConfiguration)], animated: Bool) {
        self.viewModels = viewModels
        
        self.subviews.forEach { $0.removeFromSuperview() }
        self.createUI()
        
        self.layoutIfNeeded()
        
        self.showBar(animated: true)
    }
    
    /// Show bar with animation grow up from bottom to top
    public func showBar(animated: Bool) {
        self.barViews.forEach {
            $0.showBar(animated: animated)
        }
    }
}

// MARK: - Privates
extension YZBarChartView {
    
    private func createUI() {
        //Top label, which contains info when tapped on bar
        self.label.textColor = self.config.titleTextColor
        self.label.textAlignment = self.config.titleTextAlignment
        self.label.font = self.config.titleFont
        self.addSubview(self.label)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.label, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        //Bottom separate line (width equal all YZBarChartView)
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = self.config.separateLineColor
        
        self.addSubview(bottomLineView)
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: bottomLineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: bottomLineView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bottomLineView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: bottomLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        
        //If count of models equal 0, do not draw anything
        if self.viewModels.isEmpty { return }
        
        //Get model with max Y axis value
        let maxModel = self.viewModels.max { $0.model.y < $1.model.y }
        
        //Do not show more then 10 bars (thay are do not display all in screen and it will be draw too long)
        let comparison = self.viewModels.count > self.config.maxBarCount ? self.config.maxBarCount : 1
        let attitude = comparison == 1 ? 1 : self.viewModels.count / comparison
        
        var previousView: YZBarView?
        var previousDescription: UILabel?
        
        //Draw bars one by one from left to right
        for (modelIndex, viewModel) in self.viewModels.enumerated() {
            let isLastIndex = modelIndex == self.viewModels.count - 1
            
            let barView = YZBarView(isLastBar: isLastIndex, model: viewModel.model, configuration: viewModel.config, maxModel: maxModel?.model)
            barView.tag = modelIndex
            
            self.barViews.append(barView)
            self.addSubview(barView)
            
            barView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: barView, attribute: .top, relatedBy: .equal, toItem: self.label, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: barView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
            if let prevView = previousView {
                NSLayoutConstraint(item: barView, attribute: .left, relatedBy: .equal, toItem: prevView, attribute: .right, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: barView, attribute: .width, relatedBy: .equal, toItem: prevView, attribute: .width, multiplier: 1, constant: 0).isActive = true
            } else {
                NSLayoutConstraint(item: barView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
            }
            if isLastIndex {
                NSLayoutConstraint(item: barView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
            }
            
            previousView = barView
            
            if modelIndex % attitude == 0 {
                let descriptionLabel = UILabel()
                descriptionLabel.textColor = viewModel.config.descriptionBarTextColor
                descriptionLabel.textAlignment = viewModel.config.descriptionBarTextAlignment
                descriptionLabel.font = viewModel.config.descriptionBarTextFont
                descriptionLabel.text = viewModel.model.x
                
                self.addSubview(descriptionLabel)
                
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: descriptionLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
                if let previousDescription = previousDescription {
                    NSLayoutConstraint(item: descriptionLabel, attribute: .left, relatedBy: .equal, toItem: previousDescription, attribute: .right, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: descriptionLabel, attribute: .width, relatedBy: .equal, toItem: previousDescription, attribute: .width, multiplier: 1, constant: 0).isActive = true
                } else {
                    NSLayoutConstraint(item: descriptionLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
                }
                if comparison == 1 {
                    if modelIndex == (self.viewModels.count - 1) {
                        NSLayoutConstraint(item: descriptionLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
                    }
                } else {
                    if (modelIndex + attitude) == self.viewModels.count {
                        NSLayoutConstraint(item: descriptionLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
                    }
                }
                
                previousDescription = descriptionLabel
            }
        }
    }
    
    private func updateBarView(by touch: UITouch) {
        let location = touch.location(in: self)
        
        var isContainsbarView: Bool = false
        
        for barView in self.barViews {
            let barFrame = self.convert(barView.frame, from: barView.superview)
            if barFrame.contains(location) {
                barView.didTouch(true)
                
                isContainsbarView = true
                self.didTouchBarView(barView)
            } else {
                barView.didTouch(false)
            }
        }
        
        if !isContainsbarView {
            self.didTouchBarView(nil)
        }
    }
}
