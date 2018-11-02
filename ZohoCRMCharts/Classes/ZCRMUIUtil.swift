//
//  ZCRMUIUtil.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

internal struct Colors {
	
	static let incrementColor: UIColor =  UIColor(red: 14/255.0, green: 213/255.0, blue: 28/255.0, alpha: 1)
	static let decrementColor: UIColor = UIColor(red: 204/255.0, green: 10/255.0, blue: 39/255.0, alpha: 1)
	static let rateBarColor: UIColor = UIColor(red: 27/255.0, green: 168/255.0, blue: 249/255.0, alpha: 1)
	static let fontColor: UIColor = UIColor.black
	static let neutralColor: UIColor =  UIColor(red: 247/255.0, green: 231/255.0, blue: 54/255.0, alpha: 1)
	static let titleFont: UIFont = UIFont.systemFont(ofSize: 17.5)
	static let rateColor: UIColor = .white
}

internal struct KPIRenderOptions {
	
	var titleFont: UIFont = UIFont.systemFont(ofSize: 20)
	var titleFontColor: UIColor = Colors.fontColor
	var comparedToFont: UIFont = UIFont.systemFont(ofSize: 12)
	var comparedToFontColor: UIColor = Colors.fontColor
	var labelFont: UIFont =  UIFont.systemFont(ofSize: 19.5)
	var labelFontColor: UIColor = Colors.fontColor
	var simpleKpiValueFont: UIFont = UIFont.systemFont(ofSize: 24)
	var valueFont: UIFont = UIFont.systemFont(ofSize: 19.5)
	var valueFontColor: UIColor = Colors.fontColor
	var rateFont: UIFont = UIFont.systemFont(ofSize: 19.5)
	var rateFontColor: UIColor = Colors.fontColor
	var incrementColor: UIColor = Colors.incrementColor
	var decrementColor: UIColor = Colors.decrementColor
	var neutralColor: UIColor = Colors.neutralColor
	var rateBarColor: UIColor = Colors.rateBarColor
	var footNoteFont: UIFont = UIFont.systemFont(ofSize: 12)
	var footNoteColor: UIColor = Colors.fontColor
}

internal struct ZCRMUIUtil {
	
	static func getDecText(ofSize: CGFloat, baselineOffset: NSNumber, color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: " ▼ ", attributes: [ NSFontAttributeName : UIFont.systemFont(ofSize: ofSize), NSForegroundColorAttributeName: color , NSBaselineOffsetAttributeName: baselineOffset])
	}

	static func getIncText(ofSize: CGFloat, baselineOffset: NSNumber, color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: " ▲ ", attributes: [ NSFontAttributeName : UIFont.systemFont(ofSize: ofSize), NSForegroundColorAttributeName: color, NSBaselineOffsetAttributeName: baselineOffset])
	}
	
	static func getNeutralText(ofSize: CGFloat, baselineOffset: NSNumber, color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: " = ", attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: ofSize), NSForegroundColorAttributeName: color, NSBaselineOffsetAttributeName: baselineOffset])
	}
	
}

internal struct ZCRMKPIUIUtil {
	
	static func getValueTextForStandardKPI(data: ZCRMKPIRow, options: KPIRenderOptions) -> NSMutableAttributedString {
		
		let fontSize = options.simpleKpiValueFont.pointSize
		let outputString: NSMutableAttributedString = NSMutableAttributedString(string: data.value, attributes: [NSFontAttributeName: options.simpleKpiValueFont, NSForegroundColorAttributeName: options.valueFontColor])
		if (data.objective == .increased) {
			outputString.append(ZCRMUIUtil.getIncText(ofSize: (fontSize/2) + 3, baselineOffset: 2.5, color: options.incrementColor))
		} else if (data.objective == .decreased) {
			outputString.append(ZCRMUIUtil.getDecText(ofSize: (fontSize/2) + 3, baselineOffset: 2, color: options.decrementColor))
		} else {
			outputString.append(ZCRMUIUtil.getNeutralText(ofSize: (fontSize/2) + 4, baselineOffset: 2.5, color: options.neutralColor))
		}
		outputString.append(NSAttributedString(string: data.rate, attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: (fontSize/2) + 1), NSForegroundColorAttributeName: options.rateFontColor, NSBaselineOffsetAttributeName: 2.5]))
		return outputString
	}
	
	static func getValueTextForGrowthIndexKPI(data: ZCRMKPIRow , options: KPIRenderOptions) -> NSMutableAttributedString {
		
		let fontSize = options.simpleKpiValueFont.pointSize
		var valueColor = options.neutralColor
		if data.objective == .increased {
			valueColor = options.incrementColor
		} else if data.objective == .decreased {
			valueColor = options.decrementColor
		}
		let outputString: NSMutableAttributedString = NSMutableAttributedString(string: data.value, attributes: [ NSFontAttributeName: options.simpleKpiValueFont, NSForegroundColorAttributeName: valueColor])
		outputString.append(NSAttributedString(string: " " + data.value, attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: (fontSize/2) + 1), NSForegroundColorAttributeName: options.valueFontColor, NSBaselineOffsetAttributeName: 2.5]))
		return outputString
	}
	
	static func getValueTextForBasicKPI(data: ZCRMKPIRow, options: KPIRenderOptions) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: data.value, attributes: [ NSFontAttributeName: options.simpleKpiValueFont, NSForegroundColorAttributeName: options.valueFontColor])
	}
	
}


