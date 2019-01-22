//
//  ZCRMBarChart.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 03/12/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//
import UIKit

internal struct ZCRMBarData {
	
	internal let text: String
	internal let title: String
	internal let value: CGFloat
	
	internal init(text: String, title: String, value: CGFloat) {
		self.text = text
		self.title = title
		self.value = value
	}
	
	internal init(text: String, value: CGFloat) {
		self.init(text: text, title: "", value: value)
	}
}


internal final class ZCRMBarChart: UIStackView, ZCRMLayoutConstraintDelegate {
	
	internal var options: ZCRMBarChartOptions!
	internal var viewConstraints: [NSLayoutConstraint] = []
	internal var barWidth: CGFloat = 0
	internal var rateWidth: CGFloat = 0
	private var data: [ZCRMBarData]!
	private var rate: [ZCRMBarData]!
	private var maxValue: CGFloat!
	private let isTitleNeeded: Bool
	private let columnViewTag = 1
	private let rateViewTag = 2
	
	internal init(isTitleNeeded titleNeeded: Bool, options: ZCRMBarChartOptions) {
		self.isTitleNeeded = titleNeeded
		self.options = options
		super.init(frame: .zero)
		self.axis = .horizontal
		self.alignment = .center
		self.spacing = 0
	}
	
	internal required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		self.deactivateConstraints()
		self.addConstraints()
	}
	
	internal func setUIOptions() {
		
		for view in self.arrangedSubviews {
			if view.tag == self.columnViewTag {
				(view as! ZCRMBarChartColumn).options = self.options
				(view as! ZCRMBarChartColumn).setUIOptions()
			} else if view.tag == self.rateViewTag {
				(view as! ZCRMBarChartRate).options = self.options
				(view as! ZCRMBarChartRate).setUIOptions()
			}
		}
	}
	
	internal func setData(data: [ZCRMBarData], rate: [ZCRMBarData]) {
		self.data = data
		self.rate = rate
		if !data.isEmpty && !rate.isEmpty {
			self.maxValue = data.map({ (barData) -> CGFloat in
				return barData.value
			}).max()!
			self.setData()
		}
	}
	
	private func setData() {
		
		let length = self.data.count * 2 - 1
		for i in 0..<length {
			if i % 2 == 0 {
				self.addColumn(forData: self.data[i / 2])
			}
			else {
				self.addRate(forData: self.rate[(i - 1) / 2])
			}
		}
		if !self.isTitleNeeded {
			let spaceView = UIView()
			self.addArrangedSubview(spaceView)
		}
	}
	
	private func addColumn(forData data: ZCRMBarData) {
		
		let columnView = ZCRMBarChartColumn(self.isTitleNeeded, data: data, highValue: self.maxValue, options: self.options)
		columnView.translatesAutoresizingMaskIntoConstraints = false
		columnView.tag = self.columnViewTag
		self.addArrangedSubview(columnView)
	}
	
	private func addRate(forData data: ZCRMBarData) {
		
		let rateView = ZCRMBarChartRate(data: data, options: self.options)
		rateView.translatesAutoresizingMaskIntoConstraints = false
		rateView.tag = self.rateViewTag
		self.addArrangedSubview(rateView)
	}
	
	private func addConstraints() {
	
		var constraints: [NSLayoutConstraint] = []
		for (i, view) in self.arrangedSubviews.enumerated() {
			if view.tag == self.columnViewTag {
				
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[column\(i)]|", options: [], metrics: nil, views: ["column\(i)": view] )
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[column\(i)(width)]", options: [], metrics: ["width": self.barWidth], views: ["column\(i)": view])
			} else if view.tag == self.rateViewTag {
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[column\(i)]|", options: [], metrics: nil, views: ["column\(i)": view] )
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[column\(i)(width)]", options: [], metrics: ["width": self.rateWidth], views: ["column\(i)": view])
			}
		}
		self.activate(constraints: constraints)
	}
}

internal final class ZCRMBarChartColumn: ZCRMView {
	
	internal var options: ZCRMBarChartOptions!
	private let columnView: UIView = UIView()
	private let valueView: UILabel = UILabel()
	private let titleView: UILabel = UILabel()
	private let isTitleNeeded: Bool
	private let data: ZCRMBarData
	private let highValue: CGFloat
	
	internal init(_ isTitleNeeded: Bool, data: ZCRMBarData, highValue: CGFloat, options: ZCRMBarChartOptions) {
		self.isTitleNeeded = isTitleNeeded
		self.data = data
		self.highValue = highValue
		self.options = options
		super.init(frame: .zero)
	}
	
	internal required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	internal func setUIOptions() {
		
		self.columnView.backgroundColor = self.options.barColor
		self.titleView.font = self.options.labelFont
		self.titleView.textColor = self.options.labelFontColor
		self.valueView.font = self.options.valueFont
		self.valueView.textColor = self.options.valueFontColor
	}

	internal override func willAddSubviews() {
		
		self.setUIOptions()
		self.columnView.translatesAutoresizingMaskIntoConstraints = false
		
		self.valueView.translatesAutoresizingMaskIntoConstraints = false
		self.valueView.textAlignment = .center
		self.valueView.minimumScaleFactor = 0.8
		self.valueView.adjustsFontSizeToFitWidth = true
		self.valueView.numberOfLines = 2
		self.valueView.text = self.data.text

		if self.isTitleNeeded {
			self.titleView.translatesAutoresizingMaskIntoConstraints = false
			self.titleView.textAlignment = .center
			self.titleView.minimumScaleFactor = 0.8
			self.titleView.adjustsFontSizeToFitWidth = true
			self.titleView.numberOfLines = 2
			self.titleView.text = self.data.title
		}
	}
	
	internal override func addSubviews() {
		
		self.addSubview(self.columnView)
		self.addSubview(self.valueView)
		if self.isTitleNeeded {
			self.addSubview(self.titleView)
		}
	}
	
	internal override func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		let space = self.frame.width * 0.2
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(space)-[column]-\(space)-|", options: [], metrics: nil, views: ["column": self.columnView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[value]|", options: [], metrics: nil, views: ["value": self.valueView])
		if self.isTitleNeeded {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[title]|", options: [], metrics: nil, views: ["title": self.titleView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[value]-2-[column(columnHeight)]-2-[title(titleHeight)]-2-|", options: [], metrics: ["columnHeight": self.getColumnHeight(), "titleHeight": self.frame.height * 0.15], views: ["title": self.titleView, "column": self.columnView, "value": self.valueView])
		} else {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[value]-[column(columnHeight)]-2-|", options: [], metrics: ["columnHeight": self.getColumnHeight()], views: ["column": self.columnView, "value": self.valueView])
		}
		self.activate(constraints: constraints)
	}
	
	private func getColumnHeight() -> CGFloat {
		
		let heightPercent: CGFloat = self.isTitleNeeded ? 0.75 : 0.85
		let onePercentHeight = (self.frame.height * heightPercent) / 100
		let percentOfDiff = (self.data.value * 100) / self.highValue
		return onePercentHeight * percentOfDiff
	}
}

internal final class ZCRMBarChartRate: ZCRMView {
	
	internal var options: ZCRMBarChartOptions = ZCRMBarChartOptions()
	private let rateView: UILabel = UILabel()
	private let arrowView: UILabel = UILabel()
	private let data: ZCRMBarData
	
	internal init(data: ZCRMBarData, options: ZCRMBarChartOptions) {
		self.data = data
		self.options = options
		super.init(frame: .zero)
	}
	
	internal required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	internal override func willAddSubviews() {
		
		self.rateView.translatesAutoresizingMaskIntoConstraints = false
		self.rateView.numberOfLines = 2
		self.rateView.adjustsFontSizeToFitWidth = true
		self.rateView.minimumScaleFactor = 0.8
		self.rateView.textAlignment = .center
		self.rateView.text = self.data.text
		
		self.arrowView.translatesAutoresizingMaskIntoConstraints = false
		self.arrowView.numberOfLines = 1
		self.arrowView.adjustsFontSizeToFitWidth = true
		self.arrowView.minimumScaleFactor = 0.8
		self.arrowView.textAlignment = .center
		self.arrowView.text = "➔"
		self.setUIOptions()
	}
	
	internal override func addSubviews() {
		
		self.addSubview(self.rateView)
		self.addSubview(self.arrowView)
	}
	
	internal override func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[rate]|", options: [], metrics: nil, views: ["rate": self.rateView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[arrow]|", options: [], metrics: nil, views: ["arrow": self.arrowView])
		constraints.append(NSLayoutConstraint(item: self.rateView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		constraints.append(NSLayoutConstraint(item: self.arrowView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		self.activate(constraints: constraints)
	}
	
	internal func setUIOptions() {
		self.rateView.textColor = self.options.rateFontColor
		self.rateView.font = self.options.rateFont
		self.arrowView.textColor = self.options.rateFontColor
		self.arrowView.font = self.options.rateFont
	}
}

internal struct ZCRMBarChartOptions {
	
	var barColor: UIColor = .lightGray
	var labelFont: UIFont = UIFont.systemFont(ofSize: 13)
	var labelFontColor: UIColor = .black
	var valueFont: UIFont = UIFont.systemFont(ofSize: 10)
	var valueFontColor: UIColor = .black
	var rateFont: UIFont = UIFont.systemFont(ofSize: 13)
	var rateFontColor: UIColor = .black
}
