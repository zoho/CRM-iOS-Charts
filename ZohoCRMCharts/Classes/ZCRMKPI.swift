//
//  ZCRMKPI.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 08/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

public class ZCRMKPI :UIView {

	public var titleFont: UIFont! {
		didSet {
			if titleFont != nil {
				self.renderOptions.titleFont = titleFont
				self.updateTitleText()
			}
		}
	}
	
	public var titleFontColor: UIColor! {
		didSet {
			if titleFontColor != nil {
				self.renderOptions.titleFontColor = titleFontColor
				self.updateTitleText()
			}
		}
	}
	

	
	public var comparedToFont: UIFont! {
		didSet {
			if comparedToFont != nil {
				self.renderOptions.comparedToFont = comparedToFont
				self.updateComparedToViewText(text: nil)
			}
		}
	}
	
	public var comparedToFontColor: UIColor! {
		didSet {
			if comparedToFontColor != nil {
				self.renderOptions.comparedToFontColor = comparedToFontColor
				self.updateComparedToViewText(text: nil)
			}
		}
	}
	
	public var valueFont: UIFont! {
		didSet {
			if valueFont != nil {
				self.renderOptions.valueFont = valueFont
				self.updateChanges()
			}
		}
	}
	
	public var valueFontColor: UIColor! {
		didSet {
			if valueFontColor != nil {
				self.renderOptions.valueFontColor = valueFontColor
				self.updateChanges()
			}
		}
	}
	
	public var differenceFont: UIFont! {
		didSet {
			if differenceFont != nil {
				self.renderOptions.differenceFont = differenceFont
				self.updateChanges()
			}
		}
	}
	
	public var differenceFontColor: UIColor! {
		didSet {
			if differenceFontColor != nil {
				self.renderOptions.differenceFontColor = differenceFontColor
				self.updateChanges()
			}
		}
	}
	
	public var rateFont: UIFont! {
		didSet {
			if rateFont != nil {
				self.renderOptions.rateFont = rateFont
				self.updateChanges()
			}
		}
	}
	public var rateFontColor: UIColor! {
		didSet {
			if rateFontColor != nil {
				self.renderOptions.rateFontColor = rateFontColor
				self.updateChanges()
			}
		}
	}
	
	public var incrementColor: UIColor! {
		didSet {
			if incrementColor != nil {
				self.renderOptions.incrementColor = incrementColor
				self.updateChanges()
			}
		}
	}
	public var decrementColor: UIColor! {
		didSet {
			if decrementColor != nil {
				self.renderOptions.decrementColor = decrementColor
				self.updateChanges()
			}
		}
	}
	public var neutralColor: UIColor! {
		didSet {
			if neutralColor != nil {
				self.renderOptions.neutralColor = neutralColor
				self.updateChanges()
			}
		}
	}
	
	public var rateBarColor: UIColor! {
		didSet {
			if rateBarColor != nil {
				self.renderOptions.rateBarColor = rateBarColor
				self.updateChanges()
			}
		}
	}
	
	public var data: [ZCRMKPIRow] = [] {
		didSet {
			self.renderKPIData()
		}
	}
	
	public var comparedTo: String!  {
		didSet {
			if comparedTo != nil && self.type != .rankings && self.type != .basic {
				self.updateComparedToViewText(text: comparedTo)
			}
		}
	}
	
	private var title: String!
	private var type: ZCRMKPIComponent!
	private var titleView: UILabel =  UILabel()
	private let comparedToView = UILabel()
	private let valueView = UILabel()
	private var tableView = UITableView()
	private var renderOptions = KPIRenderOptions()
	
	public init(frame: CGRect, data: [ZCRMKPIRow], type: ZCRMKPIComponent, title :String) {
		super.init(frame: frame)
		self.data = data
		self.type = type
		self.title = title
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.render()
	}
	
	public init(frame: CGRect, type: ZCRMKPIComponent, title: String) {
		super.init(frame: frame)
		self.type = type
		self.title = title
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.render()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	/**
		Renders the corresponding KPI component with the data. If data is not available it won't do any changes.
	*/
	private func render() {
		
		self.clipsToBounds = true
		self.layoutIfNeeded()
		self.backgroundColor = UIColor(red: 182/255.0, green: 186/255.0, blue: 193/255.0, alpha: 1)
		if self.type == .rankings || self.type == .scorecard {
			self.tableView.dataSource = self
			self.tableView.delegate = self
		}
		
		self.setUpTitleView()
		self.updateTitleText()
		self.renderKPIView()
		if (self.data.count > 0) {
			self.renderKPIData()
		}
		
	}
	
	/**
		Renders the KPI corresponding to its type.
	*/
	private func renderKPIView() {
		
		if self.type == .rankings || self.type == .scorecard {
			self.setKpiView()
		} else {
			self.setSimpleKpiView()
		}
	}
	
	/**
		Renders the KPI data if changed occured in data.
	*/
	private func renderKPIData() {
		
		if self.type == .rankings || self.type == .scorecard {
			self.addKpiConstraints()
			self.setKpiData()
		} else {
			self.addSimpleKpiConstraints()
			self.setSimpleKpiData()
		}
	}
	
	/**
		Sets the view position of the title label. It will be common for all types.
	*/
	private func setUpTitleView() {
		
		self.titleView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.titleView)
		NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]-|", options: [], metrics: nil, views: ["title": self.titleView]))
		
	}
	
	/**
		Updates the title view with the given options.
	*/
	private func updateTitleText() {

		self.titleView.attributedText = NSAttributedString(string: self.title, attributes: [.font : self.renderOptions.titleFont, .foregroundColor: self.renderOptions.titleFontColor ])
	}
	
	/**
		Sets the compared to text for standard, growth index and scorecard KPI.
	*/
	private func updateComparedToViewText(text: String?) {
		
		var textToFit = ""
		if let givenText = text {
			textToFit = givenText
		} else if let attrStr = self.comparedToView.attributedText {
			textToFit = attrStr.string
		}
		self.comparedToView.attributedText = NSAttributedString(string: textToFit, attributes: [ .font: self.renderOptions.comparedToFont, .foregroundColor: self.renderOptions.comparedToFontColor])
	}
	
	/**
		Sets the view for standard, growth index and basic KPI.
	*/
	private func setSimpleKpiView(){
		
		self.valueView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.valueView)
		if (self.type != .basic){
			self.comparedToView.translatesAutoresizingMaskIntoConstraints = false
			self.comparedToView.textAlignment = .right
			self.addSubview(self.comparedToView)
		}
		
	}
	
	/**
		Adds the constraints for the simple KPI.
	*/
	private func addSimpleKpiConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[title]-[value]-10-|", options: [], metrics: nil, views: ["title": self.titleView, "value": valueView])
		if (self.type != .basic){
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[value(==comparedTo)]-[comparedTo]-15-|", options: [.alignAllBottom], metrics: nil, views: ["value": valueView, "comparedTo": self.comparedToView])
		} else {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[value]", options: [], metrics: nil, views: ["value": valueView])
		}
		NSLayoutConstraint.activate(constraints)
	}
	
	/**
		Sets the data for standard, growth index and basic KPI.
	*/
	private func setSimpleKpiData() {
		
		var data: ZCRMKPIRow!
		if self.data.count != 0 {
			data = self.data[0]
		} else {
			data = ZCRMKPIRow(value: "", difference: "", objective: .neutral)
		}
		if self.type == .standard {
			self.valueView.attributedText = ZCRMKPIUIUtil.shared.getValueTextForStandardKPI(data: data, options: self.renderOptions )
		} else if self.type == .growthIndex {
			self.valueView.attributedText = ZCRMKPIUIUtil.shared.getValueTextForGrowthIndexKPI(data: data, options: self.renderOptions)
		} else if self.type == .basic {
			self.valueView.attributedText = ZCRMKPIUIUtil.shared.getValueTextForBasicKPI(data: data, options: self.renderOptions )
		}
	}
	
	/**
		Sets the view for scorecard KPI.comparedToFont
	*/
	private func setKpiView() {
		
		self.tableView.dataSource = self
		self.tableView.isScrollEnabled = false
		self.tableView.allowsSelection = false
		self.tableView.separatorStyle = .none
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.backgroundColor = self.backgroundColor
		self.addSubview(self.tableView)
		
		if self.type == .scorecard {
			self.comparedToView.translatesAutoresizingMaskIntoConstraints = false
			self.comparedToView.backgroundColor = self.backgroundColor
			self.comparedToView.textAlignment = .left
			self.addSubview(self.comparedToView)
		}
		
	}
	
	/**
		Adds the constraints for the scorecard KPI.
	*/
	private func addKpiConstraints() {
		
		let cellHeight: CGFloat = 40
		self.tableView.layoutIfNeeded()
		self.tableView.rowHeight = cellHeight
		var tVHeight: CGFloat = self.getHeightOf(percent: 70)
		if tVHeight  > (CGFloat(self.data.count) * cellHeight )  + self.getHeightOf(percent: 2){
			tVHeight = (CGFloat(self.data.count) * cellHeight ) + self.getHeightOf(percent: 2)
		}
		
		var constraints: [NSLayoutConstraint] = []
		if self.type == .scorecard {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[title(==\(self.getHeightOf(percent: 20)))]-0-[table(==\(tVHeight))]-0-[comparedTo(==\(self.getHeightOf(percent: 10)))]", options: [], metrics: nil, views: ["title" : self.titleView, "table": self.tableView, "comparedTo": self.comparedToView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[comparedTo]-0-|", options: [], metrics: nil, views: ["comparedTo": self.comparedToView])
		} else {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[title(==\(self.getHeightOf(percent: 20)))]-0-[table(==\(tVHeight))]", options: [], metrics: nil, views: ["title" : self.titleView, "table": self.tableView])
		}
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[table]-0-|", options: [], metrics: nil, views: ["table": self.tableView])
		NSLayoutConstraint.activate(constraints)
	}
	
	/**
		Sets the data for scorecard KPI.
	*/
	private func setKpiData() {
		self.tableView.reloadData()
	}
	
	/**
	*/
	private func updateChanges() {
		
		if self.type != .scorecard && self.type != .rankings {
			self.renderKPIData()
		}
	}
	
}

extension ZCRMKPI : UITableViewDataSource, UITableViewDelegate {

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.data.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: ZCRMKPICell!
		if self.type == .rankings {
			cell = ZCRMKPICell(data:  self.data[indexPath.row], type: self.type, highRate: self.data[0].difference.toCGFloat(), options : self.renderOptions)
		} else {
			cell = ZCRMKPICell(data: self.data[indexPath.row], type: self.type, options: self.renderOptions)
		}
		cell.selectionStyle = .none
		cell.backgroundColor = self.backgroundColor
		return cell
	}
}
