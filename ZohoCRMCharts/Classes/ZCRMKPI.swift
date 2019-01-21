//
//  ZCRMKPI.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 08/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

public final class ZCRMKPI: UIView, KPIUtil {
	
	/**
		The title's font object. This property is nil by default.
	*/
	public var titleFont: UIFont! {
		didSet {
			if titleFont != nil {
				self.renderOptions.titleFont = titleFont
				self.updateTitleText()
			}
		}
	}
	
	/**
		The title's font color. This property is nil by default.
	*/
	public var titleFontColor: UIColor! {
		didSet {
			if titleFontColor != nil {
				self.renderOptions.titleFontColor = titleFontColor
				self.updateTitleText()
			}
		}
	}
	
	/**
		The value's font object. This property is nil by default.
	*/
	public var valueFont: UIFont! {
		didSet {
			if valueFont != nil {
				if self.isScorecard || self.isRankings {
					self.renderOptions.valueFont = valueFont
				} else {
					self.renderOptions.simpleKpiValueFont = valueFont
				}
				self.updateChanges()
			}
		}
	}
	
	/**
		The value's font object. This property is nil by default.
	*/
	public var valueFontColor: UIColor! {
		didSet {
			if valueFontColor != nil {
				self.renderOptions.valueFontColor = valueFontColor
				self.updateChanges()
			}
		}
	}
	
	/**
		The label's font object for KPI of tye scorecard and rankings. This property is nil by default.
	*/
	public var labelFont: UIFont! {
		didSet {
			if labelFont != nil {
				self.renderOptions.labelFont = labelFont
				self.updateChanges()
			}
		}
	}
	
	/**
		The label's font color for KPI of tye scorecard and rankings. This property is nil by default.
	*/
	public var labelFontColor: UIColor! {
		didSet {
			if labelFontColor != nil {
				self.renderOptions.labelFontColor = labelFontColor
				self.updateChanges()
			}
		}
	}
	
	/**
		The rate's font object. This property is nil by default.
	*/
	public var rateFont: UIFont! {
		didSet {
			if rateFont != nil {
				if self.isScorecard || self.isRankings {
					self.renderOptions.rateFont = rateFont
				} else {
					self.renderOptions.simpleKpiValueFont = rateFont
				}
				self.updateChanges()
			}
		}
	}
	
	/**
		The rate's font color. This property is nil by default.
	*/
	public var rateFontColor: UIColor! {
		didSet {
			if rateFontColor != nil {
				self.renderOptions.rateFontColor = rateFontColor
				self.updateChanges()
			}
		}
	}
	
	/**
		The compared to text font object. This property is nil by default.
	*/
	public var comparedToFont: UIFont! {
		didSet {
			if comparedToFont != nil && (self.isStandard || self.isGrowthIndex) {
				self.renderOptions.comparedToFont = comparedToFont
				self.updateComparedToViewText(text: nil)
			}
		}
	}
	
	/**
		The compared to text font color. This property is nil by default.
	*/
	public var comparedToFontColor: UIColor! {
		didSet {
			if comparedToFontColor != nil && (self.isStandard || self.isGrowthIndex) {
				self.renderOptions.comparedToFontColor = comparedToFontColor
				self.updateComparedToViewText(text: nil)
			}
		}
	}
	
	/**
		Color to indicate incremental status. This property is nil by default.
	*/
	public var positiveColor: UIColor! {
		didSet {
			if positiveColor != nil {
				self.renderOptions.positiveColor = positiveColor
				self.updateChanges()
			}
		}
	}
	
	/**
		Color to indicate decremental status. This property is nil by default.
	*/
	public var negativeColor: UIColor! {
		didSet {
			if negativeColor != nil {
				self.renderOptions.negativeColor = negativeColor
				self.updateChanges()
			}
		}
	}
	
	/**
		Color to indicate neutral status. This property is nil by default.
	*/
	public var neutralColor: UIColor! {
		didSet {
			if neutralColor != nil {
				self.renderOptions.neutralColor = neutralColor
				self.updateChanges()
			}
		}
	}
	
	/**
		The rate bar's color for KPI of type rankings. This property is nil by default.
	*/
	public var rateBarColor: UIColor! {
		didSet {
			if rateBarColor != nil {
				self.renderOptions.rateBarColor = rateBarColor
				self.updateChanges()
			}
		}
	}
	
	/**
		The footnote text for the KPI of type scorecard. This property is nil by default. Changes to this property will add a foot note to the KPI.
	*/
	public var footNote: String!  {
		didSet {
			if footNote != nil && self.isScorecard {
				self.updateFootNoteText(footNote)
			}
		}
	}
	
	/**
		The footnote's font object. This property is nil by default.
	*/
	public var footNoteFont: UIFont! {
		didSet {
			if footNoteFont != nil && self.isScorecard {
				self.renderOptions.footNoteFont = footNoteFont
				self.updateFootNoteText()
			}
		}
	}
	
	/**
		The footnite's font color. This property is nil by default.
	*/
	public var footNoteColor: UIColor! {
		didSet {
			if footNoteColor != nil && self.isScorecard {
				self.renderOptions.footNoteColor = footNoteColor
				self.updateFootNoteText()
			}
		}
	}
	
	public var hideTitle: Bool! {
		didSet {
			if hideTitle != nil {
				self.titleView.isHidden = hideTitle
			}
		}
	}
	
	public override var backgroundColor: UIColor? {
		didSet {
			super.backgroundColor = backgroundColor
			self.tableView.backgroundColor = backgroundColor
		}
	}
	
	internal var type: ZCRMCharts.ZCRMKPIType
	fileprivate let title: String
	fileprivate var data: [ZCRMKPIRow] = []
	fileprivate var renderOptions: KPIRenderOptions = KPIRenderOptions()
	
	fileprivate let titleView: UILabel =  UILabel() //title view for all components
	fileprivate let footNoteView = UILabel() // for kpi of type scorecard
	fileprivate let valueView = UILabel() // for simple kpi (standard, growth index and basic)
	fileprivate let tableView = UITableView() // for scorecard and rankings
	fileprivate let comparedToView = UILabel() // for standard and growth index
	fileprivate let cellHeight: CGFloat = 42 // default cell height for a kpi row in rankings and scorecard

	public init(frame: CGRect, type: ZCRMCharts.ZCRMKPIType, title: String) {
		self.type = type
		self.title = title
		super.init(frame: frame)
		self.render()
	}
	
	public init(type: ZCRMCharts.ZCRMKPIType, title: String) {
		self.type = type
		self.title = title
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.render()
	}
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func setData(_ data: ZCRMKPIRow) throws {
		
		if self.isScorecard || self.isRankings {
			throw ZCRMChartsError(message: "Invalid method invocation. Use setData(data: [ZCRMKPIRow]) instead for type \(self.type)")
		}
		self.data = [data]
		if self.isValidData() {
			self.addConstraints()
			self.renderKPIData()
		} else {
			throw ZCRMChartsError(message: "Invalid data found for kpi of type \(self.type) at \(self)")
		}
	}
	
	public func setData(_ data: [ZCRMKPIRow]) throws {
		
		if !self.isScorecard && !self.isRankings {
			throw ZCRMChartsError(message: "Invalid method invocation. Use setData(data: ZCRMKPIRow) instead for type \(self.type)")
		}
		self.data = data
		if self.isValidData() {
			self.addConstraints()
			self.renderKPIData()
		} else {
			throw ZCRMChartsError(message: "Invalid data found for kpi of type \(self.type) at \(self)")
		}
	}
	
	public override func layoutSubviews() {
		
		if self.isScorecard || self.isRankings {
			self.tableView.reloadData() // to re-render invisble cells
		}
	}

}

/**
	It contains the private methods.
*/
fileprivate extension ZCRMKPI {
	
	/**
		Renders the view, related to its type.
	*/
	fileprivate func render() {
		
		self.backgroundColor = UIColor(red: 182/255.0, green: 182/255.0, blue: 182/255.0, alpha: 1)
		self.renderKPIView()
	}
	
	/**
	Updates the changes made for any of child UI elements.
	*/
	fileprivate func updateChanges() {
		
		if !self.isScorecard && !self.isRankings && self.data.count > 0{
			self.renderKPIData()
		}
	}
	
	/**
	Updates the title view with the given options.
	*/
	fileprivate func updateTitleText() {
		
		self.titleView.attributedText = NSAttributedString(string: self.title, attributes: [NSFontAttributeName : self.renderOptions.titleFont, NSForegroundColorAttributeName: self.renderOptions.titleFontColor ])
	}
	
	/**
	Sets the compared to text for standard, growth index and scorecard KPI.
	*/
	fileprivate func updateComparedToViewText(text: String?) {
		
		var textToFit = String()
		if text.notNil {
			textToFit = text!
		} else if let attrStr = self.comparedToView.attributedText {
			textToFit = attrStr.string
		}
		self.comparedToView.attributedText = NSAttributedString(string: textToFit, attributes: [ NSFontAttributeName: self.renderOptions.comparedToFont, NSForegroundColorAttributeName: self.renderOptions.comparedToFontColor])
	}
	
	fileprivate func updateFootNoteText(_ text: String? = nil) {
		
		var textToFit = String()
		if text.notNil {
			textToFit = text!
		} else if let attrTxt = self.footNoteView.attributedText {
			textToFit = attrTxt.string
		}
		self.footNoteView.attributedText = NSAttributedString(string: textToFit, attributes: [ NSFontAttributeName: self.renderOptions.footNoteFont, NSForegroundColorAttributeName: self.renderOptions.footNoteColor ])
	}
	
	fileprivate func getCalculatedHeight() -> CGFloat {
		
		var height: CGFloat = 0
		if !self.isRankings && !self.isScorecard {
			height += 85
		} else {
			height += self.data.count.toCGFloat() * self.cellHeight + 55
			if self.isScorecard {
				height += 25
			}
		}
		return height
	}
	
	/**
		Renders the KPI corresponding to its type.
	*/
	private func renderKPIView() {
		
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
	fileprivate func renderKPIData() {
		
		if self.isRankings || self.isScorecard {
			self.setKpiData()
		} else {
			self.setSimpleKpiData()
		}
	}
	
	fileprivate func addConstraints() {
		
		if self.isRankings || self.isScorecard {
			self.addKpiConstraints()
		} else {
			self.addSimpleKpiConstraints()
		}
	}
	
	/**
		Sets the view position of the title label. It will be common for all types.
	*/
	private func setUpTitleView() {
		
		self.titleView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.titleView)
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]", options: [], metrics: nil, views: ["title": self.titleView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[title]", options: [], metrics: nil, views: ["title": self.titleView])
		NSLayoutConstraint.activate(constraints)
		
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
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title(<=25)]-[value(>=title)]", options: [], metrics: nil, views: ["title": self.titleView, "value": self.valueView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[value]", options: [], metrics: nil, views: ["value": self.valueView])
		if !self.isBasic {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[comparedTo]-15-|", options: [.alignAllBottom], metrics: nil, views: ["value": self.valueView, "comparedTo": self.comparedToView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[comparedTo]-|", options: [], metrics: nil, views: ["comparedTo": self.comparedToView])
		}
		NSLayoutConstraint.activate(constraints)
	}
	
	/**
		Sets the data for standard, growth index and basic KPI.
	*/
	private func setSimpleKpiData() {
		
		let data: ZCRMKPIRow =  self.data[0]
		if !self.isBasic {
			self.updateComparedToViewText(text: data.comparedToLabel + ": " + data.comparedToValue)
		}
		if self.isStandard {
			self.valueView.attributedText = ZCRMKPIUIUtil.getValueTextForStandardKPI(data: data, options: self.renderOptions )
		} else if self.isGrowthIndex {
			self.valueView.attributedText = ZCRMKPIUIUtil.getValueTextForGrowthIndexKPI(data: data, options: self.renderOptions)
		} else if self.isBasic {
			self.valueView.attributedText = ZCRMKPIUIUtil.getValueTextForBasicKPI(data: data, options: self.renderOptions )
		}
	}

	/**
		Sets the view for scorecard KPI.comparedToFont
	*/
	private func setKpiView() {
		
		self.tableView.dataSource = self
		self.tableView.separatorStyle = .none
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.tableView)
		if self.isScorecard {
			self.footNoteView.translatesAutoresizingMaskIntoConstraints = false
			self.footNoteView.textAlignment = .left
			self.addSubview(self.footNoteView)
		}
	}
	
	/**
		Adds the constraints for the scorecard KPI.
	*/
	private func addKpiConstraints() {
		
		self.tableView.rowHeight = self.cellHeight
		var constraints: [NSLayoutConstraint] = []
		if self.isScorecard {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title(<=25)]-[table]-[footNote(<=25)]-10-|", options: [], metrics: nil, views: ["title" : self.titleView, "table": self.tableView, "footNote": self.footNoteView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[footNote]-0-|", options: [], metrics: nil, views: ["footNote": self.footNoteView])
		} else {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title(<=25)]-[table]-|", options: [], metrics: nil, views: ["title" : self.titleView, "table": self.tableView])
		}
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[table]-0-|", options: [], metrics: nil, views: ["table": self.tableView])
		NSLayoutConstraint.activate(constraints)
	}
	
	/**
		Sets the data for scorecard and rankings KPI.
	*/
	private func setKpiData() {
		self.tableView.reloadData()
	}
	
}

/**
	Methods validating the input data based on its type.
*/
fileprivate extension ZCRMKPI {
	
	fileprivate func isValidData() -> Bool {
	
		if self.isScorecard || self.isRankings {
			return self.checkDataForKpi()
		}
		return self.checkDataForSimpleKpi()
	}
	
	private func checkDataForSimpleKpi() -> Bool {
		
		var isValidData = true
		let data = self.data[0]
		if self.isStandard || self.isGrowthIndex {
			if data.rate == nil || data.comparedToLabel == nil || data.comparedToValue == nil || data.outcome == nil {
				isValidData = false
			}
		}
		return isValidData
	}
	
	private func checkDataForKpi() -> Bool {
		
		var isValidData = true
		for kpiRow in self.data {
			if kpiRow.displayLabel == nil || (self.isRankings && kpiRow.value == nil) {
				isValidData = false
				break
			}
			if self.isScorecard && (kpiRow.outcome == nil || kpiRow.rate == nil) {
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
			let highRate = self.data.map { (kpiRow) -> Int in
				return kpiRow.value
			}.max()!.toCGFloat()
			cell = ZCRMKPICell(data:  self.data[indexPath.row], type: self.type, highRate: highRate, options : self.renderOptions)
		} else {
			cell = ZCRMKPICell(data: self.data[indexPath.row], type: self.type, options: self.renderOptions)
		}
		cell.selectionStyle = .none
		cell.backgroundColor = self.backgroundColor
		return cell
	}
}
