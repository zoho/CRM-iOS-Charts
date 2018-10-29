//
//  ZCRMCommonUtil.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 24/10/18.
//

protocol KPIUtil {
	
	var type: ZCRMKPIComponent! { get set}
	var isScorecard: Bool { get }
	var isRankings: Bool { get }
	var isBasic: Bool { get }
	var isStandard: Bool { get }
	var isGrowthIndex: Bool { get }
}

extension KPIUtil {
	
	internal var isScorecard: Bool {
		
		if self.type == .scorecard {
			return true
		}
		return false
	}
	
	internal var isRankings: Bool {
		
		if self.type == .rankings {
			return true
		}
		return false
	}
	
	internal var isBasic: Bool {
		
		if self.type == .basic {
			return true
		}
		return false
	}
	
	internal var isStandard: Bool {
		
		if self.type == .standard {
			return true
		}
		return false
	}
	
	internal var isGrowthIndex: Bool {
		
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
}

internal extension String {
	
	func toCGFloat() -> CGFloat {
		return CGFloat(truncating: NumberFormatter().number(from: self)!)
	}
}

internal extension Optional where Wrapped == String {
	
	var notNil: Bool {
		if self != nil {
			return true
		}
		return false
	}
}

internal func getScreenHeightOf(percent: CGFloat) -> CGFloat {
	
	return (UIScreen.main.bounds.height / 100) * percent
}

internal func getScreenWidthOf(percent: CGFloat) -> CGFloat {
	
	return (UIScreen.main.bounds.width / 100) * percent
}




