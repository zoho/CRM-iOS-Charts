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
	
	private var valueLabel: UILabel = UILabel()
	private var differenceLabel: UILabel = UILabel()
	private var rateLabel: UILabel = UILabel()
	private var rateBar: UIView = UIView()
	private var rightContainer: UIView = UIView()
	
	private var type: ZCRMKPIComponent!
	private var data : ZCRMKPIRow!
	private var highRate: CGFloat!
	
	init(data: ZCRMKPIRow, type: ZCRMKPIComponent) {
		super.init(style: .default, reuseIdentifier: "zcrmScorecardCell")
		self.data = data
		self.type = type
		self.render()
	}
	
	init(data: ZCRMKPIRow, type: ZCRMKPIComponent, highRate: CGFloat) {
		super.init(style: .default, reuseIdentifier: "zcrmScorecardCell")
		self.data = data
		self.type = type
		self.highRate = highRate
		self.render()
	}
	
	required init?(coder aDecoder: NSCoder) {
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
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[difference]-[rate(==60@100)]-|", options: [], metrics: nil, views: ["difference" : self.differenceLabel, "rate": self.rateLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[rate]-4-|", options: [], metrics: nil, views: ["rate": self.rateLabel])
		} else {
			self.rightContainer.addSubview(self.rateBar)
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[difference(==\(self.getWidthOf(percent: 20)))]-[rate(==\(self.getRateBarLenght()))]", options: [], metrics: nil, views: ["difference" : self.differenceLabel, "rate": self.rateBar])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[rate]-12-|", options: [], metrics: nil, views: ["rate": self.rateBar])
		}
		// common
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[difference]-0-|", options: [], metrics: nil, views: ["difference": self.differenceLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[value(==container)]-0-[container]-|", options: [], metrics: nil, views: ["value": self.valueLabel, "container": self.rightContainer])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[value(==container)]-0-|", options: [], metrics: nil, views: ["value": self.valueLabel, "container": self.rightContainer])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[container]-0-|", options: [], metrics: nil, views: ["container": self.rightContainer])
		NSLayoutConstraint.activate(constraints)
	}
	
	/**
	Set the data to the cell common for scorecard and rankings KPI.
	*/
	private func renderData(fontSize : CGFloat = 20, color: UIColor = UIColor.white, baselineOffset: NSNumber = 0) {
		
		self.valueLabel.attributedText = NSMutableAttributedString(string: self.data.value, attributes: [.font : UIFont.systemFont(ofSize: fontSize), .foregroundColor : color, .baselineOffset: baselineOffset])
		self.differenceLabel.attributedText = NSMutableAttributedString(string: self.data.difference , attributes: [.font : UIFont.systemFont(ofSize: fontSize), .foregroundColor : color, .baselineOffset: baselineOffset])
		
		if self.type == .scorecard {
			self.setRateText()
		} else if self.type == .rankings {
			self.setRateBar()
		}
	}
	
	/**
	Sets the text for rate only for scorecard KPI.
	*/
	private func setRateText(fontSize : CGFloat = 20, color: UIColor = UIColor.white, baselineOffset: NSNumber = 0) {
		
		self.rateLabel.attributedText = NSMutableAttributedString(string: self.data.rate, attributes: [.font : UIFont.systemFont(ofSize: fontSize), .foregroundColor : color, .baselineOffset: baselineOffset])
		self.rateLabel.textAlignment = .center
		self.rateLabel.layer.cornerRadius = 5
		self.rateLabel.clipsToBounds = true
		
		// bg color change
		var bgColor: UIColor = incrementColor // MARK: - to change
		if self.data.status == .decreased {
			bgColor = decrementColor // MARK: - to change
		} else if self.data.status == .neutral {
			bgColor = UIColor.yellow
		}
		self.rateLabel.backgroundColor = bgColor
	}
	
	private func setRateBar(color: UIColor = rateBarColor) {
		
		self.rateBar.layoutIfNeeded()
		self.rateBar.layer.cornerRadius = 5
		self.rateBar.clipsToBounds = true
		self.rateBar.backgroundColor = color
	}
	
	private func getRateBarLenght() -> CGFloat {
		
		let availaleSpace = self.getWidthOf(percent: 33)
		let onePercentOfSpace = availaleSpace / 100
		let percentOfDiff = (self.data.difference.toCGFloat() * 100) / self.highRate
		return (onePercentOfSpace * percentOfDiff)
	}
}
