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

internal protocol ZCRMLayoutConstraintDelegate: class {
	
	var viewConstraints:[NSLayoutConstraint] { get set }
	
	func activate(constraints: [NSLayoutConstraint], _ append: Bool)
	
	func deactivateConstraints()
}

internal extension ZCRMLayoutConstraintDelegate {
	
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
		static let bottomShadow = -5
		static let topShadow = -6
		static let rightShadow = -7
		static let leftShadow = -8
	}
	
	internal func getHeightOf(percent: CGFloat) -> CGFloat {
		return (self.frame.height / 100) * percent
	}

	func getWidthOf(percent: CGFloat) -> CGFloat {
		return (self.frame.width / 100) * percent
	}
	
	internal func addBorder(edge: UIRectEdge, color: UIColor, width: CGFloat) {
		
		self.removeBorder(forEdge: edge)
		let borderView = UIView()
		borderView.backgroundColor = color
		borderView.autoresizingMask = self.getResizingMask(forEdge: edge)
		borderView.frame = self.getFrame(forEdge: edge, thickNess: width)
		borderView.tag = self.getBorderTag(forEdge: edge)
		self.addSubview(borderView)
	}
	
	private func removeBorder(forEdge: UIRectEdge) {
		self.removeView(withTag: self.getBorderTag(forEdge: forEdge))
	}
	
	internal func addShadowBorder(edge: UIRectEdge, color: UIColor, width: CGFloat) {
		
		self.removeShadowBorder(forEdge: edge)
		let shadowView = UIView()
		shadowView.backgroundColor = color
		shadowView.autoresizingMask = self.getResizingMask(forEdge: edge)
		shadowView.frame = self.getFrame(forEdge: edge, thickNess: width)
		shadowView.tag = self.getShadowTag(forEdge: edge)
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [UIColor.white.cgColor, color.cgColor]
		gradientLayer.frame.size = shadowView.frame.size
		gradientLayer.startPoint = self.getGradientStartPointFor(edge: edge)
		gradientLayer.endPoint = self.getGradientEndPointFor(edge: edge)
		shadowView.layer.addSublayer(gradientLayer)
		self.addSubview(shadowView)
	}
	
	private func removeShadowBorder(forEdge: UIRectEdge) {
		self.removeView(withTag: self.getShadowTag(forEdge: forEdge))
	}
	
	private func removeView(withTag tag: Int) {
		
		for view in self.subviews {
			if view.tag == tag {
				view.removeFromSuperview()
				break
			}
		}
	}
	
	
	private func getBorderTag(forEdge: UIRectEdge) -> Int {
		
		var tag: Int!
		switch forEdge {
		case .top:
			tag = UIView.tag.top
		case .left:
			tag = UIView.tag.left
		case .bottom:
			tag = UIView.tag.bottom
		default:
			tag = UIView.tag.right
		}
		return tag
	}
	
	private func getShadowTag(forEdge: UIRectEdge) -> Int {
		
		var tag: Int!
		switch forEdge {
		case .top:
			tag = UIView.tag.topShadow
		case .left:
			tag = UIView.tag.leftShadow
		case .bottom:
			tag = UIView.tag.bottomShadow
		default:
			tag = UIView.tag.rightShadow
		}
		return tag
	}
	
	private func getGradientStartPointFor(edge: UIRectEdge) -> CGPoint {
	
		var point: CGPoint!
		switch edge {
		case .top :
			point = CGPoint(x: 1.0, y: 1.0)
		case .left:
			point = CGPoint(x: 0.0, y: 1.0)
		case .bottom:
			point = CGPoint(x: 1.0, y: 0.0)
		default: // right
			point = CGPoint(x: 1.0, y: 1.0)
		}
		return point
	}
	
	private func getGradientEndPointFor(edge: UIRectEdge) -> CGPoint {
		
		var point: CGPoint!
		switch edge {
		case .top :
			point = CGPoint(x: 1.0, y: 0.0)
		case .left:
			point = CGPoint(x: 1.0, y: 1.0)
		case .bottom:
			point = CGPoint(x: 1.0, y: 1.0)
		default: // right
			point = CGPoint(x: 0.0, y: 1.0)
		}
		return point
	}
	
	
	private func getResizingMask(forEdge: UIRectEdge) -> UIViewAutoresizing {
		
		var edges: UIViewAutoresizing!
		switch forEdge {
		case .top :
			edges = [.flexibleWidth, .flexibleBottomMargin]
		case .left:
			edges = [.flexibleHeight, .flexibleRightMargin]
		case .bottom:
			edges = [.flexibleWidth, .flexibleTopMargin]
		default: // right
			edges = [.flexibleHeight, .flexibleLeftMargin]
		}
		return edges
	}
	
	private func getFrame(forEdge: UIRectEdge, thickNess: CGFloat) -> CGRect {
		
		var frame: CGRect!
		switch forEdge {
		case .top :
			frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: thickNess)
		case .left:
			frame = CGRect(x: 0, y: 0, width: thickNess, height: self.frame.size.height)
		case .bottom:
			frame = CGRect(x: 0, y: self.frame.height - thickNess, width: self.frame.size.width, height: thickNess)
		default: // right
			frame = CGRect(x: self.frame.size.width - thickNess, y: 0, width: thickNess, height: self.frame.size.height)
		}
		return frame
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
