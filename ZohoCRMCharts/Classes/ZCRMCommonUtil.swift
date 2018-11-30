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
	
	let message: String
	
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
	
	func getHeightOf(percent: CGFloat) -> CGFloat {
		return (self.frame.height / 100) * percent
	}

	func getWidthOf(percent: CGFloat) -> CGFloat {
		return (self.frame.width / 100) * percent
	}
	
	func invalidateConstraints() {
		
		var constraints: [NSLayoutConstraint] = self.constraints
		for subView in self.subviews {
			constraints += subView.constraints
		}
		if !constraints.isEmpty {
			NSLayoutConstraint.deactivate(constraints)
		}
	}
	
	func addBottomBorder(color: UIColor, width: CGFloat) {
		
		let borderLayer = CALayer()
		borderLayer.backgroundColor = color.cgColor
		borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
		self.layer.addSublayer(borderLayer)
	}
	
	func addLeftShadow(shadowRadius: CGFloat = 2.0) {
		
		self.layer.masksToBounds = false
		self.layer.shadowRadius = shadowRadius
		self.layer.shadowOpacity = 1.0
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: shadowRadius, y: 0))
		path.addLine(to: CGPoint(x: shadowRadius, y: self.frame.height))
		path.addLine(to: CGPoint(x: 0, y: self.frame.height))
		path.close()
		self.layer.shadowPath = path.cgPath
	}
}

internal extension String {
	
	func toCGFloat() -> CGFloat {
		return CGFloat(truncating: NumberFormatter().number(from: self)!)
	}
}

internal extension Optional where Wrapped == String {
	
	var notNil: Bool {
		return self != nil
	}
}

internal extension Int {
	
	func toCGFloat() -> CGFloat {
		return CGFloat(self)
	}
}

internal extension CGFloat {
	
	func toInt() -> Int {
		return Int(self)
	}
	
	func toRadians() -> CGFloat {
		return self * CGFloat(Double.pi) / 180.0
	}
}

internal func getScreenHeightOf(percent: CGFloat) -> CGFloat {
	
	return (UIScreen.main.bounds.height / 100) * percent
}

internal func getScreenWidthOf(percent: CGFloat) -> CGFloat {
	
	return (UIScreen.main.bounds.width / 100) * percent
}
