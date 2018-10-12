//
//  ZCRMKPICell.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import Foundation
import UIKit

internal class ZCRMKPICell : UITableViewCell {
	
	public var valueLabel: UILabel = UILabel()
	public var differenceLabel: UILabel = UILabel()
	public var rateLabel: UILabel = UILabel()
	public var rateBar: UIView = UIView()
	private var rightContainer: UIView = UIView()
	
	private var type: ZCRMKPIComponent!
	private var data : ZCRMKPIRow!
	private var highRate: CGFloat!
	private var options: KPIRenderOptions!
	
	init(data: ZCRMKPIRow, type: ZCRMKPIComponent, options: KPIRenderOptions) {
		super.init(style: .default, reuseIdentifier: "zcrmScorecardCell")
		self.data = data
		self.type = type
		self.options = options
		self.render()
	}
	
	init(data: ZCRMKPIRow, type: ZCRMKPIComponent, highRate: CGFloat, options: KPIRenderOptions) {
		super.init(style: .default, reuseIdentifier: "zcrmScorecardCell")
		self.data = data
		self.type = type
		self.highRate = highRate
		self.options = options
		self.render()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func render() {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.renderView()
		self.renderData()
	}
	
	private func renderView() {
		
		//adding subviews
		self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
		self.differenceLabel.translatesAutoresizingMaskIntoConstraints = false
		self.rateLabel.translatesAutoresizingMaskIntoConstraints = false
		self.rateBar.translatesAutoresizingMaskIntoConstraints = false
		self.rightContainer.translatesAutoresizingMaskIntoConstraints = false
		self.rightContainer.addSubview(self.differenceLabel)
		self.contentView.addSubview(self.valueLabel)
		self.contentView.addSubview(self.rightContainer)
		
		//constraints
		var constraints : [NSLayoutConstraint] = []
		if self.type == .scorecard {
			self.rightContainer.addSubview(self.rateLabel)
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[difference(==\(self.getWidthOf(percent: 25)))]-[rate(==\(self.getWidthOf(percent: 20)))]", options: [], metrics: nil, views: ["difference" : self.differenceLabel, "rate": self.rateLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[rate]-4-|", options: [], metrics: nil, views: ["rate": self.rateLabel])
		} else {
			self.rightContainer.addSubview(self.rateBar)
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[difference(==\(self.getWidthOf(percent: 17)))]-[rate(==\(self.getRateBarLenght()))]", options: [], metrics: nil, views: ["difference" : self.differenceLabel, "rate": self.rateBar])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[rate]-12-|", options: [], metrics: nil, views: ["rate": self.rateBar])
		}
		// common
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[difference]-0-|", options: [], metrics: nil, views: ["difference": self.differenceLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[value(==\(self.getWidthOf(percent: 58)))]-0-[container(==value)]", options: [], metrics: nil, views: ["value": self.valueLabel, "container": self.rightContainer])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[value(==container)]-0-|", options: [], metrics: nil, views: ["value": self.valueLabel, "container": self.rightContainer])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[container]-0-|", options: [], metrics: nil, views: ["container": self.rightContainer])
		NSLayoutConstraint.activate(constraints)
	}
	
	/**
	Set the data to the cell common for scorecard and rankings KPI.
	*/
	private func renderData() {
		
		self.valueLabel.attributedText = NSMutableAttributedString(string: self.data.value, attributes: [.font : self.options.valueFont, .foregroundColor : self.options.valueFontColor, .baselineOffset: 0])
		self.differenceLabel.attributedText = NSMutableAttributedString(string: self.data.difference , attributes: [.font : self.options.differenceFont, .foregroundColor : self.options.differenceFontColor, .baselineOffset: 0])
		
		if self.type == .scorecard {
			self.setRateText()
		} else if self.type == .rankings {
			self.setRateBar()
		}
	}
	
	/**
	Sets the text for rate only for scorecard KPI.
	*/
	private func setRateText() {
		
		self.rateLabel.attributedText = NSMutableAttributedString(string: self.data.rate, attributes: [.font : options.rateFont, .foregroundColor : self.options.rateFontColor, .baselineOffset: 0])
		self.rateLabel.textAlignment = .center
		self.rateLabel.layer.cornerRadius = 5
		self.rateLabel.clipsToBounds = true
		self.rateLabel.backgroundColor = self.options.neutralColor
		if self.data.objective == .increased {
			self.rateLabel.backgroundColor = self.options.incrementColor
		} else if self.data.objective == .decreased {
			self.rateLabel.backgroundColor = self.options.decrementColor
		}
		
	}
	
	private func setRateBar() {
		
		self.rateBar.layoutIfNeeded()
		self.rateBar.layer.cornerRadius = 5
		self.rateBar.clipsToBounds = true
		self.rateBar.backgroundColor = self.options.rateBarColor
	}
	
	private func getRateBarLenght() -> CGFloat {
		
		let availaleSpace = self.getWidthOf(percent: 35)
		let onePercentOfSpace = availaleSpace / 100
		let percentOfDiff = (self.data.difference.toCGFloat() * 100) / self.highRate
		return (onePercentOfSpace * percentOfDiff)
	}
}
