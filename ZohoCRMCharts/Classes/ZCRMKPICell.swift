//
//  ZCRMKPICell.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

internal final class ZCRMKPICell : UITableViewCell, KPIUtil, ZCRMLayoutConstraintDelegate {
	
	public var rowLabel: UILabel = UILabel() // for both scorecard and rankings
	public var valueLabel: UILabel = UILabel() // for both scorecard and rankings
	public var rateLabel: UILabel = UILabel() // for scorecard
	public var rateBar: UIView = UIView() // for both rankings
	private var rightContainer: UIView = UIView() // for both scorecard and rankings
	
	internal var type: ZCRMCharts.ZCRMKPIType
	internal var viewConstraints: [NSLayoutConstraint] = []
	private var data : ZCRMKPIRow
	private var options: KPIRenderOptions
	private var highRate: CGFloat!
	
	init(data: ZCRMKPIRow, type: ZCRMCharts.ZCRMKPIType, options: KPIRenderOptions) {
		self.data = data
		self.type = type
		self.options = options
		super.init(style: .default, reuseIdentifier: "zcrmScorecardCell")
		self.render()
	}
	
	init(data: ZCRMKPIRow, type: ZCRMCharts.ZCRMKPIType, highRate: CGFloat, options: KPIRenderOptions) {
		self.data = data
		self.type = type
		self.highRate = highRate
		self.options = options
		super.init(style: .default, reuseIdentifier: "zcrmScorecardCell")
		self.render()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func render() {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.renderView()
		if self.isScorecard {
			self.renderData()
		}
	}
	
	override func layoutSubviews() {

		self.deactivateConstraints()
		self.addConstraints()
		if self.isRankings {
			self.renderData()
		}
	}
	
	private func renderView() {
		
		//adding subviews
		self.rowLabel.translatesAutoresizingMaskIntoConstraints = false
		self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
		self.rateLabel.translatesAutoresizingMaskIntoConstraints = false
		self.rateBar.translatesAutoresizingMaskIntoConstraints = false
		self.rightContainer.translatesAutoresizingMaskIntoConstraints = false
		self.rightContainer.addSubview(self.valueLabel)
		self.contentView.addSubview(self.rowLabel)
		self.contentView.addSubview(self.rightContainer)
		if self.isScorecard {
			self.rightContainer.addSubview(self.rateLabel)
		} else {
			self.rightContainer.addSubview(self.rateBar)
		}
	}
	
	private func addConstraints() {

		var constraints : [NSLayoutConstraint] = []
		
		// common constraints
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[value]-0-|", options: [], metrics: nil, views: ["value": self.valueLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[label(==container)]-0-[container(==label)]-|", options: [], metrics: nil, views: ["label": self.rowLabel, "container": self.rightContainer])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label(==container)]-0-|", options: [], metrics: nil, views: ["label": self.rowLabel, "container": self.rightContainer])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[container]-0-|", options: [], metrics: nil, views: ["container": self.rightContainer])
		self.activate(constraints: constraints)
		constraints.removeAll()
		self.rightContainer.layoutIfNeeded()
		
		if self.isScorecard {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[value(>=rate@250)]-0-[rate(==\(self.getWidthOf(percent: 17)))]-0-|", options: [], metrics: nil, views: ["value" : self.valueLabel, "rate": self.rateLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[rate]-4-|", options: [], metrics: nil, views: ["rate": self.rateLabel])
		} else {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[value(valueWidth)]-\(self.rightContainer.frame.width * 0.02)-[rate(rateWidth)]", options: [], metrics: ["rateWidth": self.getRateBarLenght(), "valueWidth": self.rightContainer.frame.width * 0.4], views: ["value" : self.valueLabel, "rate": self.rateBar])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[rate]-12-|", options: [], metrics: nil, views: ["rate": self.rateBar])
		}
		self.activate(constraints: constraints)
	}
	
	/**
		Set the data to the cell common for scorecard and rankings KPI.
	*/
	private func renderData() {
		
		self.rowLabel.attributedText = NSMutableAttributedString(string: self.data.displayLabel, attributes: [ NSFontAttributeName : self.options.labelFont, NSForegroundColorAttributeName : self.options.labelFontColor, NSBaselineOffsetAttributeName: 0])
		self.valueLabel.attributedText = NSMutableAttributedString(string: self.data.displayValue , attributes: [ NSFontAttributeName : self.options.valueFont, NSForegroundColorAttributeName: self.options.valueFontColor, NSBaselineOffsetAttributeName: 0])
		
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
		
		self.rateLabel.attributedText = NSMutableAttributedString(string: self.data.rate, attributes: [ NSFontAttributeName:  self.options.rateFont, NSForegroundColorAttributeName: self.options.rateFontColor, NSBaselineOffsetAttributeName: 0])
		self.rateLabel.textAlignment = .center
		self.rateLabel.layer.cornerRadius = 5
		self.rateLabel.clipsToBounds = true
		self.rateLabel.backgroundColor = self.options.neutralColor
		if self.data.outcome == .positive {
			self.rateLabel.backgroundColor = self.options.positiveColor
		} else if self.data.outcome == .negative {
			self.rateLabel.backgroundColor = self.options.negativeColor
		}
	}
	
	/**
		Sets the rate bar for rankings KPI.
	*/
	private func setRateBar() {
		
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
		
		let availaleSpace: CGFloat = self.rightContainer.frame.width * 0.58
		let onePercentOfSpace: CGFloat = availaleSpace / 100
		let percentOfDiff: CGFloat = (self.data.value.toCGFloat() * 100) / self.highRate
		return (onePercentOfSpace * percentOfDiff)
	}
}
