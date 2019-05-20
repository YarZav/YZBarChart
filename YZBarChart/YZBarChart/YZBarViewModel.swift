//
//  YZBarViewModel.swift
//  YZBarChart
//
//  Created by admin on 20/05/2019.
//  Copyright © 2019 YZO. All rights reserved.
//

import UIKit

// MARK: - YZBarConfiguration
/// Configuration to display bar
public struct YZBarConfiguration {
    
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
    
    /// Description text under bar, text color
    public var descriptionBarTextColor: UIColor = .black
    
    /// Description text under bar, text alignment
    public var descriptionBarTextAlignment: NSTextAlignment = .center
    
    /// Description text under bar, text font
    public var descriptionBarTextFont: UIFont = UIFont.systemFont(ofSize: 11)
    
    public init() { }
}

/// Model to display bar data (X, Y)
open class YZBarModel {
    
    /// value for X axis
    public var x: Decimal
    
    /// value for Y axis
    public var y: Decimal
    
    /// Description text under bar
    public var descriptionX: String
    
    public init(x: Decimal, y: Decimal, descriptionX: String) {
        self.x = x
        self.y = y
        self.descriptionX = descriptionX
    }
}

open class YZBarViewModel {
    
    /// Configuration to display bar
    public var config: YZBarConfiguration
    
    /// Data (X, Y) to display
    public var model: YZBarModel
    
    public init(config: YZBarConfiguration, model: YZBarModel) {
        self.config = config
        self.model = model
    }
}
