//
//  ZCRMComparator.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 31/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

public final class ZCRMComparator: UIView {
	
	public var dataSource: ZCRMComparatorDataSource! {
		didSet {
			if dataSource != nil {
				self.setChunkDatas()
			}
		}
	}
	
	public var showGroupsVertically: Bool = true {
		didSet {
			if self.type == .sport {
				self.addHeaders()
			}
		}
	}
	
	public var titleFont: UIFont!  {
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
	
	public var chunkDataFont: UIFont! {
		didSet {
			if chunkDataFont != nil {
				self.renderOptions.chunkDataFont = chunkDataFont
			}
		}
	}
	
	public var chunkDataFontColor: UIColor! {
		didSet {
			if chunkDataFontColor != nil {
				self.renderOptions.chunkDataFontColor = chunkDataFontColor
			}
		}
	}
	
	public var chunkFont: UIFont! {
		didSet {
			if chunkFont != nil {
				self.renderOptions.chunkFont = chunkFont
				self.updateChunks()
			}
		}
	}
	
	public var chunkFontColor: UIColor! {
		didSet {
			if chunkFontColor != nil {
				self.renderOptions.chunkFontColor = chunkFontColor
				self.updateChunks()
			}
		}
	}
	
	public var groupFont: UIFont! {
		didSet {
			if groupFont != nil {
				self.renderOptions.groupFont = groupFont
				self.updateHeaders()
			}
		}
	}
	
	public var groupFontColor: UIColor! {
		didSet {
			if groupFontColor != nil {
				self.renderOptions.groupFontColor = groupFontColor
				self.updateHeaders()
			}
		}
	}
	
	public var positiveColor: UIColor! {
		didSet {
			if positiveColor != nil {
				self.renderOptions.positiveColor = positiveColor
			}
		}
	}
	
	public var negativeColor: UIColor! {
		didSet {
			if negativeColor != nil {
				self.renderOptions.negativeColor = negativeColor
			}
		}
	}
	
	public var neutralColor: UIColor! {
		didSet {
			if neutralColor != nil {
				self.renderOptions.positiveColor = positiveColor
			}
		}
	}
	
	public var classicHeaderRowColor: UIColor! {
		didSet {
			if classicHeaderRowColor != nil {
				self.renderOptions.classicHeaderRowColor = classicHeaderRowColor
			}
		}
	}
	
	public var elegantDiffColor: UIColor! {
		didSet {
			if elegantDiffColor != nil {
				self.renderOptions.elegantDiffColor = elegantDiffColor
				self.updateHeaders()
			}
		}
	}
	
	public var columnWidth: CGFloat!
	
	fileprivate let title: String
	fileprivate let type: ZCRMCharts.ZCRMComparatorType
	fileprivate let groupings: ZCRMComparatorGroupings
	fileprivate let chunks: [ZCRMComparatorChunk]
	fileprivate let titleView: UILabel = UILabel()
	fileprivate var renderOptions: ComparatorRenderOptions = ComparatorRenderOptions()
	fileprivate var collectionView: UICollectionView!
	fileprivate let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
	fileprivate let scrollView: UIScrollView = UIScrollView()
	fileprivate let chunksView: UIStackView = UIStackView()
	fileprivate let headersView: UIStackView = UIStackView()
	fileprivate var chunkDatas: [ZCRMChunkData] = []
	
	public init(title: String, type: ZCRMCharts.ZCRMComparatorType, groupings: ZCRMComparatorGroupings, chunks: [ZCRMComparatorChunk]) {
		self.title = title
		self.type = type
		self.groupings = groupings
		self.chunks = chunks
		super.init(frame: .zero)
		self.render()
	}
	
	public init(frame: CGRect, title: String, type: ZCRMCharts.ZCRMComparatorType, groupings: ZCRMComparatorGroupings, chunks: [ZCRMComparatorChunk]) {
		self.title = title
		self.type = type
		self.groupings = groupings
		self.chunks = chunks
		super.init(frame: frame)
		self.render()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		
		self.addConstraints()
	}
}

fileprivate extension ZCRMComparator {
	
	var cellHeight: CGFloat {
		get {
			let height = self.collectionViewHeight
			var heightForCells = height * 0.75
			if self.type == .elegant || self.type == .classic {
				heightForCells = height
				if self.type == .classic {
					return heightForCells / (self.groupings.groups.count.toCGFloat() + 1)
				}
			}
			return  heightForCells / self.chunks.count.toCGFloat()
		}
	}
	
	var cellWidth: CGFloat {
		get {
			if self.columnWidth != nil && self.type != .sport {
				return columnWidth
			}
			if self.type == .elegant {
				return 150
			} else if self.type == .classic {
				return 120
			}
			let width = self.collectionViewWidth
			let widthForCells = width * 0.7
			return widthForCells /  self.groupings.groups.count.toCGFloat()
		}
	}
	
	var headerHeight: CGFloat {
		get {
			if self.type == .elegant {
				return self.cellHeight - 10
			}
			return self.frame.height * 0.25
		}
	}
	
	var collectionViewHeight: CGFloat {
		get {
			if self.type == .sport || self.type == .elegant {
				return self.frame.height * 0.70
			}
			return self.frame.height * 0.85
		}
	}
	
	var collectionViewWidth: CGFloat {
		get {
			if self.type == .sport {
				return self.frame.width * 0.75
			} else if self.type == .classic {
				return (self.cellWidth.toInt() * self.chunks.count).toCGFloat()
			}
			return (self.cellWidth.toInt() * self.groupings.groups.count).toCGFloat()
		}
	}
}

fileprivate extension ZCRMComparator {
	
	func render() {
		
		self.clipsToBounds = true
		self.renderTitleView()
		self.renderView()
	}
	
	func addConstraints() {
		
		if self.type == .sport {
			self.addSportComparatorConstraints()
		} else if self.type == .elegant {
			self.addElegantComparatorConstraints()
		} else {
			self.addClassicComparatorConstraints()
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
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[title]", options: [], metrics: nil, views: ["title": self.titleView])
		NSLayoutConstraint.activate(constraints)
	}

	/**
		Adds the header view to the Comparator of type sport and elegant.
	*/
	func addHeaders() {
		
		let headers = self.headersView.arrangedSubviews
		for header in headers {
			header.removeFromSuperview()
		}
		for (index, group) in self.groupings.groups.enumerated() {
			
			let header = ZCRMComparatorHeader(type: self.type, true)
			header.group = group
			header.options = self.renderOptions
			header.alignVertical = self.showGroupsVertically
			if self.type == .elegant && (index + 1) % 2 != 0 {
				header.backgroundColor = self.renderOptions.elegantDiffColor
			} else {
				header.backgroundColor = self.backgroundColor
			}
			header.render()
			self.headersView.addArrangedSubview(header)
		}
	}
	
	func updateHeaders() {
		
		if self.type == .classic {
			return
		}
		for (index, view) in  self.headersView.arrangedSubviews.enumerated() {
			let header = view as! ZCRMComparatorHeader
			if self.type == .elegant && (index + 1) % 2 != 0 {
				header.backgroundColor = self.renderOptions.elegantDiffColor
			}
			header.options = self.renderOptions
			header.setUIOptions()
		}
	}
	
	private func addChunks() {
		
		let chunks = self.chunksView.arrangedSubviews
		for chunk in chunks {
			chunk.removeFromSuperview()
		}
		if self.type == .classic {
			
			let groupingsLabelView = ZCRMComparatorChunkView()
			groupingsLabelView.label.text = self.groupings.label
			groupingsLabelView.addBottomBorder = true
			groupingsLabelView.backgroundColor = self.renderOptions.classicHeaderRowColor
			groupingsLabelView.options = self.renderOptions
			self.chunksView.addArrangedSubview(groupingsLabelView)
			for (index, group) in self.groupings.groups.enumerated() {
				
				let chunkView = ZCRMComparatorChunkView()
				chunkView.label.text = group.label
				chunkView.options = self.renderOptions
				self.chunksView.addArrangedSubview(chunkView)
				if index < self.groupings.groups.count - 1{
					chunkView.addBottomBorder = true
				}
			}
		} else {
			
			for (index, chunk) in self.chunks.enumerated() {
				
				let chunkView = ZCRMComparatorChunkView()
				
				chunkView.label.text = chunk.label
				self.chunksView.addArrangedSubview(chunkView)
				if self.type == .classic && index < self.chunks.count - 1{
					chunkView.addBottomBorder = true
				}
			}
		}
	}
	
	func updateChunks() {
		
		for view in self.chunksView.arrangedSubviews {
			let chunkView = view as! ZCRMComparatorChunkView
			chunkView.options = self.renderOptions
			chunkView.setUIOptions()
		}
	}
	
	private func renderView() {
		
		self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
		self.collectionView.register(ZCRMComparatorCell.self, forCellWithReuseIdentifier: "zcrmComparatorCell")
		self.collectionView.translatesAutoresizingMaskIntoConstraints = false
		self.collectionView.backgroundColor = self.backgroundColor
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		self.scrollView.addSubview(self.collectionView)
		
		self.scrollView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.scrollView)
		
		self.chunksView.translatesAutoresizingMaskIntoConstraints = false
		self.chunksView.axis = .vertical
		self.chunksView.spacing = 0
		self.chunksView.distribution = .fillEqually
		self.addSubview(self.chunksView)
		
		if self.type != .classic {
			
			self.headersView.translatesAutoresizingMaskIntoConstraints = false
			self.headersView.axis = .horizontal
			self.headersView.spacing = 0
			self.headersView.distribution = .fillEqually
			self.scrollView.addSubview(self.headersView)
			self.addHeaders()
		}
		self.addChunks()
	}
	
	private func addSportComparatorConstraints() {
		
		let horizontalSpacing = ((self.collectionViewWidth * 0.3) / (self.groupings.groups.count + 1).toCGFloat()) / 2
		let verticalSpacing = ((self.collectionViewHeight * 0.25) / self.chunks.count.toCGFloat()) / 2
		self.scrollView.bounces = false
		self.scrollView.contentSize.width = self.collectionViewWidth
		self.scrollView.contentSize.height = self.collectionViewHeight
		self.chunksView.layoutMargins = UIEdgeInsets(top: verticalSpacing * 3, left: horizontalSpacing * 2, bottom: 0, right: 0)
		self.chunksView.isLayoutMarginsRelativeArrangement = true
		self.headersView.layoutMargins =  UIEdgeInsets(top: 0, left: horizontalSpacing / 2 , bottom: 0, right: horizontalSpacing / 2)
		self.headersView.isLayoutMarginsRelativeArrangement = true
		self.collectionViewFlowLayout.itemSize = CGSize(width: self.cellWidth, height: self.cellHeight)
		self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: verticalSpacing, left: horizontalSpacing * 2, bottom: verticalSpacing, right: horizontalSpacing * 2)

		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[scrollView]-0-|", options: [], metrics: nil, views: ["title": self.titleView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[chunksView]-0-[scrollView(==\(self.collectionViewWidth))]-0-|", options: [], metrics: nil, views: ["chunksView": self.chunksView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[chunksLabel(==\(self.collectionViewHeight))]-0-|", options: [], metrics: nil, views: ["chunksLabel": self.chunksView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[headers(==\(self.collectionViewWidth))]-0-|", options: [], metrics: nil, views: ["headers": self.headersView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView(==\(self.collectionViewWidth))]-0-|", options: [], metrics: nil, views: ["collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[headers(==\(self.headerHeight))]-0-[collectionView(==\(self.collectionViewHeight))]-0-|", options: [], metrics: nil, views: ["headers": self.headersView, "collectionView": self.collectionView])
		NSLayoutConstraint.activate(constraints)
	}
	
	private func addElegantComparatorConstraints() {
		
		self.scrollView.contentSize.width = self.cellWidth * self.groupings.groups.count.toCGFloat()
		self.chunksView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
		self.scrollView.bounces = false
		self.chunksView.isLayoutMarginsRelativeArrangement = true
		self.collectionViewFlowLayout.itemSize = CGSize(width: self.cellWidth, height: self.cellHeight)
		self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	
		var chunksWidth = 120
		if self.frame.width > 400 {
			chunksWidth = 150
		}
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollView(==\(self.headerHeight + self.collectionViewHeight))]-0-|", options: [], metrics: nil, views: ["title": self.titleView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat:  "H:|-0-[chunksView(<=\(chunksWidth))]-10-[scrollView]-0-|", options: [], metrics: nil, views: ["chunksView": self.chunksView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[chunksLabel(==collectionView)]-0-|", options: [], metrics: nil, views: ["chunksLabel": self.chunksView, "collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[headers(==\(self.scrollView.contentSize.width))]-0-|", options: [], metrics: nil, views: ["headers": self.headersView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView(==\(self.scrollView.contentSize.width))]-0-|", options: [], metrics: nil, views: ["collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[headers(==\(self.headerHeight))]-0-[collectionView(==\(self.collectionViewHeight))]-0-|", options: [], metrics: nil, views: ["headers": self.headersView, "collectionView": self.collectionView])
		NSLayoutConstraint.activate(constraints)
	}
	
	private func addClassicComparatorConstraints() {
		
		self.scrollView.contentSize.width = self.cellWidth * self.chunks.count.toCGFloat()
		self.scrollView.bounces = false
		self.collectionViewFlowLayout.itemSize = CGSize(width: self.cellWidth, height: self.cellHeight)
		self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat:  "H:|[chunksView(==\(self.cellWidth))][scrollView]|", options: [], metrics: nil, views: ["chunksView": self.chunksView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[chunksLabel(==collectionView)]|", options: [], metrics: nil, views: ["chunksLabel": self.chunksView, "collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-[scrollView(==\(self.collectionViewHeight))]-0-|", options: [], metrics: nil, views: ["title" : self.titleView, "scrollView": self.scrollView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView(==\(self.collectionViewWidth))]-0-|", options: [], metrics: nil, views: ["collectionView": self.collectionView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView(==\(self.collectionViewHeight))]-0-|", options: [], metrics: nil, views: ["collectionView": self.collectionView])
		NSLayoutConstraint.activate(constraints)
	}
}

// methods related to collection view and cell rendering
extension ZCRMComparator: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if self.type == .classic {
			return self.chunks.count * (self.groupings.groups.count + 1)
		}
		return self.chunks.count * self.groupings.groups.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let zcrmComparatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "zcrmComparatorCell", for: indexPath) as! ZCRMComparatorCell
		zcrmComparatorCell.type = self.type
		zcrmComparatorCell.options = self.renderOptions
		if self.type == .sport {
			self.renderSportComparatorCell(zcrmComparatorCell, index: indexPath.row)
		} else if self.type == .elegant {
			self.renderElegantComparatorCell(zcrmComparatorCell, index: indexPath.row)
		} else {
			self.renderClassicComparatorCell(zcrmComparatorCell, index: indexPath.row)
		}
		zcrmComparatorCell.render()
		return zcrmComparatorCell
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		if self.type == .classic || self.type == .elegant{
			return 0.0
		}
		return ((self.collectionViewWidth * 0.3) / self.groupings.groups.count.toCGFloat()) / 2
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		if self.type == .classic   {
			return 0.0
		}
		if self.type == .elegant {
			return -0.15
		}
		return ((self.collectionViewHeight * 0.25) / self.chunks.count.toCGFloat()) / 2
	}
	
	private func renderSportComparatorCell(_ cell: ZCRMComparatorCell, index: Int) {
		
		let chunk = self.getChunk(chunkDataIndex: index)
		cell.containerColor = chunk.color
		cell.backgroundColor = collectionView.backgroundColor
		cell.layer.borderWidth = 1
		cell.layer.borderColor = chunk.color.cgColor
		if !self.chunkDatas.isEmpty {
			cell.chunkData = self.chunkDatas[index]
			cell.highValue = self.getMaxOfChunk(index)
		}
	}
	
	private func renderElegantComparatorCell(_ cell: ZCRMComparatorCell, index: Int) {
		
		let chunk = self.getChunk(chunkDataIndex: index)
		cell.objective = chunk.objective
		if (self.getGroupIndex(chunkDataIndex: index) + 1) % 2 != 0 {
			cell.backgroundColor = self.renderOptions.elegantDiffColor
		}
		if !self.chunkDatas.isEmpty {
			cell.chunkData = self.chunkDatas[index]
		}
	}
	
	private func renderClassicComparatorCell(_ cell: ZCRMComparatorCell, index: Int) {
		
		let cellIndex = index - self.chunks.count
		if index < self.chunks.count {
			cell.isHeader = true
			cell.chunkData = ZCRMChunkData(label: self.chunks[index].label, value: 0)
			cell.backgroundColor = self.renderOptions.classicHeaderRowColor
		} else if !self.chunkDatas.isEmpty {
			let chunk = self.getChunk(chunkDataIndex: cellIndex)
			cell.objective = chunk.objective
			cell.chunkData = self.chunkDatas[cellIndex]
		}
		let totalCells = (self.groupings.groups.count + 1) * self.chunks.count
		if index < totalCells - self.chunks.count {
			cell.addBottomBorder(color: .black, width: 1)
		}
	}
}


// methods related to data source
fileprivate extension ZCRMComparator {
	
	func setChunkDatas() {
		
		if self.type == .classic {
			for (groupIndex, group) in self.groupings.groups.enumerated() {
				for (chunkIndex, chunk) in self.chunks.enumerated() {
					self.chunkDatas.append(self.dataSource.comparator(chunk, group, groupIndex: groupIndex, chunkIndex: chunkIndex))
				}
			}
			return
		}
		for (chunkIndex, chunk) in self.chunks.enumerated() {
			for (groupIndex, group) in self.groupings.groups.enumerated() {
				self.chunkDatas.append(self.dataSource.comparator(chunk, group, groupIndex: groupIndex, chunkIndex: chunkIndex))
			}
		}
	}
	
	func getMaxOfChunk(_ indexInArray: Int) -> Int {
		
		let chunksLength = self.groupings.groups.count
		let chunksRange = (indexInArray + 1).toCGFloat() / chunksLength.toCGFloat()
		let chunkIndex = chunksRange.rounded(.up)
		let chunkEndIndex = (chunkIndex * chunksLength.toCGFloat()) - 1
		let chunkStartIndex = (chunkEndIndex - (chunksLength - 1).toCGFloat())
		var chunkValues: [Int] = []
		for index in chunkStartIndex.toInt()...chunkEndIndex.toInt() {
			chunkValues.append(self.chunkDatas[index].value)
		}
		if chunkValues.isEmpty {
			return 0
		}
		return chunkValues.max()!
	}
	
	func getChunk(chunkDataIndex: Int) -> ZCRMComparatorChunk {
		
		let chunksLength = self.groupings.groups.count
		let chunksRange = chunkDataIndex / chunksLength
		return self.chunks[chunksRange.toCGFloat().rounded(.down).toInt()]
	}
	
	func getGroupIndex(chunkDataIndex: Int) -> Int {
		
		let chunkDataRange = self.groupings.groups.count
		return chunkDataIndex % chunkDataRange
	}
}
