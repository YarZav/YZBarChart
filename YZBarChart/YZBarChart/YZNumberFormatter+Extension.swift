//
//  YZNumberFormatter+Extension.swift
//  YZBarChart
//
//  Created by admin on 16/05/2019.
//  Copyright © 2019 YZO. All rights reserved.
//

import UIKit

extension NumberFormatter {
    
    /// Number formatter
    static func numberFormatter(numberStyle: NumberFormatter.Style, currencySymbol: String? = nil, maximumFractionDigits: Int = 2, minimumFractionDigits: Int = 0) -> NumberFormatter {
        let formatter = NumberFormatter()
        if let currencySymbol = currencySymbol {
            formatter.currencySymbol = currencySymbol
        }
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.numberStyle = numberStyle
        
        return formatter
    }
}
