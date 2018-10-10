//
//  ZCRMUIUtil.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import Foundation
import UIKit

internal class ZCRMUIUtil {
	
	public static let shared = ZCRMUIUtil()
	
	private init(){}
	
	func getDecText(ofSize: CGFloat, baselineOffset: NSNumber) -> NSAttributedString {
		return NSAttributedString(string: " ▼ ", attributes: [ .font : UIFont.systemFont(ofSize: ofSize), .foregroundColor : UIColor(red: 204/255.0, green: 10/255.0, blue: 39/255.0, alpha: 1) , .baselineOffset: baselineOffset])
	}

	func getIncText(ofSize: CGFloat, baselineOffset: NSNumber) -> NSAttributedString {
		return NSAttributedString(string: " ▲ ", attributes: [ .font : UIFont.systemFont(ofSize: ofSize), .foregroundColor : UIColor(red: 48/255.0, green: 153/255.0, blue: 94/255.0, alpha: 1), .baselineOffset: baselineOffset])
	}
	
	func getNeutralText(ofSize: CGFloat, baselineOffset: NSNumber) -> NSAttributedString {
		return NSAttributedString(string: " = ", attributes: [.font : UIFont.systemFont(ofSize: ofSize), .foregroundColor : UIColor(red: 247/255.0, green: 231/255.0, blue: 54/255.0, alpha: 1), .baselineOffset: baselineOffset])
	}
	
}

internal class ZCRMKPIUIUtil {
	
	public static let shared: ZCRMKPIUIUtil = ZCRMKPIUIUtil()
	
	private init() {}
	
	func getValueTextForStandardKPI(data: ZCRMKPIRow, fontSize: CGFloat = 22, color: UIColor = UIColor.white) -> NSMutableAttributedString {
		
		let outputString: NSMutableAttributedString = NSMutableAttributedString(string: data.value, attributes: [.font : UIFont.systemFont(ofSize: fontSize), .foregroundColor : color])
		if (data.status == .increased) {
			outputString.append(ZCRMUIUtil.shared.getIncText(ofSize: (fontSize/2) + 3, baselineOffset: 2.5))
		} else if (data.status == .decreased) {
			outputString.append(ZCRMUIUtil.shared.getDecText(ofSize: (fontSize/2) + 3, baselineOffset: 2))
		} else {
			outputString.append(NSAttributedString(string: " = ", attributes: [.font : UIFont.systemFont(ofSize: (fontSize/2) + 4), .foregroundColor : UIColor.yellow, .baselineOffset: 2.5]))
		}
		outputString.append(NSAttributedString(string: data.difference, attributes: [.font : UIFont.systemFont(ofSize: (fontSize/2) + 1), .foregroundColor : color, .baselineOffset: 2.5]))
		return outputString
	}
	
	func getValueTextForGrowthIndexKPI(data: ZCRMKPIRow , fontSize: CGFloat = 22, color: UIColor = UIColor.white) -> NSMutableAttributedString {
		
		var valueColor = UIColor(red: 247/255.0, green: 231/255.0, blue: 54/255.0, alpha: 1)
		if data.status == .increased {
			valueColor = incrementColor // MARK: - to change
		} else if data.status == .decreased {
			valueColor = decrementColor // MARK: - to change
		}
		let outputString: NSMutableAttributedString = NSMutableAttributedString(string: data.value, attributes: [.font : UIFont.systemFont(ofSize: fontSize), .foregroundColor : valueColor])
		outputString.append(NSAttributedString(string: " " + data.difference, attributes: [.font : UIFont.systemFont(ofSize: (fontSize/2) + 1), .foregroundColor : color, .baselineOffset: 2.5]))
		return outputString
	}
	
	func getValueTextForBasicKPI(data: ZCRMKPIRow, fontSize: CGFloat = 23, color: UIColor = UIColor.white) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: data.value, attributes: [.font : UIFont.systemFont(ofSize: fontSize), .foregroundColor : color])
	}
	
}

extension UIView {
	
	internal func getHeightOf(percent: CGFloat) -> CGFloat {
		return (self.frame.height / 100) * percent
	}
	
	internal func getWidthOf(percent: CGFloat) -> CGFloat {
		return (self.frame.width / 100) * percent
	}
}

extension String {
	
	internal func toCGFloat() -> CGFloat {
		return CGFloat(truncating: NumberFormatter().number(from: self)!)
	}
}

internal let incrementColor: UIColor =  UIColor(red: 14/255.0, green: 213/255.0, blue: 28/255.0, alpha: 1)
internal let decrementColor: UIColor = UIColor(red: 204/255.0, green: 10/255.0, blue: 39/255.0, alpha: 1)
internal let rateBarColor: UIColor = UIColor(red: 27/255.0, green: 168/255.0, blue: 249/255.0, alpha: 1)
