//
//  ZCRMBarChart.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 03/12/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//
import UIKit

internal final class ZCRMBarChart: UIView {
	

	internal var color: UIColor!
	internal var barWidth: CGFloat = 0
	internal var rates: [String] = []
	internal var maxValue: CGFloat = 0
	internal var valueFontColor: UIColor = .black
	internal var rateFontColor: UIColor = .black
	internal var titleFontColor: UIColor = .black
	internal var data: [ZCRMBarData] = []
	internal var space: CGFloat = 0
	
	private let mainLayer: CALayer = CALayer()
	
	private var bottomSpace: CGFloat {
		return self.frame.height * 0.1
	}
	private var topSpace: CGFloat {
		return self.frame.height * 0.1
	}
	
	internal init() {
		
		super.init(frame: .zero)
		self.layer.addSublayer(self.mainLayer)
		self.layer.masksToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		
		if self.data.count > 0 {
			self.render()
		}
	}
	
	func render() {
		
		self.mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
		self.subviews.forEach({$0.removeFromSuperview()})
		self.mainLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
		
		for i in 0..<(self.data.count * 2) - 1 {
			if i % 2 == 0 {
				self.addBar(index: i, data: self.data[i / 2])
			} else {
				self.addRatetext(index: i, rate: self.rates[((i + 1) / 2) - 1])
			}
		}
	}
	
	private func addBar(index: Int, data: ZCRMBarData) {
		
		let x: CGFloat = index.toCGFloat() * self.space + index.toCGFloat() * (self.barWidth + self.space) + self.space
		let y: CGFloat = self.getBarYPos(value: data.value)
		self.drawBar(x: x, y: y)
		self.addText(x: x, y: y - self.topSpace, text: String(data.value.toInt()), color: self.valueFontColor)
		self.addLabel(x: x, y: mainLayer.frame.height - self.bottomSpace - 3, text: data.title)
	}
	
	private func addRatetext(index: Int, rate: String) {
		
		let x: CGFloat = index.toCGFloat() * self.space + index.toCGFloat() * (self.barWidth + self.space) + self.space
		let y: CGFloat = (self.mainLayer.frame.height - self.topSpace - self.bottomSpace) / 2
		self.addText(x: x, y: y, text: rate, color: self.rateFontColor)
		self.drawArrowText(x: x, y: y + 30)
	}
	
	private func addText(x: CGFloat, y: CGFloat, text: String, color: UIColor) {
		
		let textLayer: CATextLayer = CATextLayer()
		textLayer.frame = CGRect(x: x, y: y, width: self.barWidth, height: self.topSpace)
		textLayer.backgroundColor = UIColor.clear.cgColor
		textLayer.alignmentMode = kCAAlignmentCenter
		textLayer.contentsScale = UIScreen.main.scale
		textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
		textLayer.fontSize = 14
		textLayer.foregroundColor = color.cgColor
		textLayer.string = text
		self.mainLayer.addSublayer(textLayer)
	}
	
	private func addLabel(x: CGFloat, y: CGFloat, text: String) {
		
		let label: UILabel = UILabel(frame: CGRect(x: x, y: y, width: self.barWidth, height: 30))
		label.text = text
		label.numberOfLines = 2
		label.textAlignment = .center
		label.contentScaleFactor = UIScreen.main.scale
		label.font = UIFont.systemFont(ofSize: 10)
		label.textColor = self.titleFontColor
		label.adjustsFontSizeToFitWidth = true
		self.addSubview(label)
	}
	
	private func drawBar(x: CGFloat, y: CGFloat) {
		
		let bar = CALayer()
		bar.frame = CGRect(x: x, y: y, width: self.barWidth, height: self.mainLayer.frame.height - bottomSpace - y)
		bar.backgroundColor = self.color.cgColor
		self.mainLayer.addSublayer(bar)
	}
	
	private func drawArrowText(x: CGFloat, y: CGFloat) {
		
		let textLayer: CATextLayer = CATextLayer()
		textLayer.frame = CGRect(x: x, y: y, width: self.barWidth, height: 30)
		textLayer.backgroundColor = UIColor.clear.cgColor
		textLayer.alignmentMode = kCAAlignmentCenter
		textLayer.contentsScale = UIScreen.main.scale
		textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
		textLayer.fontSize = 14
		textLayer.foregroundColor = self.rateFontColor.cgColor
		textLayer.string = "➞"
		self.mainLayer.addSublayer(textLayer)
	}
	
	private func getBarYPos(value: CGFloat) -> CGFloat {
	
		let heightPercent = (value * 100) / self.maxValue
		let maxHeight = self.mainLayer.frame.height - self.bottomSpace - self.topSpace
		let onePercentOfHeight = maxHeight / 100
		return self.mainLayer.frame.height - self.bottomSpace - (onePercentOfHeight * heightPercent)
	}
}

internal struct ZCRMBarData {
	
	internal var text: String!
	internal var title: String!
	internal var value: CGFloat!
}
