//
//  ZCRMUIUtil.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import Foundation
import UIKit

internal let _incColor: UIColor =  UIColor(red: 14/255.0, green: 213/255.0, blue: 28/255.0, alpha: 1)
internal let _decColor: UIColor = UIColor(red: 204/255.0, green: 10/255.0, blue: 39/255.0, alpha: 1)
internal let _rateBarColor: UIColor = UIColor(red: 27/255.0, green: 168/255.0, blue: 249/255.0, alpha: 1)
internal let _fontColor: UIColor = UIColor.black
internal let _neutColor: UIColor =  UIColor(red: 247/255.0, green: 231/255.0, blue: 54/255.0, alpha: 1)
internal let _titleFont: UIFont = UIFont.systemFont(ofSize: 17.5)
internal let _rateColor: UIColor = .white

internal struct KPIRenderOptions {
	
	var titleFont: UIFont = UIFont.systemFont(ofSize: 20)
	var titleFontColor: UIColor = _fontColor
	var comparedToFont: UIFont = UIFont.systemFont(ofSize: 12)
	var comparedToFontColor: UIColor = _fontColor
	var valueFont: UIFont = UIFont.systemFont(ofSize: 20)
	var valueFontColor: UIColor = _fontColor
	var differenceFont: UIFont =  UIFont.systemFont(ofSize: 20)
	var differenceFontColor: UIColor = _fontColor
	var rateFont: UIFont = UIFont.systemFont(ofSize: 20)
	var rateFontColor: UIColor = _rateColor
	var incrementColor: UIColor = _incColor
	var decrementColor: UIColor = _decColor
	var neutralColor: UIColor = _neutColor
	var rateBarColor: UIColor = _rateBarColor
	
}

internal class ZCRMUIUtil {
	
	public static let shared = ZCRMUIUtil()
	
	private init(){}
	
	func getDecText(ofSize: CGFloat, baselineOffset: NSNumber, color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: " ▼ ", attributes: [ .font : UIFont.systemFont(ofSize: ofSize), .foregroundColor : color , .baselineOffset: baselineOffset])
	}

	func getIncText(ofSize: CGFloat, baselineOffset: NSNumber, color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: " ▲ ", attributes: [ .font : UIFont.systemFont(ofSize: ofSize), .foregroundColor : color, .baselineOffset: baselineOffset])
	}
	
	func getNeutralText(ofSize: CGFloat, baselineOffset: NSNumber, color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: " = ", attributes: [.font : UIFont.systemFont(ofSize: ofSize), .foregroundColor : color, .baselineOffset: baselineOffset])
	}
	
}

internal class ZCRMKPIUIUtil {
	
	public static let shared: ZCRMKPIUIUtil = ZCRMKPIUIUtil()
	
	private init() {}
	
	func getValueTextForStandardKPI(data: ZCRMKPIRow, options: KPIRenderOptions) -> NSMutableAttributedString {
		
		let fontSize = options.valueFont.pointSize
		let outputString: NSMutableAttributedString = NSMutableAttributedString(string: data.value, attributes: [.font : options.valueFont, .foregroundColor : options.valueFontColor])
		if (data.objective == .increased) {
			outputString.append(ZCRMUIUtil.shared.getIncText(ofSize: (fontSize/2) + 3, baselineOffset: 2.5, color: options.incrementColor))
		} else if (data.objective == .decreased) {
			outputString.append(ZCRMUIUtil.shared.getDecText(ofSize: (fontSize/2) + 3, baselineOffset: 2, color: options.decrementColor))
		} else {
			outputString.append(ZCRMUIUtil.shared.getNeutralText(ofSize: (fontSize/2) + 4, baselineOffset: 2.5, color: options.neutralColor))
		}
		outputString.append(NSAttributedString(string: data.difference, attributes: [.font : UIFont.systemFont(ofSize: (fontSize/2) + 1), .foregroundColor : options.differenceFontColor, .baselineOffset: 2.5]))
		return outputString
	}
	
	func getValueTextForGrowthIndexKPI(data: ZCRMKPIRow , options: KPIRenderOptions) -> NSMutableAttributedString {
		
		let fontSize = options.valueFont.pointSize
		var valueColor = options.neutralColor
		if data.objective == .increased {
			valueColor = options.incrementColor
		} else if data.objective == .decreased {
			valueColor = options.decrementColor
		}
		let outputString: NSMutableAttributedString = NSMutableAttributedString(string: data.value, attributes: [.font : options.valueFont, .foregroundColor : valueColor])
		outputString.append(NSAttributedString(string: " " + data.difference, attributes: [.font : UIFont.systemFont(ofSize: (fontSize/2) + 1), .foregroundColor : options.differenceFontColor, .baselineOffset: 2.5]))
		return outputString
	}
	
	func getValueTextForBasicKPI(data: ZCRMKPIRow, options: KPIRenderOptions) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: data.value, attributes: [.font : options.valueFont, .foregroundColor : options.valueFontColor])
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


