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

internal protocol ZCRMLayoutConstrainDelegate: class {
	
	var viewConstraints:[NSLayoutConstraint] { get set }
	
	func activate(constraints: [NSLayoutConstraint], _ append: Bool)
	
	func deactivateConstraints()
}

internal extension ZCRMLayoutConstrainDelegate {
	
	func activate(constraints: [NSLayoutConstraint], _ append: Bool = false) {
		if append {
			self.viewConstraints += constraints
		} else  {
			self.viewConstraints = constraints
		}
		NSLayoutConstraint.activate(constraints)
	}
	
	func deactivateConstraints() {
		if !self.viewConstraints.isEmpty {
			NSLayoutConstraint.deactivate(self.viewConstraints)
		}
	}
}

internal extension UIView {
	
	internal struct tag {
		static let bottom: Int = -1
		static let top: Int = -2
		static let right: Int = -3
		static let left: Int = -4
	}
	
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
		
		let border = UIView()
		border.backgroundColor = color
		border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
		border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
		self.addSubview(border)
	}
	
	internal func addRightBorder(color: UIColor, width: CGFloat) {
		
		let border = UIView()
		border.backgroundColor = color
		border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
		border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
		let gradientLayer:CAGradientLayer = CAGradientLayer()
		gradientLayer.frame.size = border.frame.size
		gradientLayer.colors = [UIColor.white.cgColor, color.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
		border.layer.addSublayer(gradientLayer)
		self.addSubview(border)
	}
	
	internal func addTopBorder(color: UIColor, width: CGFloat) {
		
		let border = UIView()
		border.backgroundColor = color
		border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
		border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
		let gradientLayer:CAGradientLayer = CAGradientLayer()
		gradientLayer.frame.size = border.frame.size
		gradientLayer.colors = [UIColor.white.cgColor, color.cgColor]
		gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
		border.layer.addSublayer(gradientLayer)
		self.addSubview(border)
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
