//
//  ZCRMUIUtil.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

internal struct Colors {
	
	static let positiveColor: UIColor =  UIColor(red: 14/255.0, green: 213/255.0, blue: 28/255.0, alpha: 1)
	static let negativeColor: UIColor = UIColor(red: 204/255.0, green: 10/255.0, blue: 39/255.0, alpha: 1)
	static let rateBarColor: UIColor = UIColor(red: 27/255.0, green: 168/255.0, blue: 249/255.0, alpha: 1)
	static let fontColor: UIColor = UIColor.black
	static let neutralColor: UIColor =  UIColor(red: 247/255.0, green: 231/255.0, blue: 54/255.0, alpha: 1)
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
	var positiveColor: UIColor = Colors.positiveColor
	var negativeColor: UIColor = Colors.negativeColor
	var neutralColor: UIColor = Colors.neutralColor
	var rateBarColor: UIColor = Colors.rateBarColor
	var footNoteFont: UIFont = UIFont.systemFont(ofSize: 12)
	var footNoteColor: UIColor = Colors.fontColor
}

internal struct ComparatorRenderOptions {
	
	var titleFont: UIFont = UIFont.systemFont(ofSize: 20)
	var titleFontColor: UIColor = Colors.fontColor
	var chunkDataFont: UIFont = UIFont.systemFont(ofSize: 13)
	var chunkDataFontColor: UIColor = Colors.fontColor
	var chunkFont: UIFont = UIFont.systemFont(ofSize: 13)
	var chunkFontColor: UIColor = Colors.fontColor
	var groupFont: UIFont = UIFont.systemFont(ofSize: 13)
	var groupFontColor: UIColor = Colors.fontColor
	var elegantDiffColor: UIColor = UIColor(red: 207 / 255, green: 223 / 255, blue: 249 / 255, alpha: 1)
	var classicHeaderRowColor: UIColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
	var positiveColor: UIColor = Colors.positiveColor
	var negativeColor: UIColor = Colors.negativeColor
	var neutralColor: UIColor = Colors.neutralColor
}

internal struct FunnelRenderOptions {
	
	var titleFont: UIFont = UIFont.systemFont(ofSize: 20)
	var titleFontColor: UIColor = Colors.fontColor
	var rateFont: UIFont = UIFont.systemFont(ofSize: 15)
	var rateFontColor: UIColor = Colors.fontColor
	var valueFont: UIFont = UIFont.systemFont(ofSize: 15)
	var valueFontColor: UIColor = Colors.fontColor
	var stageFont: UIFont = UIFont.systemFont(ofSize: 15)
	var stageFontColor: UIColor = Colors.fontColor
	var segmentFont: UIFont = UIFont.systemFont(ofSize: 15)
	var segmentFontColor: UIColor = Colors.fontColor
	var conversionRateFont: UIFont = UIFont.systemFont(ofSize: 15)
	var conversionRateFontColor: UIColor = Colors.fontColor
	var barColor: UIColor = UIColor.blue
	
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
		if (data.objective == .positive) {
			outputString.append(ZCRMUIUtil.getIncText(ofSize: (fontSize/2) + 3, baselineOffset: 2.5, color: options.positiveColor))
		} else if (data.objective == .negative) {
			outputString.append(ZCRMUIUtil.getDecText(ofSize: (fontSize/2) + 3, baselineOffset: 2, color: options.negativeColor))
		} else {
			outputString.append(ZCRMUIUtil.getNeutralText(ofSize: (fontSize/2) + 4, baselineOffset: 2.5, color: options.neutralColor))
		}
		outputString.append(NSAttributedString(string: data.rate, attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: (fontSize/2) + 1), NSForegroundColorAttributeName: options.rateFontColor, NSBaselineOffsetAttributeName: 2.5]))
		return outputString
	}
	
	static func getValueTextForGrowthIndexKPI(data: ZCRMKPIRow , options: KPIRenderOptions) -> NSMutableAttributedString {
		
		let fontSize = options.simpleKpiValueFont.pointSize
		var valueColor = options.neutralColor
		if data.objective == .positive {
			valueColor = options.positiveColor
		} else if data.objective == .negative {
			valueColor = options.negativeColor
		}
		let outputString: NSMutableAttributedString = NSMutableAttributedString(string: data.rate, attributes: [ NSFontAttributeName: options.simpleKpiValueFont, NSForegroundColorAttributeName: valueColor])
		outputString.append(NSAttributedString(string: " " + data.value, attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: (fontSize/2) + 1), NSForegroundColorAttributeName: options.valueFontColor, NSBaselineOffsetAttributeName: 2.5]))
		return outputString
	}
	
	static func getValueTextForBasicKPI(data: ZCRMKPIRow, options: KPIRenderOptions) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: data.value, attributes: [ NSFontAttributeName: options.simpleKpiValueFont, NSForegroundColorAttributeName: options.valueFontColor])
	}
	
}

internal struct ZCRMComparatorUIUtil {
	
	static func getTextForChunkData(_ chunkData: ZCRMChunkData, options: ComparatorRenderOptions, objective: ZCRMCharts.Outcome, isHeader: Bool) -> NSMutableAttributedString{
		
		let font: UIFont = isHeader ? options.groupFont : options.chunkDataFont
		let color: UIColor = isHeader ? options.groupFontColor : options.chunkDataFontColor
		let outputString: NSMutableAttributedString = NSMutableAttributedString(string: chunkData.label, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color])
		if chunkData.rate != nil {
			var rateColor: UIColor!
			if objective == .positive {
				rateColor = options.positiveColor
				outputString.append(ZCRMUIUtil.getIncText(ofSize: options.chunkDataFont.pointSize, baselineOffset: 0, color: rateColor))
			} else if objective == .negative {
				rateColor = options.negativeColor
				outputString.append(ZCRMUIUtil.getDecText(ofSize: options.chunkDataFont.pointSize, baselineOffset: 0, color: rateColor))
			} else {
				rateColor = options.neutralColor
				outputString.append(ZCRMUIUtil.getNeutralText(ofSize: options.chunkDataFont.pointSize, baselineOffset: 0, color: rateColor))
			}
			outputString.append(NSAttributedString(string: chunkData.rate, attributes: [ NSFontAttributeName: options.chunkDataFont, NSForegroundColorAttributeName : rateColor] ))
		}
		return outputString
	}
}

