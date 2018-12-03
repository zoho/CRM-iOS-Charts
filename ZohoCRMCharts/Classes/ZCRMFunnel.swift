//
//  ZCRMFunnel.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 26/11/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

public final class ZCRMFunnel: UIView {
	
	public var dataSource: ZCRMFunnelDataSource! {
		didSet {
			if dataSource != nil {
				self.loadData()
				if self.type != .segment {
					self.setData()
				}
			}
		}
	}
	
	public var segmentsLabel: String! {
		didSet {
			if segmentsLabel != nil && self.type == .segment {
				self.setSegementLabel()
			}
		}
	}
	
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
	
	public var stageFont: UIFont! {
		didSet {
			if stageFont != nil {
				self.renderOptions.stageFont = stageFont
				self.updateChanges()
			}
		}
	}
	
	public var stageFontColor: UIColor! {
		didSet {
			if stageFontColor != nil {
				self.renderOptions.stageFontColor = stageFontColor
				self.updateChanges()
			}
		}
	}
	
	public var segmentFont: UIFont! {
		didSet {
			if segmentFont != nil {
				self.renderOptions.segmentFont = segmentFont
				self.updateChanges()
			}
		}
	}
	
	public var segmentFontColor: UIColor! {
		didSet {
			if segmentFontColor != nil {
				self.renderOptions.segmentFontColor = segmentFontColor
				self.updateChanges()
			}
		}
	}
	
	public var conversionRateFont: UIFont! {
		didSet {
			if conversionRateFont != nil {
				self.renderOptions.conversionRateFont = conversionRateFont
				self.updateChanges()
			}
		}
	}
	
	public var conversionRateFontColor: UIColor! {
		didSet {
			if conversionRateFontColor != nil {
				self.renderOptions.conversionRateFontColor = conversionRateFontColor
				self.updateChanges()
			}
		}
	}
	
	public var barColor: UIColor! {
		didSet {
			if barColor != nil && self.type  == .standard {
				self.renderOptions.barColor = barColor
				self.updateChanges()
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
	
	fileprivate let title: String
	fileprivate let type: ZCRMCharts.ZCRMFunnelType
	fileprivate var renderOptions: FunnelRenderOptions = FunnelRenderOptions()
	fileprivate let stages: [ZCRMFunnelStage]
	fileprivate var segments: [ZCRMFunnelSegment] = []
	
	fileprivate var data: [ZCRMFunnelData] = []
	fileprivate var rates: [ZCRMFunnelData] = []
	fileprivate var conversionRate: ZCRMFunnelData!
	// used only for segement and in standard if classication configured
	fileprivate var conversionRates: [ZCRMFunnelData] = []
	fileprivate var stagesData: [ZCRMFunnelData] = []
	fileprivate var stagesRate: [ZCRMFunnelData] = []

	fileprivate let scrollView: UIScrollView = UIScrollView()
	fileprivate let titleView: UILabel = UILabel()
	fileprivate let conversionRateView: UILabel = UILabel()
	fileprivate let stackView1: UIStackView = UIStackView()
	fileprivate let stackView2: UIStackView = UIStackView()
	fileprivate let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
	fileprivate var collectionView: UICollectionView!
	
	public init(title: String, type: ZCRMCharts.ZCRMFunnelType, stages: [ZCRMFunnelStage]) {
		self.title = title
		self.type = type
		self.stages = stages
		super.init(frame: .zero)
		self.render()
	}
	
	public init(frame: CGRect, title: String, type: ZCRMCharts.ZCRMFunnelType, stages: [ZCRMFunnelStage]) {
		self.title = title
		self.type = type
		self.stages = stages
		super.init(frame: frame)
		self.render()
	}
	
	public init(title: String, type: ZCRMCharts.ZCRMFunnelType, stages: [ZCRMFunnelStage], segments: [ZCRMFunnelSegment]) {
		self.title = title
		self.type = type
		self.stages = stages
		self.segments = segments
		super.init(frame: .zero)
		self.render()
	}
	
	public init(frame: CGRect, title: String, type: ZCRMCharts.ZCRMFunnelType, stages: [ZCRMFunnelStage], segments: [ZCRMFunnelSegment]) {
		self.title = title
		self.type = type
		self.stages = stages
		self.segments = segments
		super.init(frame: frame)
		self.render()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		self.addConstraints()
	}
}

fileprivate extension ZCRMFunnel{
	
	fileprivate var pathStackViewHeight: CGFloat {
		get {
			return self.frame.height * 0.25
		}
	}
	
	fileprivate var pathStackViewWidth: CGFloat {
		get {
			return 150 * self.stages.count.toCGFloat()
		}
	}
	
	fileprivate var compactStackViewWidth: CGFloat {
		get {
			return (200 * self.stages.count.toCGFloat()) - 80
		}
	}
	
	fileprivate var compactStackViewHeight: CGFloat {
		get {
			return self.frame.height * 0.40
		}
	}
	
	fileprivate var classicStackViewHeight: CGFloat {
		get {
			return (70 * self.stages.count.toCGFloat()) - 30
		}
	}
	
	fileprivate var classicStackViewWidth: CGFloat {
		get {
			return self.frame.width * 0.90
		}
	}
	
	fileprivate var classicCollectionViewHeight: CGFloat {
		get {
			
			let footerHeight: CGFloat = 25
			if self.stages.count > 3 {
				return footerHeight * 2
			}
			return footerHeight
		}
	}
	
	fileprivate var segmentHeaderColumnWidth: CGFloat {
		get {
			return 150
		}
	}
	
	fileprivate var segmentCellWidth: CGFloat {
		get {
			return 100
		}
	}
	
	fileprivate var segmentCellHeight: CGFloat {
		get {
			let heightForCells = self.segmentCollectionViewHeight
			return heightForCells / ( self.segments.count.toCGFloat() + 2)
		}
	}
	
	
	fileprivate var segmentCollectionViewHeight: CGFloat {
		get {
			return self.frame.height * 0.85
		}
	}
	
	fileprivate var conversionRateViewHeight: CGFloat {
		get {
			return 30
		}
	}
}

fileprivate extension ZCRMFunnel{
	
	func render() {
		
		self.clipsToBounds = true
		self.renderTitleView()
		self.renderView()
	}
	
	func addConstraints() {
		
		if self.type == .path {
			self.addPathFunnelConstraints()
		} else if self.type == .compact {
			self.addCompactFunnelConstraints()
		} else if self.type == .classic {
			self.addClassicFunnelConstraints()
		} else if self.type == .segment {
			self.addSegmentFunnelConstraints()
		}
	}
	
	func updateChanges() {
		
		if self.type == .path {
			self.updatePathFunnelUIOptions()
		} else if self.type == .compact {
			self.updateCompactFunnelUIOptions()
		} else if self.type == .classic {
			self.updateClassicFunnelUIOptions()
		} else if self.type == .segment {
			self.updateSegmentUIOptions()
		}
	}
	
	private func renderView() {
		
		if self.type == .path {
			self.renderPathFunnel()
		} else if self.type == .compact {
			self.renderCompactFunnel()
		} else if self.type == .classic {
			self.renderClassicFunnel()
		} else if self.type == .segment {
			self.renderSegmentFunnel()
		}
	}
	
	private func renderTitleView() {
		self.setTitleView()
		self.updateTitleText()
	}
	
	func updateTitleText() {
		
		self.titleView.font = self.renderOptions.titleFont
		self.titleView.textColor = self.renderOptions.titleFontColor
	}
	
	private func setTitleView() {
		
		self.titleView.translatesAutoresizingMaskIntoConstraints = false
		self.titleView.text = self.title
		self.addSubview(self.titleView)
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]", options: [], metrics: nil, views: ["title": self.titleView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[title(>=25)]", options: [], metrics: nil, views: ["title": self.titleView])
		NSLayoutConstraint.activate(constraints)
	}
	
	
	private func renderPathFunnel() {
		
		self.scrollView.translatesAutoresizingMaskIntoConstraints = false
		self.scrollView.showsHorizontalScrollIndicator = false
		self.addSubview(self.scrollView)
		
		self.stackView1.translatesAutoresizingMaskIntoConstraints = false
		self.stackView1.axis = .horizontal
		self.stackView1.spacing = -5
		self.stackView1.distribution = .fillEqually
		self.scrollView.addSubview(self.stackView1)
		
		self.stackView2.translatesAutoresizingMaskIntoConstraints = false
		self.stackView2.axis = .horizontal
		self.stackView2.spacing = 5
		self.stackView2.distribution = .fillEqually
		self.scrollView.addSubview(self.stackView2)
		
		for (index, stage) in self.stages.enumerated() {
			if index == 0 {
				let cell = ZCRMPathFunnelCell(isStart: true, bgColor: stage.color)
				cell.options = self.renderOptions
				cell.setUIOptions()
				self.stackView1.addArrangedSubview(cell)
				continue
			}
			let label = UILabel()
			label.textAlignment = .center
			label.font = self.renderOptions.rateFont
			label.textColor = self.renderOptions.rateFontColor
			stackView2.addArrangedSubview(label)
			self.stackView1.addArrangedSubview(ZCRMPathFunnelCell(isStart: false, bgColor: stage.color))
		}
	}
	
	private func updatePathFunnelUIOptions() {
		
		for view in self.stackView1.arrangedSubviews {
			(view as! ZCRMPathFunnelCell).options = self.renderOptions
			(view as! ZCRMPathFunnelCell).setUIOptions()
		}
		
		for label in self.stackView2.arrangedSubviews {
			(label as! UILabel).font = self.renderOptions.rateFont
			(label as! UILabel).textColor = self.renderOptions.rateFontColor
		}
	}
	
	private func addPathFunnelConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		self.scrollView.contentSize.width = self.pathStackViewWidth
		self.scrollView.contentSize.height = self.pathStackViewHeight * 2
		let pathLabelStackViewWitdh = ( self.pathStackViewWidth / self.stages.count.toCGFloat()) * (self.stages.count.toCGFloat() - 1)
		
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-10-[scrollView(scrollViewHeight)]-|", options: [], metrics: ["scrollViewHeight" : self.pathStackViewHeight * 2], views: ["title": self.titleView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[scrollView]-0-|", options: [], metrics: nil, views: ["scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pathStackView(pathStackViewWidth)]-0-|", options: [], metrics: ["pathStackViewWidth": self.pathStackViewWidth], views: ["pathStackView": self.stackView1])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pathStackView(pathStackViewHeight)]-0-[pathLabelStackView(pathStackViewHeight)]-0-|", options: [], metrics: ["pathStackViewHeight": self.pathStackViewHeight], views: ["pathStackView": self.stackView1, "pathLabelStackView": self.stackView2])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[pathLabelStackView(pathLabelStackViewWitdh)]-0-|", options: [], metrics: ["pathLabelStackViewWitdh": pathLabelStackViewWitdh], views: ["pathLabelStackView": self.stackView2])
		NSLayoutConstraint.activate(constraints)
	}
	
	
	private func renderCompactFunnel() {
		
		self.scrollView.translatesAutoresizingMaskIntoConstraints = false
		self.scrollView.showsHorizontalScrollIndicator = false
		self.addSubview(self.scrollView)
		
		self.stackView1.translatesAutoresizingMaskIntoConstraints = false
		self.stackView1.axis = .horizontal
		self.stackView1.spacing = 0
		self.scrollView.addSubview(self.stackView1)
		
		var constraints: [NSLayoutConstraint] = []
		for (index, stage) in self.stages.enumerated() {
			
			let valueCell = ZCRMCompactFunnelCell(isRateView: false)
			valueCell.translatesAutoresizingMaskIntoConstraints = false
			self.stackView1.addArrangedSubview(valueCell)
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[valueCell\(index)(valueCellWidth)]", options: [], metrics: ["valueCellWidth": 120], views: ["valueCell\(index)": valueCell])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[valueCell\(index)]-0-|", options: [], metrics: nil, views: ["valueCell\(index)": valueCell])
			
			if index < self.stages.count - 1 {
				
				let rateCell = ZCRMCompactFunnelCell(isRateView: true)
				rateCell.translatesAutoresizingMaskIntoConstraints = false
				rateCell.backgroundColor = stage.color
				self.stackView1.addArrangedSubview(rateCell)
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[rateCell\(index)(rateCellWidth)]", options: [], metrics: ["rateCellWidth": 80], views: ["rateCell\(index)": rateCell])
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[rateCell]-0-|", options: [], metrics: nil, views: ["rateCell": rateCell])
			}
		}
		NSLayoutConstraint.activate(constraints)
	}
	
	private func updateCompactFunnelUIOptions() {
		
		for view in self.stackView1.arrangedSubviews {
			
			(view as! ZCRMCompactFunnelCell).options = self.renderOptions
			(view as! ZCRMCompactFunnelCell).setUIOptions()
		}
	}
	
	private func addCompactFunnelConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		self.scrollView.contentSize.width = self.compactStackViewWidth
		self.scrollView.contentSize.height = self.compactStackViewHeight
		
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-10-[scrollView]->=10-|", options: [], metrics: ["scrollViewHeight": self.compactStackViewHeight], views: ["title": self.titleView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[scrollView]-0-|", options: [], metrics: nil, views: ["scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[stackView(stackViewWidth)]", options: [], metrics: ["stackViewWidth": self.compactStackViewWidth], views: ["stackView": self.stackView1])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[stackView(stackViewHeight)]-0-|", options: [], metrics: ["stackViewHeight": self.compactStackViewHeight], views: ["stackView": self.stackView1])
		NSLayoutConstraint.activate(constraints)
	}
	
	private func renderClassicFunnel() {
		
		self.scrollView.translatesAutoresizingMaskIntoConstraints = false
		self.scrollView.showsVerticalScrollIndicator = false
		self.addSubview(self.scrollView)
		
		self.stackView1.translatesAutoresizingMaskIntoConstraints = false
		self.stackView1.axis = .vertical
		self.stackView1.spacing = 0
		self.stackView1.alignment = .center
		self.scrollView.addSubview(self.stackView1)
		
		var constraints: [NSLayoutConstraint] = []
		for (index, stage) in self.stages.enumerated() {
			
			let stageLabel = UILabel()
			stageLabel.translatesAutoresizingMaskIntoConstraints = false
			stageLabel.backgroundColor = stage.color
			stageLabel.font = self.renderOptions.valueFont
			stageLabel.textColor = self.renderOptions.valueFontColor
			stageLabel.textAlignment = .center
			stageLabel.layer.masksToBounds = true
			stageLabel.layer.cornerRadius = 20
			self.stackView1.addArrangedSubview(stageLabel)
			
			let stageLableWidth = self.classicStackViewWidth * ((100 - (index.toCGFloat() * 12.5)) / 100)
			
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[stageLabel\(index)(stagLableWidth)]", options: [], metrics: ["stagLableWidth": stageLableWidth], views: ["stageLabel\(index)": stageLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[stageLabel\(index)(stageLabelHeight)]", options: [], metrics: ["stageLabelHeight": 40], views: ["stageLabel\(index)": stageLabel])
			
			if index < self.stages.count - 1 {
				let rateLabel = UILabel()
				rateLabel.translatesAutoresizingMaskIntoConstraints = false
				rateLabel.font = self.renderOptions.rateFont
				rateLabel.textColor = self.renderOptions.rateFontColor
				rateLabel.textAlignment = .center
				self.stackView1.addArrangedSubview(rateLabel)
				
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[rateLabel\(index)]|", options: [], metrics: nil, views: ["rateLabel\(index)": rateLabel])
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[rateLabel\(index)(rateLabelHeight)]", options: [], metrics: ["rateLabelHeight": 30], views: ["rateLabel\(index)": rateLabel])
			}
		}
		NSLayoutConstraint.activate(constraints)
		
		self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
		self.collectionView.register(ZCRMClassicFunnelFooter.self, forCellWithReuseIdentifier: "classicFunnelFooter")
		self.collectionView.translatesAutoresizingMaskIntoConstraints = false
		self.collectionView.backgroundColor = self.backgroundColor
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		self.scrollView.addSubview(self.collectionView)
		
		self.conversionRateView.translatesAutoresizingMaskIntoConstraints = false
		self.conversionRateView.font = UIFont.systemFont(ofSize: 15)
		self.conversionRateView.text = "Conversion Rate: 100%"
		self.conversionRateView.textAlignment = .center
		self.scrollView.addSubview(self.conversionRateView)
	}
	
	private func updateClassicFunnelUIOptions() {
		
		for (index, view) in self.stackView1.arrangedSubviews.enumerated() {
			if index % 2 == 0 {
				(view as! UILabel).font = self.renderOptions.valueFont
				(view as! UILabel).textColor = self.renderOptions.valueFontColor
			} else {
				(view as! UILabel).font = self.renderOptions.rateFont
				(view as! UILabel).textColor = self.renderOptions.rateFontColor
			}
		}
	}
	
	private func addClassicFunnelConstraints() {
		
		self.scrollView.contentSize.height = self.classicStackViewHeight + self.classicCollectionViewHeight + self.conversionRateViewHeight + 35
		self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[scrollView(scrollViewWidth)]", options: [], metrics: ["scrollViewWidth": self.classicStackViewWidth], views: ["scrollView": self.scrollView])
		constraints.append(NSLayoutConstraint(item: self.scrollView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-15-[scrollView]-|", options: [], metrics: nil, views: ["title": self.titleView, "scrollView": self.scrollView])
		
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics:nil, views: ["stackView": self.stackView1])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[conversionRateView]|", options: [], metrics: nil, views: ["conversionRateView": self.conversionRateView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView(collectionViewWidth)]|", options: [], metrics: ["collectionViewWidth": self.classicStackViewWidth], views: ["collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView(stackViewHeight)]-15-[collectionView(collectionViewHeight)]-15-[conversionRateView(conversionRateViewHeight)]|", options: [], metrics: ["stackViewHeight": self.classicStackViewHeight, "collectionViewHeight": self.classicCollectionViewHeight, "conversionRateViewHeight": self.conversionRateViewHeight], views: ["stackView": self.stackView1, "collectionView": self.collectionView, "conversionRateView": self.conversionRateView])
		NSLayoutConstraint.activate(constraints)
	}
	
	private func updateSegmentUIOptions() {
		
		for view in self.stackView1.arrangedSubviews {
			(view as! UILabel).font = self.renderOptions.segmentFont
			(view as! UILabel).textColor = self.renderOptions.segmentFontColor
		}
	}
	
	private func renderSegmentFunnel() {
		
		self.scrollView.translatesAutoresizingMaskIntoConstraints = false
		self.scrollView.bounces = false
		self.addSubview(self.scrollView)
		
		self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
		self.collectionView.register(ZCRMSegmentFunnelCell.self, forCellWithReuseIdentifier: "zcrmSegmentFunnelCell")
		self.collectionView.translatesAutoresizingMaskIntoConstraints = false
		self.collectionView.backgroundColor = self.backgroundColor
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		self.scrollView.addSubview(self.collectionView)
		
		self.stackView1.translatesAutoresizingMaskIntoConstraints = false
		self.stackView1.axis = .vertical
		self.stackView1.spacing = 0
		self.stackView1.distribution = .fillEqually
		self.addSubview(self.stackView1)
		
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .gray
		label.textAlignment = .center
		label.font = self.renderOptions.segmentFont
		label.textColor = self.renderOptions.segmentFontColor
		self.stackView1.addArrangedSubview(label)
		
		if self.segmentsLabel != nil {
			self.setSegementLabel()
		}
		for (index, segment) in self.segments.enumerated() {
			
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = segment.label
			label.textAlignment = .center
			if index % 2 != 0 {
				label.backgroundColor = .gray
			}
			label.font = self.renderOptions.segmentFont
			label.textColor = self.renderOptions.segmentFontColor
			self.stackView1.addArrangedSubview(label)
		}
		
		let fLabel = UILabel()
		fLabel.translatesAutoresizingMaskIntoConstraints = false
		fLabel.font = self.renderOptions.segmentFont
		fLabel.textColor = self.renderOptions.segmentFontColor
		fLabel.text = "Total"
		fLabel.textAlignment = .center
		if self.segments.count % 2 != 0 {
			fLabel.backgroundColor = .gray
		}
		self.stackView1.addArrangedSubview(fLabel)
	}
	
	private func addSegmentFunnelConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		let collectioViewWidth = self.segmentCellWidth * (self.stages.count * 2).toCGFloat()
		
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentsView(segmentsViewWidth)][scrollView]|", options: [], metrics: ["segmentsViewWidth": self.segmentHeaderColumnWidth], views: ["segmentsView": self.stackView1, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[segmentsView(==collectionView)]|", options: [], metrics: nil, views: ["segmentsView": self.stackView1, "collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[scrollView(scrollViewHeight)]|", options: [], metrics: ["scrollViewHeight": self.segmentCollectionViewHeight], views: ["title": self.titleView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView(collectionViewWidth)]|", options: [], metrics: ["collectionViewWidth": collectioViewWidth], views: ["collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView(collectionViewHeight)]|", options: [], metrics: ["collectionViewHeight": self.segmentCollectionViewHeight], views: ["collectionView": self.collectionView])
		NSLayoutConstraint.activate(constraints)
	}
	
	
}


extension ZCRMFunnel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		if self.type == .classic {
			var footerWidth = self.classicStackViewWidth / 3
			if footerWidth < 40 {
				footerWidth = self.classicStackViewWidth / 2
			}
			return CGSize(width: footerWidth, height: 25)
		}
		
		return CGSize(width: self.segmentCellWidth, height: self.segmentCellHeight)
	}
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		if self.type == .classic {
			return self.stages.count
		}
		return (self.segments.count + 2) * (self.stages.count * 2)
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		var cell: UICollectionViewCell!
		if self.type == .classic {
			cell = self.getClassicFunnelFooterCell(collectionView, indexPath: indexPath)
		} else {
			cell = self.getSegmentFunnelCell(collectionView, indexPath: indexPath)
		}
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	private func getClassicFunnelFooterCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> ZCRMClassicFunnelFooter{
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classicFunnelFooter", for: indexPath) as! ZCRMClassicFunnelFooter
		cell.text = "Leads Created"
		cell.options = self.renderOptions
		cell.color = self.stages[indexPath.row].color
		cell.render()
		return cell
	}
	
	private func getSegmentFunnelCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> ZCRMSegmentFunnelCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zcrmSegmentFunnelCell", for: indexPath) as! ZCRMSegmentFunnelCell
		let indexPerRow = self.stages.count * 2
		if indexPath.row < indexPerRow{
			
			if indexPath.row < indexPerRow - 1 {
				
				if indexPath.row % 2 == 0 { //  cells for stages heading
					cell.text = self.stages[indexPath.row  % 2].label
					cell.font = self.renderOptions.stageFont
					cell.fontColor = self.renderOptions.stageFontColor
				} else  { // cell for rate headers
					cell.text = "➞"
				}
			} else {
				cell.text = "Conversion Rate" // right corner header
				cell.font = self.renderOptions.conversionRateFont
				cell.fontColor = self.renderOptions.conversionRateFontColor
			}
			cell.backgroundColor = .gray
			
		} else {
	
			if (indexPath.row + 1) % indexPerRow == 0  { // for conversion rate for a segment
				
				let totalCells = indexPerRow * (self.segments.count + 2)
				let lastCellIndex = totalCells - 1
				cell.font = self.renderOptions.conversionRateFont
				cell.fontColor = self.renderOptions.conversionRateFontColor
				
				if indexPath.row == lastCellIndex {
					cell.text = self.conversionRate.label
				} else {
					
					let indexWithoutHeader = (indexPath.row + 1) - indexPerRow
					let rateIndex = (indexWithoutHeader / indexPerRow) - 1
					cell.text = self.conversionRates[rateIndex].label
				}
			} else if (indexPath.row + 1) >= (indexPerRow * (self.segments.count + 1)) { // total of a stage and total rate between stage
				
				let indexWithoutHeaderAndData = (indexPath.row) -  (indexPerRow * (self.segments.count + 1))
				if indexPath.row % 2 == 0 { // total
					
					let totalIndex = (indexWithoutHeaderAndData) / 2
					cell.text = self.stagesData[totalIndex].label
					cell.font = self.renderOptions.stageFont
					cell.fontColor = self.renderOptions.stageFontColor
					
				} else { // rate
					
					let rateIndex = ((indexWithoutHeaderAndData + 1) / 2) - 1
					cell.text = self.stagesRate[rateIndex].label
					cell.font = self.renderOptions.rateFont
					cell.fontColor = self.renderOptions.rateFontColor
				}
			} else {
				
				if indexPath.row % 2 == 0 { // data cells of a stage
					
					let dataIndex = (indexPath.row - indexPerRow) / 2
					cell.text = self.data[dataIndex].label
					cell.font = self.renderOptions.valueFont
					cell.fontColor = self.renderOptions.valueFontColor
	
				} else { // rate between two stages
					
					let indexWithoutHeader = (indexPath.row + 1) - indexPerRow
					let rateIndex = (((indexWithoutHeader / 2) - 1) + (indexWithoutHeader / indexPerRow)) - ( 2 * (indexWithoutHeader / indexPerRow))
					cell.text = self.rates[rateIndex].label
					cell.font = self.renderOptions.rateFont
					cell.fontColor = self.renderOptions.rateFontColor
				}
			}
			if  (indexPath.row / indexPerRow) % 2 == 0  {
				cell.backgroundColor = .gray
			}
		}
		
		cell.render()
		return cell
	}
}

fileprivate extension ZCRMFunnel {
	
	fileprivate func loadData() {
		
		self.loadFunnelData()
		self.loadRates()
	}
	
	private func loadFunnelData() {
		
		if self.type == .segment {
			self.loadFunnelDatasForSegement()
		} else {
			self.loadCommonFunnelData()
		}
	}
	
	private func loadCommonFunnelData() {
		
		for stage in self.stages {
			self.data.append(self.dataSource.funnel(stage, segment: nil))
		}
	}
	
	private func loadFunnelDatasForSegement() {
		
		for segment in self.segments {
			for stage in self.stages {
				self.data.append(self.dataSource.funnel(stage, segment: segment))
			}
		}
		for stage in self.stages {
			self.stagesData.append(self.dataSource.funnel(stage, segment: nil))
		}
	}
	
	private func loadRates() {
		
		if self.type == .segment {
			self.loadRateForSegement()
		} else {
			self.loadCommonRate()
		}
	}
	
	private func loadCommonRate() {
		
		for (index, stage) in self.stages.enumerated() {
			if index == 0 {
				continue
			}
			self.rates.append(self.dataSource.rateFor(self.stages[index - 1], stage, fromStageIndex: index - 1, toStageIndex: index, segment: nil))
		}
	}
	
	private func loadRateForSegement() {
		
		for (index, segment) in self.segments.enumerated() {
			for (stageIndex, stage) in self.stages.enumerated() {
				if stageIndex == 0 {
					continue
				}
				self.rates.append(self.dataSource.rateFor(self.stages[stageIndex - 1], stage, fromStageIndex: stageIndex - 1, toStageIndex: index, segment: segment))
			}
			self.conversionRates.append(self.dataSource.conversionRateFor(self, segment))
		}
		for (index, stage) in self.stages.enumerated() {
			if index == 0 {
				continue
			}
			self.stagesRate.append(self.dataSource.rateFor(self.stages[index - 1], stage, fromStageIndex: index - 1, toStageIndex: index, segment: nil))
		}
		self.conversionRate = self.dataSource.conversionRateFor(self, nil)
	}
	
	fileprivate func setSegementLabel() {
		let subViews = self.stackView1.arrangedSubviews
		if subViews.count > 0 {
			(self.stackView1.arrangedSubviews[0] as! UILabel).text = self.segmentsLabel
		}
	}
	
	fileprivate func setData() {
		if self.type == .classic {
			self.setClassicFunnelData()
		} else if type == .path {
			self.setPathFunnelData()
		} else if type == .compact {
			self.setCompactFunnelData()
		}
	}

	private func setClassicFunnelData() {

		for (index, view) in self.stackView1.arrangedSubviews.enumerated() {
			if index % 2 == 0 {
				(view as! UILabel).text = self.data[index % 2].label
			} else  {
				(view as! UILabel).text = self.rates[(index - 1) / 2].label
			}
		}
	}

	private func setPathFunnelData() {
		
		for (index, view) in self.stackView1.arrangedSubviews.enumerated() {
			(view as! ZCRMPathFunnelCell).data = ZCRMFunnelData(label: self.stages[index].label, value: self.data[index].value)
		}
		for (index, view) in self.stackView2.arrangedSubviews.enumerated() {
			
			(view as! UILabel).text = self.rates[index].label
		}
	}
	
	private func setCompactFunnelData() {
		
		for (index, view) in self.stackView1.arrangedSubviews.enumerated() {
			var data: ZCRMFunnelData!
			if index % 2 == 0 {
				data = ZCRMFunnelData(label: self.stages[index % 2].label, value: self.data[index % 2].value)
			} else {
				data = self.rates[((index - 1) / 2)]
			}
			(view as! ZCRMCompactFunnelCell).data = data
		}
	}
}
