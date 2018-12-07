//
//  ZCRMCommonUtil.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 24/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

/**
	Error.
*/
public struct ZCRMChartsError : Error {
	
	private let message: String
	
	init(message: String) {
		self.message = "ZCRMCharts - \(message)"
	}
	
	public var localizedDescription: String {
		return self.message
	}
}

internal protocol KPIUtil {
	
	var type: ZCRMCharts.ZCRMKPIType { get set}
}

internal extension KPIUtil {
	
	var isScorecard: Bool {
		
		if self.type == .scorecard {
			return true
		}
		return false
	}
	
	var isRankings: Bool {
		
		if self.type == .rankings {
			return true
		}
		return false
	}
	
	var isBasic: Bool {
		
		if self.type == .basic {
			return true
		}
		return false
	}
	
	var isStandard: Bool {
		
		if self.type == .standard {
			return true
		}
		return false
	}
	
	var isGrowthIndex: Bool {
		
		if self.type == .growthIndex {
			return true
		}
		return false
	}
}

internal extension UIView {
	
	internal func getHeightOf(percent: CGFloat) -> CGFloat {
		return (self.frame.height / 100) * percent
	}

	func getWidthOf(percent: CGFloat) -> CGFloat {
		return (self.frame.width / 100) * percent
	}
	
	internal func invalidateConstraints() {
		
		var constraints: [NSLayoutConstraint] = self.constraints
		for subView in self.subviews {
			constraints += subView.constraints
		}
		if !constraints.isEmpty {
			NSLayoutConstraint.deactivate(constraints)
		}
	}
	
	internal func addBottomBorder(color: UIColor, width: CGFloat) {
		
		let borderLayer = CALayer()
		borderLayer.backgroundColor = color.cgColor
		borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
		self.layer.addSublayer(borderLayer)
	}
}

internal extension String {
	
	internal func toCGFloat() -> CGFloat {
		return CGFloat(truncating: NumberFormatter().number(from: self)!)
	}
}

internal extension Optional where Wrapped == String {
	
	internal var notNil: Bool {
		return self != nil
	}
}

internal extension Int {
	
	internal func toCGFloat() -> CGFloat {
		return CGFloat(self)
	}
}

internal extension CGFloat {
	
	internal func toInt() -> Int {
		return Int(self)
	}
	
	internal func toRadians() -> CGFloat {
		return self * CGFloat(Double.pi) / 180.0
	}
}

internal func getScreenHeightOf(percent: CGFloat) -> CGFloat {
	
	return (UIScreen.main.bounds.height / 100) * percent
}

internal func getScreenWidthOf(percent: CGFloat) -> CGFloat {
	
	return (UIScreen.main.bounds.width / 100) * percent
}

internal extension Array where Element: Equatable {
	
	internal func isEqual(_ array: [Element]) -> Bool {
		
		if array.count != self.count { return false }
		var isEqual = true
		for (index, element) in array.enumerated() {
			if element != self[index] {
				isEqual = false
				break
			}
		}
		return isEqual
	}
}
