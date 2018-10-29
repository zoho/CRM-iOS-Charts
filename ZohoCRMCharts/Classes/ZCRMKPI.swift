//
//  ZCRMKPI.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 08/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

public class ZCRMKPI: UIView, KPIUtil {

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
	
	public var labelFont: UIFont! {
		didSet {
			if labelFont != nil {
				self.renderOptions.labelFont = labelFont
				self.updateChanges()
			}
		}
	}
	
	public var labelFontColor: UIColor! {
		didSet {
			if labelFontColor != nil {
				self.renderOptions.labelFontColor = labelFontColor
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
	
	public var comparedToFont: UIFont! {
		didSet {
			if comparedToFont != nil && (self.isStandard || self.isGrowthIndex) {
				self.renderOptions.comparedToFont = comparedToFont
				self.updateComparedToViewText(text: nil)
			}
		}
	}
	
	public var comparedToFontColor: UIColor! {
		didSet {
			if comparedToFontColor != nil && (self.isStandard || self.isGrowthIndex) {
				self.renderOptions.comparedToFontColor = comparedToFontColor
				self.updateComparedToViewText(text: nil)
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
	
	public var footNote: String!  {
		didSet {
			if footNote != nil && self.isScorecard {
				self.updateFootNoteText(text: footNote)
			}
		}
	}
	
	public var footNoteFont: UIFont! {
		didSet {
			if footNoteFont != nil && self.isScorecard {
				self.renderOptions.footNoteFont = footNoteFont
				self.updateFootNoteText(text: nil)
			}
		}
	}
	
	public var footNoteColor: UIColor! {
		didSet {
			if footNoteColor != nil && self.isScorecard {
				self.renderOptions.footNoteColor = footNoteColor
				self.updateFootNoteText(text: nil)
			}
		}
	}
	
	public override var intrinsicContentSize: CGSize {
		return CGSize(width: getScreenWidthOf(percent: 92), height: self.getCalculatedHeight())
	}
	
	internal var type: ZCRMKPIComponent!
	internal var data: [ZCRMKPIRow] = []
	internal var title: String!
	internal var renderOptions = KPIRenderOptions()
	
	internal var titleView: UILabel =  UILabel() //title view for all components
	internal let footNoteView = UILabel() // for kpi of type scorecard
	internal let valueView = UILabel() // for simple kpi (standard, growth index and basic)
	internal var tableView = UITableView() // for scorecard and rankings
	internal var comparedToView = UILabel() // for standard and growth index
	internal var cellHeight: CGFloat = 42

	public init(frame: CGRect, type: ZCRMKPIComponent, title: String) {
		super.init(frame: frame)
		self.type = type
		self.title = title
		self.render()
	}
	
	public init(type: ZCRMKPIComponent, title: String) {
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.type = type
		self.title = title
		self.render()
		self.tableView.backgroundColor = .red
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func setData(data: ZCRMKPIRow) throws {
		self.data = [data]
		if self.isValidData() {
			self.addConstraints()
			self.renderKPIData()
		} else {
			throw ZCRMChartsError(message: "Invalid data found for kpi of type \(self.type) at \(self)")
		}
	}
	
	public func setData(data: [ZCRMKPIRow]) throws {
		self.data = data
		if self.isValidData() {
			self.addConstraints()
			self.renderKPIData()
		} else {
			throw ZCRMChartsError(message: "Invalid data found for kpi of type \(self.type) at \(self)")
		}
	}
}

/**
	It contains the private methods.
*/
internal extension ZCRMKPI {
	
	/**
		Renders the view, related to its type.
	*/
	 func render() {
		
		self.clipsToBounds = true
		self.layoutIfNeeded()
		self.backgroundColor = UIColor(red: 182/255.0, green: 186/255.0, blue: 193/255.0, alpha: 1)
		self.renderKPIView()
	}
	
	/**
		Renders the KPI corresponding to its type.
	*/
	func renderKPIView() {
		
		self.setUpTitleView()
		self.updateTitleText()
		if self.isRankings || self.isScorecard {
			self.tableView.dataSource = self
			self.tableView.delegate = self
			self.setKpiView()
		} else {
			self.setSimpleKpiView()
		}
	}
	
	/**
		Sets the KPI data to the views.
	*/
	func renderKPIData() {
		
		if self.isRankings || self.isScorecard {
			self.setKpiData()
		} else {
			self.setSimpleKpiData()
		}
	}
	
	func addConstraints() {
		
		self.invalidateIntrinsicContentSize()
		if self.isRankings || self.isScorecard {
			self.addKpiConstraints()
		} else {
			self.addSimpleKpiConstraints()
		}
	}
	
	/**
		Sets the view position of the title label. It will be common for all types.
	*/
	func setUpTitleView() {
		
		self.titleView.translatesAutoresizingMaskIntoConstraints = false
		self.titleView.adjustsFontSizeToFitWidth = true
		self.addSubview(self.titleView)
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]", options: [], metrics: nil, views: ["title": self.titleView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[title]", options: [], metrics: nil, views: ["title": self.titleView])
		NSLayoutConstraint.activate(constraints)
		
	}
	
	/**
		Updates the title view with the given options.
	*/
	func updateTitleText() {
		
		self.titleView.attributedText = NSAttributedString(string: self.title, attributes: [NSFontAttributeName : self.renderOptions.titleFont, NSForegroundColorAttributeName: self.renderOptions.titleFontColor ])
	}
	
	
	/**
		Sets the view for standard, growth index and basic KPI.
	*/
	func setSimpleKpiView(){
		
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
	func addSimpleKpiConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[value]", options: [], metrics: nil, views: ["title": self.titleView, "value": valueView])
		if !self.isBasic {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[value(==comparedTo)]-[comparedTo]-15-|", options: [.alignAllBottom], metrics: nil, views: ["value": valueView, "comparedTo": self.comparedToView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[comparedTo]-|", options: [], metrics: nil, views: ["comparedTo": self.comparedToView])
		} else {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[value]", options: [], metrics: nil, views: ["value": valueView])
		}
		NSLayoutConstraint.activate(constraints)
	}
	
	/**
		Sets the data for standard, growth index and basic KPI.
	*/
	func setSimpleKpiData() {
		
		let data: ZCRMKPIRow =  self.data[0]
		
		if !self.isBasic {
			self.updateComparedToViewText(text: data.comparedToLabel + ": " + data.comparedToValue)
		}
		if self.isStandard {
			self.valueView.attributedText = ZCRMKPIUIUtil.shared.getValueTextForStandardKPI(data: data, options: self.renderOptions )
		} else if self.isGrowthIndex {
			self.valueView.attributedText = ZCRMKPIUIUtil.shared.getValueTextForGrowthIndexKPI(data: data, options: self.renderOptions)
		} else if self.isBasic {
			self.valueView.attributedText = ZCRMKPIUIUtil.shared.getValueTextForBasicKPI(data: data, options: self.renderOptions )
		}
	}
	
	
	/**
		Sets the compared to text for standard, growth index and scorecard KPI.
	*/
	func updateComparedToViewText(text: String?) {
		
		var textToFit = ""
		if text.notNil {
			textToFit = text!
		} else if let attrStr = self.comparedToView.attributedText {
			textToFit = attrStr.string
		}
		self.comparedToView.attributedText = NSAttributedString(string: textToFit, attributes: [ NSFontAttributeName: self.renderOptions.comparedToFont, NSForegroundColorAttributeName: self.renderOptions.comparedToFontColor])
	}
	
	/**
	Sets the view for scorecard KPI.comparedToFont
	*/
	func setKpiView() {
		
		self.tableView.dataSource = self
		self.tableView.isScrollEnabled = false
		self.tableView.allowsSelection = false
		self.tableView.separatorStyle = .none
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.backgroundColor = self.backgroundColor
		self.addSubview(self.tableView)
		
		if self.isScorecard {
			self.footNoteView.translatesAutoresizingMaskIntoConstraints = false
			self.footNoteView.backgroundColor = self.backgroundColor
			self.footNoteView.textAlignment = .left
			self.addSubview(self.footNoteView)
		}
	}
	
	/**
		Adds the constraints for the scorecard KPI.
	*/
	func addKpiConstraints() {
		
		self.tableView.layoutIfNeeded()
		self.tableView.rowHeight = self.cellHeight
		let tVHeight: CGFloat = CGFloat(self.data.count) * self.cellHeight
		var constraints: [NSLayoutConstraint] = []
		if self.isScorecard {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[table(==\(tVHeight))]", options: [], metrics: nil, views: ["title" : self.titleView, "table": self.tableView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[footNote]-0-|", options: [], metrics: nil, views: ["footNote": self.footNoteView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[footNote]-10-|", options: [], metrics: nil, views: [ "footNote": self.footNoteView])
		} else {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[table(==\(tVHeight))]", options: [], metrics: nil, views: ["title" : self.titleView, "table": self.tableView])
		}
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[table]-0-|", options: [], metrics: nil, views: ["table": self.tableView])
		NSLayoutConstraint.activate(constraints)
	}
	
	/**
		Sets the data for scorecard KPI.
	*/
	func setKpiData() {
		
		self.tableView.reloadData()
	}
	
	/**
		Updates the changes made for any of child UI elements.
	*/
	func updateChanges() {
		
		if !self.isScorecard && !self.isRankings {
			self.renderKPIData()
		}
	}
	
	func getCalculatedHeight() -> CGFloat {
		
		var height: CGFloat = 0
		if !self.isRankings && !self.isScorecard {
			height += 76
		} else {
			height += CGFloat(self.data.count) * self.cellHeight + 55
			if self.isScorecard {
				height += 25
			}
		}
		return height
	}
	
	func updateFootNoteText(text: String?) {
		
		var textToFit = ""
		if text.notNil {
			textToFit = text!
		} else if let attrTxt = self.footNoteView.attributedText {
			textToFit = attrTxt.string
		}
		self.footNoteView.attributedText = NSAttributedString(string: textToFit, attributes: [ NSFontAttributeName: self.renderOptions.footNoteFont, NSForegroundColorAttributeName: self.renderOptions.footNoteColor ])
	}
	
}

/**
	Methods validating the input data based on its type.
*/
internal extension ZCRMKPI {
	
	func isValidData() -> Bool {
	
		if self.isScorecard || self.isRankings {
			return self.checkDataForKpi()
		}
		return self.checkDataForSimpleKpi()
	}
	
	func checkDataForSimpleKpi() -> Bool {
		
		var isValidData = true
		let data = self.data[0]
		if self.isStandard || self.isGrowthIndex {
			if data.rate == nil || data.comparedToLabel == nil || data.comparedToValue == nil || data.objective == nil {
				isValidData = false
			}
		}
		return isValidData
	}
	
	func checkDataForKpi() -> Bool {
		
		var isValidData = true
		for kpiRow in self.data {
			if kpiRow.label == nil {
				isValidData = false
				break
			}
			if self.isScorecard && (kpiRow.objective == nil || kpiRow.rate == nil) {
				isValidData = false
				break
			}
		}
		return isValidData
	}
}

/**
	UITableView protocols for KPI of type scorecard and rankings.
*/
 extension ZCRMKPI : UITableViewDataSource, UITableViewDelegate {
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.data.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: ZCRMKPICell!
		if self.isRankings {
			cell = ZCRMKPICell(data:  self.data[indexPath.row], type: self.type, highRate: self.data[0].value.toCGFloat(), options : self.renderOptions)
		} else {
			cell = ZCRMKPICell(data: self.data[indexPath.row], type: self.type, options: self.renderOptions)
		}
		cell.selectionStyle = .none
		cell.backgroundColor = self.backgroundColor
		return cell
	}
}
