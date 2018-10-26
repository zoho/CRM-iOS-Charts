//
//  ZCRMKPICell.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import Foundation
import UIKit

internal class ZCRMKPICell : UITableViewCell, KPIUtil {
	
	public var rowLable: UILabel = UILabel() // for both scorecard and rankings
	public var valueLabel: UILabel = UILabel() // for both scorecard and rankings
	public var rateLabel: UILabel = UILabel() // for scorecard
	public var rateBar: UIView = UIView() // for both rankings
	private var rightContainer: UIView = UIView() // for both scorecard and rankings
	
	internal var type: ZCRMKPIComponent!
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
		self.rowLable.translatesAutoresizingMaskIntoConstraints = false
		self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
		self.rateLabel.translatesAutoresizingMaskIntoConstraints = false
		self.rateBar.translatesAutoresizingMaskIntoConstraints = false
		self.rightContainer.translatesAutoresizingMaskIntoConstraints = false
		self.rowLable.adjustsFontSizeToFitWidth = true
		self.valueLabel.adjustsFontSizeToFitWidth = true
		self.rateLabel.adjustsFontSizeToFitWidth = true
		self.rightContainer.addSubview(self.valueLabel)
		self.contentView.addSubview(self.rowLable)
		self.contentView.addSubview(self.rightContainer)
		
		//constraints
		var constraints : [NSLayoutConstraint] = []
		if self.isScorecard {
			self.rightContainer.addSubview(self.rateLabel)
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[value(>=rate@250)]-0-[rate(==\(self.getWidthOf(percent: 17)))]-0-|", options: [], metrics: nil, views: ["value" : self.valueLabel, "rate": self.rateLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[rate]-4-|", options: [], metrics: nil, views: ["rate": self.rateLabel])
		} else {
			self.rightContainer.addSubview(self.rateBar)
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[value(==\(self.getWidthOf(percent: 17)))]-[rate(==\(self.getRateBarLenght()))]", options: [], metrics: nil, views: ["value" : self.valueLabel, "rate": self.rateBar])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[rate]-12-|", options: [], metrics: nil, views: ["rate": self.rateBar])
		}
		// common constraints
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[value]-0-|", options: [], metrics: nil, views: ["value": self.valueLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[label(==container)]-0-[container(==label)]-|", options: [], metrics: nil, views: ["label": self.rowLable, "container": self.rightContainer])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label(==container)]-0-|", options: [], metrics: nil, views: ["label": self.rowLable, "container": self.rightContainer])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[container]-0-|", options: [], metrics: nil, views: ["container": self.rightContainer])
		NSLayoutConstraint.activate(constraints)
	}
	
	/**
		Set the data to the cell common for scorecard and rankings KPI.
	*/
	private func renderData() {
		
		self.rowLable.attributedText = NSMutableAttributedString(string: self.data.label, attributes: [.font : self.options.labelFont, .foregroundColor : self.options.labelFontColor, .baselineOffset: 0])
		self.valueLabel.attributedText = NSMutableAttributedString(string: self.data.value , attributes: [.font : self.options.valueFont, .foregroundColor : self.options.valueFontColor, .baselineOffset: 0])
		
		if self.isScorecard {
			self.setRateText()
		} else if self.isRankings {
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
	
	/**
		Sets the rate bar for rankings KPI.
	*/
	private func setRateBar() {
		
		self.rateBar.layoutIfNeeded()
		self.rateBar.layer.cornerRadius = 5
		self.rateBar.clipsToBounds = true
		self.rateBar.backgroundColor = self.options.rateBarColor
	}
	
	/**
		Returns the ratebar length for the current instance.
		- returns:
				The rate bar length.
	*/
	private func getRateBarLenght() -> CGFloat {
		
		let availaleSpace = self.getWidthOf(percent: 35)
		let onePercentOfSpace = availaleSpace / 100
		let percentOfDiff = (self.data.value.toCGFloat() * 100) / self.highRate
		return (onePercentOfSpace * percentOfDiff)
	}
}
