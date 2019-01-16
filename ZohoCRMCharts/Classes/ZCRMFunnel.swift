//
//  ZCRMFunnel.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 26/11/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

public final class ZCRMFunnel: UIView, ZCRMLayoutConstraintDelegate {
	
	public var dataSource: ZCRMFunnelDataSource! {
		didSet {
			if dataSource != nil {
				self.loadData()
				self.setData()
			}
		}
	}
	
	public var segmentsLabel: String! {
		didSet {
			if segmentsLabel != nil && self.type == .segment {
				self.setSegmentLabel()
			}
		}
	}
	
	public var titleFont: UIFont! {
		didSet {
			if titleFont != nil {
				self.renderOptions.titleFont = titleFont
				self.updateTitleUIOptions()
			}
		}
	}
	
	public var titleFontColor: UIColor! {
		didSet {
			if titleFontColor != nil {
				self.renderOptions.titleFontColor = titleFontColor
				self.updateTitleUIOptions()
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
				self.updateConverionRateViewUIOptions()
			}
		}
	}
	
	public var conversionRateFontColor: UIColor! {
		didSet {
			if conversionRateFontColor != nil {
				self.renderOptions.conversionRateFontColor = conversionRateFontColor
				self.updateConverionRateViewUIOptions()
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
	
	internal var viewConstraints: [NSLayoutConstraint] = []
	
	public let title: String
	public let type: ZCRMCharts.ZCRMFunnelType
	public let stages: [ZCRMFunnelStage]
	public var segments: [ZCRMFunnelSegment] = []
	
	fileprivate var renderOptions: FunnelRenderOptions = FunnelRenderOptions()
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
	fileprivate let standardConversionRateView: ZCRMStandardFunnelConversionRateView = ZCRMStandardFunnelConversionRateView()
	fileprivate let barChart: ZCRMBarChart = ZCRMBarChart()
	
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
		self.deactivateConstraints()
		self.addConstraints()
	}
	
	public func reloadData() {
		
		if dataSource != nil {
			self.loadData()
			if self.type != .segment {
				self.setData()
			}
		}
	}
}

//MARK: - UI Rendering.

fileprivate extension ZCRMFunnel{
	
	
	fileprivate var rowCount: Int {
		return self.segments.count + (self.type == .segment ? 2 : 1)
	}
	
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
		} else {
			self.addStandardFunnelConstraints()
		}
	}
	
	func updateChanges() {
		
		switch self.type {
		case .path:
			self.updatePathUIOptions()
		case .compact:
			self.updateCompactFunnelUIOptions()
		case .classic:
			self.updateClassicFunnelUIOptions()
		case .segment:
			self.updateSegmentUIOptions()
		case .standard:
			self.updateStandardUIOptions()
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
		} else  {
			self.renderStandardFunnel()
		}
	}
	
	private func renderTitleView() {
		self.setTitleView()
		self.updateTitleUIOptions()
	}
	
	func updateTitleUIOptions() {
		
		self.titleView.font = self.renderOptions.titleFont
		self.titleView.textColor = self.renderOptions.titleFontColor
	}
	
	func updateConverionRateViewUIOptions() {
		
		if self.type == .standard {
			self.standardConversionRateView.font = self.renderOptions.conversionRateFont
			self.standardConversionRateView.fontColor = self.renderOptions.conversionRateFontColor
			self.standardConversionRateView.setUIOptions()
		} else {
			self.conversionRateView.font = self.renderOptions.conversionRateFont
			self.conversionRateView.textColor = self.renderOptions.conversionRateFontColor
		}
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
	
	private func addConverionRateView() {
		
		self.updateConverionRateViewUIOptions()
		self.conversionRateView.translatesAutoresizingMaskIntoConstraints = false
		self.conversionRateView.textAlignment = .center
		self.conversionRateView.numberOfLines = 1
		self.addSubview(self.conversionRateView)
	}
	
	private func renderPathFunnel() {
		
		self.scrollView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.scrollView)
		
		self.stackView1.translatesAutoresizingMaskIntoConstraints = false
		self.stackView1.axis = .horizontal
		self.stackView1.distribution = .fillEqually
		self.scrollView.addSubview(self.stackView1)
		
		self.stackView2.translatesAutoresizingMaskIntoConstraints = false
		self.stackView2.axis = .horizontal
		self.stackView2.spacing = 5
		self.stackView2.distribution = .fillEqually
		self.scrollView.addSubview(self.stackView2)
		
		for (index, stage) in self.stages.enumerated() {
			
			let cell = ZCRMPathFunnelCell(isStart: index == 0, bgColor: stage.color)
			cell.options = self.renderOptions
			cell.setUIOptions()
			self.stackView1.addArrangedSubview(cell)
			if index == 0 {
				continue
			}
			let label = UILabel()
			label.textAlignment = .left
			label.font = self.renderOptions.rateFont
			label.textColor = self.renderOptions.rateFontColor
			self.stackView2.addArrangedSubview(label)
			
		}
		self.addConverionRateView()
	}
	
	private func updatePathUIOptions() {
		
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
		
		let pathCellStackViewWidth = 180 * self.stages.count.toCGFloat()
		var constraints: [NSLayoutConstraint] = []
		self.scrollView.contentSize.width = pathCellStackViewWidth
		let stageCount = self.stages.count.toCGFloat()
		let pathLabelStackViewWitdh = ( pathCellStackViewWidth / stageCount) * (stageCount - 1)
		
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[scrollView][conversionRateView]-|", options: [], metrics: nil, views: ["title": self.titleView, "scrollView": self.scrollView, "conversionRateView": self.conversionRateView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[scrollView]|", options: [], metrics: nil, views: ["scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[conversionRateView]|", options: [], metrics: nil, views: ["conversionRateView": self.conversionRateView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[pathLabelStackView(pathLabelStackViewWitdh)]|", options: [], metrics: ["pathLabelStackViewWitdh": pathLabelStackViewWitdh], views: ["pathLabelStackView": self.stackView2])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[pathStackView(pathStackViewWidth)]|", options: [], metrics: ["pathStackViewWidth": pathCellStackViewWidth], views: ["pathStackView": self.stackView1])
		self.activate(constraints: constraints)
		
		self.scrollView.layoutIfNeeded()
		constraints.removeAll()
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[pathStackView(pathStackViewHeight)][pathLabelStackView(pathStackViewHeight)]|", options: [], metrics: ["pathStackViewHeight": self.scrollView.frame.height / 2], views: ["pathStackView": self.stackView1, "pathLabelStackView": self.stackView2])
		self.activate(constraints: constraints, true)
		self.stackView1.spacing = self.scrollView.frame.height / 6 * -1 + 5
	}
	
	private func renderCompactFunnel() {
		
		self.scrollView.translatesAutoresizingMaskIntoConstraints = false
		self.scrollView.bounces = true
		self.addSubview(self.scrollView)
		
		self.stackView1.translatesAutoresizingMaskIntoConstraints = false
		self.stackView1.axis = .horizontal
		self.stackView1.spacing = 0
		self.scrollView.addSubview(self.stackView1)
		
		for (index, stage) in self.stages.enumerated() {
			
			let valueCell = ZCRMCompactFunnelCell(isRateView: false)
			valueCell.translatesAutoresizingMaskIntoConstraints = false
			self.stackView1.addArrangedSubview(valueCell)
			if index < self.stages.count - 1 {
				
				let rateCell = ZCRMCompactFunnelCell(isRateView: true)
				rateCell.translatesAutoresizingMaskIntoConstraints = false
				rateCell.backgroundColor = stage.color
				self.stackView1.addArrangedSubview(rateCell)
			}
		}
		self.addConverionRateView()
	}
	
	private func updateCompactFunnelUIOptions() {
		
		for view in self.stackView1.arrangedSubviews {
			
			(view as! ZCRMCompactFunnelCell).options = self.renderOptions
			(view as! ZCRMCompactFunnelCell).setUIOptions()
		}
	}
	
	private func addCompactFunnelConstraints() {
		
		let scrollViewCSWidth = (150 * self.stages.count + 80 * (self.stages.count - 1)).toCGFloat()
		self.scrollView.contentSize.width = scrollViewCSWidth
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[scrollView]-[conversionRateView]-|", options: [], metrics: nil, views: ["title": self.titleView, "scrollView": self.scrollView, "conversionRateView": self.conversionRateView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[scrollView]|", options: [], metrics: nil, views: ["scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[conversionRateView]|", options: [], metrics: nil, views: ["conversionRateView": self.conversionRateView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[stackView(stackViewWidth)]", options: [], metrics: ["stackViewWidth": scrollViewCSWidth], views: ["stackView": self.stackView1])
		self.activate(constraints: constraints)
		
		self.scrollView.layoutIfNeeded()
		constraints.removeAll()
		constraints.append(NSLayoutConstraint(item: self.stackView1, attribute: .height, relatedBy: .equal, toItem: self.scrollView, attribute: .height, multiplier: 0, constant: self.scrollView.frame.height))
		for (index, compactCell) in self.stackView1.arrangedSubviews.enumerated() {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[compactCell\(index)(width)]", options: [], metrics: ["width": index % 2 == 0 ? 150 : 80], views: ["compactCell\(index)": compactCell])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[compactCell\(index)]|", options: [], metrics: nil, views: ["compactCell\(index)": compactCell])
		}
		self.activate(constraints: constraints, true)
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
			
			if index < self.stages.count - 1 {
				let rateLabel = UILabel()
				rateLabel.translatesAutoresizingMaskIntoConstraints = false
				rateLabel.font = self.renderOptions.rateFont
				rateLabel.textColor = self.renderOptions.rateFontColor
				rateLabel.textAlignment = .center
				self.stackView1.addArrangedSubview(rateLabel)
			}
		}
		
		self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
		self.collectionView.register(ZCRMClassicFunnelFooter.self, forCellWithReuseIdentifier: "classicFunnelFooter")
		self.collectionView.translatesAutoresizingMaskIntoConstraints = false
		self.collectionView.backgroundColor = self.backgroundColor
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		self.scrollView.addSubview(self.collectionView)
		
		self.addConverionRateView()
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
		
		let classicCollectionViewHeight: CGFloat = {
			var footerHeight: CGFloat = 25
			if self.stages.count > 2 {
				footerHeight *= 3
			}
			return footerHeight
		}()
		let stackViewHeight = (70 * self.stages.count.toCGFloat()) - 30
		self.scrollView.contentSize.height = stackViewHeight + classicCollectionViewHeight
		let stackViewWidth = self.frame.width * 0.90
		
		var constraints: [NSLayoutConstraint] = []
		
		for (i, label) in self.stackView1.arrangedSubviews.enumerated() {
			
			let labelHeight = i % 2 == 0 ? 40 : 30
			let labelWidth = i % 2 == 0 ? stackViewWidth * ((100 - ((i / 2).toCGFloat() * 12.5)) / 100) : stackViewWidth
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[label\(i)(width)]", options: [], metrics: ["width": labelWidth], views: ["label\(i)": label])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[label\(i)(height)]", options: [], metrics: ["height": labelHeight], views: ["label\(i)": label])
		}
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[scrollView(scrollViewWidth)]", options: [], metrics: ["scrollViewWidth": stackViewWidth], views: ["scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[conversionRateView]|", options: [], metrics: nil, views: ["conversionRateView": self.conversionRateView])
		constraints.append(NSLayoutConstraint(item: self.scrollView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-15-[scrollView]-[conversionRateView]-|", options: [], metrics: nil, views: ["title": self.titleView, "scrollView": self.scrollView, "conversionRateView": self.conversionRateView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics:nil, views: ["stackView": self.stackView1])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView(collectionViewWidth)]|", options: [], metrics: ["collectionViewWidth": stackViewWidth], views: ["collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView(stackViewHeight)]-15-[collectionView(collectionViewHeight)]|", options: [], metrics: ["stackViewHeight": stackViewHeight, "collectionViewHeight": classicCollectionViewHeight], views: ["stackView": self.stackView1, "collectionView": self.collectionView])
		self.activate(constraints: constraints)
		
		var footerWidth = stackViewWidth / 2
		if footerWidth < 100  {
			footerWidth = 150
		}
		self.collectionViewFlowLayout.itemSize = CGSize(width: footerWidth, height: 25)
		self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		self.collectionViewFlowLayout.minimumLineSpacing = 0
		self.collectionViewFlowLayout.minimumInteritemSpacing = 0
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
		
		if self.type == .segment {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.backgroundColor = .gray
			label.numberOfLines = 2
			label.textAlignment = .center
			label.font = self.renderOptions.segmentFont
			label.textColor = self.renderOptions.segmentFontColor
			self.stackView1.addArrangedSubview(label)
		}
		
		for (index, segment) in self.segments.enumerated() {
			
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = segment.label
			label.numberOfLines = 2
			label.textAlignment = .center
			if index % 2 != 0 && self.type == .segment {
				label.backgroundColor = .gray
			} else if index % 2 == 0 && self.type == .standard {
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
		if self.segments.count % 2 != 0 && self.type == .segment{
			fLabel.backgroundColor = .gray
		}
		self.stackView1.addArrangedSubview(fLabel)
		if self.type == .segment {
			self.addConverionRateView()
		}
	}
	
	private func addSegmentFunnelConstraints() {
		
		let segmentCellWidth: CGFloat = 100
		let headerColumnWidth = self.frame.width * 0.35 < 120 ? 120 : self.frame.width * 0.35
		let collectionViewWidth = segmentCellWidth * (self.stages.count * 2).toCGFloat()
		var constraints: [NSLayoutConstraint] = []
		
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentsView(segmentsViewWidth)][scrollView]|", options: [], metrics: ["segmentsViewWidth":  headerColumnWidth], views: ["segmentsView": self.stackView1, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[segmentsView]-[conversionRateView]-|", options: [], metrics: nil, views: ["title": self.titleView,"segmentsView": self.stackView1, "conversionRateView": self.conversionRateView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[scrollView]-[conversionRateView]-|", options: [], metrics:  nil, views: ["title": self.titleView, "scrollView": self.scrollView, "conversionRateView": self.conversionRateView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[conversionRateView]|", options: [], metrics: nil, views: ["conversionRateView": self.conversionRateView])
		self.activate(constraints: constraints)
		constraints.removeAll()
		self.stackView1.layoutIfNeeded()
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView(collectionViewWidth)]|", options: [], metrics: ["collectionViewWidth": collectionViewWidth], views: ["collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView(collectionViewHeight)]|", options: [], metrics: ["collectionViewHeight": self.stackView1.frame.height], views: ["collectionView": self.collectionView])
		self.activate(constraints: constraints, true)
		
		self.collectionViewFlowLayout.itemSize = CGSize(width: segmentCellWidth, height: self.stackView1.frame.height / self.rowCount.toCGFloat())
		self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		self.collectionViewFlowLayout.minimumLineSpacing = 0
		self.collectionViewFlowLayout.minimumInteritemSpacing = 0
	}
	
	
	private func renderStandardFunnel() {
		
		if self.segments.count > 0 {
			self.renderSegmentFunnel()
			self.collectionView.bounces = false
		} else {
			
			self.scrollView.translatesAutoresizingMaskIntoConstraints = false
			self.scrollView.bounces = false
			self.addSubview(self.scrollView)
		}
		
		self.standardConversionRateView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.standardConversionRateView)
		
		self.barChart.translatesAutoresizingMaskIntoConstraints = false
		self.barChart.color = self.renderOptions.barColor
		self.barChart.valueFontColor = self.renderOptions.valueFontColor
		self.barChart.titleFontColor = self.renderOptions.stageFontColor
		self.barChart.rateFontColor = self.renderOptions.rateFontColor
		self.scrollView.addSubview(self.barChart)
	}
	
	private func updateStandardUIOptions() {
		
		self.barChart.valueFontColor = self.renderOptions.valueFontColor
		self.barChart.titleFontColor = self.renderOptions.stageFontColor
		self.barChart.rateFontColor = self.renderOptions.rateFontColor
		self.barChart.color = self.renderOptions.barColor
		self.barChart.setNeedsLayout()
		
		self.standardConversionRateView.font = self.renderOptions.conversionRateFont
		self.standardConversionRateView.fontColor = self.renderOptions.conversionRateFontColor
		self.standardConversionRateView.setUIOptions()
		
		for label in self.stackView1.arrangedSubviews {
			(label as! UILabel).font = self.renderOptions.segmentFont
			(label as! UILabel).textColor = self.renderOptions.segmentFontColor
		}
	}
	
	private func addStandardFunnelConstraints() {
		
		let cellWidth: CGFloat = self.segments.isEmpty ? 80 : 100
		let space = cellWidth * 0.1
		let cVWidth = cellWidth * (self.stages.count * 2).toCGFloat()
		let chartWidth =  self.segments.isEmpty ? cVWidth - cellWidth : cVWidth
		let rateWidth = self.frame.width * 0.35 < 120 ? 120 : self.frame.width * 0.35
		self.barChart.barWidth = cellWidth - (space * 2)
		self.barChart.space = space
		self.scrollView.contentSize.width = self.segments.isEmpty ? chartWidth : cVWidth
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[rateView(rateViewWidth)][scrollView]|", options: [], metrics: ["rateViewWidth": rateWidth], views: ["rateView": self.standardConversionRateView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[scrollView]|", options: [], metrics: nil, views:[ "title": self.titleView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[barChart(chartWidth)]|", options: [], metrics: ["chartWidth": chartWidth], views: ["barChart": self.barChart])
		
		if self.segments.count > 0 {
			
			let barChartHeight = self.frame.height * 0.45
			
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[rateView(conversionRateHeight)][segmentsView]|", options: [], metrics: ["conversionRateHeight": barChartHeight], views: ["title": self.titleView,"rateView": self.standardConversionRateView, "segmentsView": self.stackView1, "collectionView": self.collectionView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentsView(rateViewWidth)][scrollView]|", options: [], metrics: ["rateViewWidth": rateWidth], views: ["segmentsView": self.stackView1, "scrollView": self.scrollView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[collectionView(collectionViewWidth)]", options: [], metrics: ["collectionViewWidth": cVWidth], views: ["collectionView": self.collectionView])

			self.activate(constraints: constraints)
			self.stackView1.layoutIfNeeded()
			
			constraints.removeAll()
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[barChart(barChartHeight)][collectionView(collectionViewHeight)]|", options: [], metrics: ["barChartHeight": barChartHeight , "collectionViewHeight": self.stackView1.frame.height], views: ["barChart": self.barChart, "collectionView": self.collectionView])
			self.activate(constraints: constraints, true)
			
			self.collectionViewFlowLayout.itemSize = CGSize(width: cellWidth, height: self.stackView1.frame.height / self.rowCount.toCGFloat())
			self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
			self.collectionViewFlowLayout.minimumLineSpacing = 0
			self.collectionViewFlowLayout.minimumInteritemSpacing = 0
			
		} else {
			
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[rateView]|", options: [], metrics: nil, views: ["title": self.titleView,"rateView": self.standardConversionRateView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[barChart(scrollView)]|", options: [], metrics: nil, views: ["barChart": self.barChart, "scrollView": self.scrollView])
			self.activate(constraints: constraints)
		}
	}
}

//MARK: - Collection view delegate.

extension ZCRMFunnel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		var count: Int!
		if self.type == .classic {
			count =  self.stages.count
		} else if self.type == .segment {
			count = (self.segments.count + 2) * (self.stages.count * 2)
		} else if self.type == .standard {
			count = (self.segments.count + 1) * (self.stages.count * 2)
		}
		return count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		var cell: UICollectionViewCell!
		if self.type == .classic {
			cell = self.getClassicFunnelFooterCell(collectionView, indexPath: indexPath)
		} else if self.type == .segment {
			cell = self.getSegmentFunnelCell(collectionView, indexPath: indexPath)
		} else if self.type == .standard {
			cell = self.getStandardFunnelCell(collectionView, indexPath: indexPath)
		}
		return cell
	}
	
	private func getClassicFunnelFooterCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> ZCRMClassicFunnelFooter {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classicFunnelFooter", for: indexPath) as! ZCRMClassicFunnelFooter
		cell.text = self.stages[indexPath.row].label
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
					cell.text = self.stages[indexPath.row  / 2].label
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
	
	private func getStandardFunnelCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> ZCRMSegmentFunnelCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zcrmSegmentFunnelCell", for: indexPath) as! ZCRMSegmentFunnelCell
		let indexPerRow = self.stages.count * 2
		if (indexPath.row + 1) % indexPerRow == 0  {
			
			let totalCells = indexPerRow * (self.segments.count + 1)
			let lastIndex = totalCells - 1
			cell.font = self.renderOptions.conversionRateFont
			cell.fontColor = self.renderOptions.conversionRateFontColor
			
			if indexPath.row == lastIndex {
				cell.text = self.conversionRate.label
			} else {
				
				let rateIndex = ((indexPath.row + 1) / indexPerRow) - 1
				cell.text = self.conversionRates[rateIndex].label
			}
		} else if (indexPath.row + 1) >= (indexPerRow * (self.segments.count)) {
			
			let indexWithoutData = indexPath.row - (indexPerRow * self.segments.count)
			if indexPath.row % 2 == 0 {
				
				let totalIndex = indexWithoutData / 2
				cell.text = self.stagesData[totalIndex].label
				cell.font = self.renderOptions.stageFont
				cell.fontColor = self.renderOptions.stageFontColor
			}
		} else {
			
			if indexPath.row % 2 == 0 {
				
				let dataIndex = indexPath.row / 2
				cell.text = self.data[dataIndex].label
				cell.font = self.renderOptions.valueFont
				cell.fontColor = self.renderOptions.valueFontColor
			} else {
				
				let index = indexPath.row  + 1
				let rateIndex = (((index / 2) - 1) + (index / indexPerRow)) - ( 2 * (index / indexPerRow))
				cell.text = self.rates[rateIndex].label
				cell.font = self.renderOptions.rateFont
				cell.fontColor = self.renderOptions.rateFontColor
			}
		}
		if  (indexPath.row / indexPerRow) % 2 == 0  {
			cell.backgroundColor = .gray
		}
		
		cell.render()
		return cell
	}
}

//MARK: - Data handling methods.

fileprivate extension ZCRMFunnel {
	
	fileprivate func loadData() {
		
		self.loadFunnelData()
		self.loadRates()
	}
	
	private func loadFunnelData() {
		
		if self.type == .segment {
			self.loadSegmentFunnelData()
		} else if self.type == .standard {
			self.loadStandardFunnelData()
		} else {
			self.loadCommonFunnelData()
		}
	}
	
	private func loadCommonFunnelData() {
		
		for stage in self.stages {
			self.data.append(self.dataSource.funnel(stage))
		}
	}
	
	private func loadSegmentFunnelData() {
		
		for segment in self.segments {
			for stage in self.stages {
				self.data.append(self.dataSource.funnel(stage, segment: segment))
			}
		}
		for stage in self.stages {
			self.stagesData.append(self.dataSource.funnel(stage))
		}
	}
	
	private func loadStandardFunnelData() {
		
		if self.segments.count > 0 {
			self.loadSegmentFunnelData()
		} else {
			self.loadCommonFunnelData()
		}
	}
	
	private func loadRates() {
		
		if self.type == .segment {
			self.loadRateForSegement()
		} else if self.type == .standard {
			self.loadRateForStandard()
		} else {
			self.loadCommonRate()
		}
	}
	
	private func loadCommonRate() {
		
		for (index, stage) in self.stages.enumerated() {
			if index == 0 {
				continue
			}
			self.rates.append(self.dataSource.rateFor(self.stages[index - 1], stage))
		}
		self.conversionRate = self.type == .path ? self.dataSource.overallDropRateFor(self) : self.dataSource.conversionRateFor(self)
	}
	
	private func loadRateForSegement() {
		
		for segment in self.segments {
			for (stageIndex, stage) in self.stages.enumerated() {
				if stageIndex == 0 {
					continue
				}
				self.rates.append(self.dataSource.rateFor(self.stages[stageIndex - 1], stage , segment: segment))
			}
			self.conversionRates.append(self.dataSource.conversionRateFor(self, segment))
		}
		self.conversionRate = self.dataSource.conversionRateFor(self)
	}
	
	private func loadRateForStandard() {
		
		if self.segments.count > 0 {
			self.loadRateForSegement()
			for (index, stage) in self.stages.enumerated() {
				if index == 0 {
					continue
				}
				self.stagesRate.append(self.dataSource.rateFor(self.stages[index - 1], stage))
			}
		} else {
			for (index, stage) in self.stages.enumerated() {
				if index == 0 {
					continue
				}
				self.rates.append(self.dataSource.rateFor(self.stages[index - 1], stage))
			}
		}
		
		self.conversionRate = self.type == .path ? self.dataSource.overallDropRateFor(self) : self.dataSource.conversionRateFor(self)
	}
	
	fileprivate func setSegmentLabel() {
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
		} else if self.type == .standard {
			self.setStandardFunnelData()
		} else {
			self.setConversionRateText()
		}
	}
	
	private func setClassicFunnelData() {
		
		for (index, view) in self.stackView1.arrangedSubviews.enumerated() {
			if index % 2 == 0 {
				(view as! UILabel).text = self.data[index / 2].label
			} else  {
				(view as! UILabel).text = self.rates[(index - 1) / 2].label
			}
		}
		self.setConversionRateText()
	}
	
	private func setPathFunnelData() {
		
		for (index, view) in self.stackView1.arrangedSubviews.enumerated() {
			(view as! ZCRMPathFunnelCell).data = ZCRMFunnelData(label: self.stages[index].label, value: self.data[index].value)
		}
		for (index, view) in self.stackView2.arrangedSubviews.enumerated() {
			(view as! UILabel).text = self.rates[index].label
		}
		self.setConversionRateText()
	}
	
	private func setCompactFunnelData() {
		
		for (index, view) in self.stackView1.arrangedSubviews.enumerated() {
			var data: ZCRMFunnelCellData!
			if index % 2 == 0 {
				data = ZCRMFunnelCellData(label: self.stages[index / 2].label, value: self.data[index / 2].label)
			} else {
				data = ZCRMFunnelCellData(label: self.rates[((index - 1) / 2)].label, value: "")
			}
			(view as! ZCRMCompactFunnelCell).data = data
		}
		self.setConversionRateText()
	}
	
	private func setStandardFunnelData() {
		
		
		var barData: [ZCRMBarData] = []
		var barRates: [String] = []
		let stagesData: [ZCRMFunnelData] = self.segments.count > 0 ? self.stagesData : self.data
		let stagesRate: [ZCRMFunnelData] = self.segments.count > 0 ? self.stagesRate : self.rates
		
		for (index, stage) in self.stages.enumerated() {
			
			var bar = ZCRMBarData()
			bar.title = stage.label
			bar.value = stagesData[index].value.toCGFloat()
			bar.text = stagesData[index].label
			barData.append(bar)
			if index < self.stages.count - 1 {
				barRates.append(stagesRate[index].label)
			}
		}
		
		self.standardConversionRateView.fromValueLabel.text = stagesData[0].label
		self.standardConversionRateView.rateLabel.text = self.conversionRate.label
		self.standardConversionRateView.toValueLabel.text = stagesData.last!.label
		
		self.barChart.rates = barRates
		self.barChart.maxValue = stagesData.map({ (data) -> Int in
			return data.value
		}).max()!.toCGFloat()
		self.barChart.data = barData
		self.barChart.setNeedsLayout()
	}
	
	private func setConversionRateText() {
		
		self.conversionRateView.text = self.type == .path ? "Overall Drop Rate : \(self.conversionRate.label)" : "Conversion Rate : \(self.conversionRate.label)"
	}
}

public extension ZCRMFunnelDataSource {
	
	func funnel(_ stage: ZCRMFunnelStage, segment: ZCRMFunnelSegment) -> ZCRMFunnelData {
		fatalError("funnel(_ stage: ZCRMFunnelStage, segment: ZCRMFunnelSegment) has not been implemented")
	}
	
	func conversionRateFor(_ funnel: ZCRMFunnel) -> ZCRMFunnelData {
		fatalError("conversionRateFor(_ funnel: ZCRMFunnel) has not been implemented")
	}
	
	func conversionRateFor(_ funnel: ZCRMFunnel, _ segment: ZCRMFunnelSegment) -> ZCRMFunnelData {
		fatalError("conversionRateFor(_ funnel: ZCRMFunnel, _ segment: ZCRMFunnelSegment) has not been implemented")
	}
	
	func rateFor(_ fromStage: ZCRMFunnelStage, _ toStage: ZCRMFunnelStage) -> ZCRMFunnelData {
		fatalError("rateFor(_ fromStage: ZCRMFunnelStage, _ toStage: ZCRMFunnelStage) has not been implemented")
	}
	
	func rateFor(_ fromStage: ZCRMFunnelStage, _ toStage: ZCRMFunnelStage, segment: ZCRMFunnelSegment) -> ZCRMFunnelData {
		fatalError("rateFor(_ fromStage: ZCRMFunnelStage, _ toStage: ZCRMFunnelStage, fromStageIndex: Int, toStageIndex: Int, segment: ZCRMFunnelSegment) has not been implemented")
	}
	
	func overallDropRateFor(_ funnel: ZCRMFunnel) -> ZCRMFunnelData {
		fatalError("overallDropRateFor(_ funnel: ZCRMFunnel) has not been implemented")
	}
}
