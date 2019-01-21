//
//  ZCRMFunnelCell.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 26/11/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

internal struct ZCRMFunnelCellData {
	
	internal let label: String
	internal let value: String
}

internal final class ZCRMPathFunnelCell: ZCRMView {
	
	internal var data: ZCRMFunnelData! {
		didSet {
			if data != nil {
				self.setData()
			}
		}
	}
	internal var options: FunnelRenderOptions = FunnelRenderOptions()
	private let isStart: Bool
	private let bgColor: UIColor
	private let cellLabel: UILabel = UILabel()
	private let valueLabel: UILabel = UILabel()
	
	init(isStart: Bool, bgColor: UIColor) {
		self.isStart = isStart
		self.bgColor = bgColor
		super.init(frame: .zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	internal override func addSubviews() {
		
		self.cellLabel.translatesAutoresizingMaskIntoConstraints = false
		self.cellLabel.textAlignment = .center
		self.addSubview(cellLabel)
		
		self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
		self.valueLabel.textAlignment = .left
		self.addSubview(valueLabel)
		self.setUIOptions()
	}
	
	internal override func willAddConstraints() {
		self.setNeedsDisplay()
	}
	
	internal override func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[cellLabel(cellLableHeight)]-2-[valueLabel]-|", options: [], metrics: ["cellLableHeight": self.frame.height * 0.4], views: ["cellLabel": self.cellLabel, "valueLabel": self.valueLabel])
		constraints.append(NSLayoutConstraint(item: self.cellLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
		constraints.append(NSLayoutConstraint(item: self.valueLabel, attribute: .leading, relatedBy: .equal, toItem: self.cellLabel, attribute: .leading, multiplier: 1, constant: 0))
		self.activate(constraints: constraints)
	}
	
	override func draw(_ rect: CGRect) {
		
		self.layer.mask = nil
		let bezeirPath = UIBezierPath()
		let traingleH = self.frame.height / 3
		bezeirPath.move(to: CGPoint(x: 0, y: 0))
		if !self.isStart {
			bezeirPath.addLine(to: CGPoint(x: traingleH, y: self.frame.height / 2))
		}
		bezeirPath.addLine(to: CGPoint(x: 0, y: self.frame.height))
		bezeirPath.addLine(to: CGPoint(x: self.frame.width - traingleH, y: self.frame.height))
		bezeirPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height / 2))
		bezeirPath.addLine(to: CGPoint(x: self.frame.width - traingleH, y: 0))
		bezeirPath.close()
		self.bgColor.setFill()
		bezeirPath.fill()
		self.bgColor.setStroke()
		bezeirPath.stroke()
		self.backgroundColor = self.bgColor
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = bezeirPath.cgPath
		self.layer.mask = shapeLayer
	}
	
	private func setData() {
		
		self.cellLabel.text = self.data.label
		self.valueLabel.text = String(self.data.value)
	}
	
	internal func setUIOptions() {
		
		self.cellLabel.font = self.options.stageFont
		self.cellLabel.textColor = self.options.stageFontColor
		self.valueLabel.font = self.options.valueFont
		self.valueLabel.textColor = self.options.valueFontColor
	}
}

internal final class ZCRMCompactFunnelCell: ZCRMView {
	
	internal var data: ZCRMFunnelCellData! {
		didSet {
			if data != nil {
				self.setData()
			}
		}
	}
	internal var options: FunnelRenderOptions = FunnelRenderOptions()
	private let isRateView: Bool
	private let cellLabel: UILabel = UILabel()
	private let stageLabel: UILabel = UILabel()
	
	init(isRateView: Bool) {
		self.isRateView = isRateView
		super.init(frame: .zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	internal override func addSubviews() {
		
		self.cellLabel.translatesAutoresizingMaskIntoConstraints = false
		self.cellLabel.textAlignment = .center
		self.addSubview(self.cellLabel)
		
		if !self.isRateView {
			
			self.stageLabel.translatesAutoresizingMaskIntoConstraints = false
			self.stageLabel.textAlignment = .center
			self.addSubview(stageLabel)
		}
		self.setUIOptions()
	}
	
	internal override func willAddConstraints() {
		self.setNeedsDisplay()
	}
	
	internal override func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		if self.isRateView {
			
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cellLabel]-0-|", options: [], metrics: nil, views: ["cellLabel": self.cellLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[cellLabel(cellWidth)]", options: [], metrics: ["cellWidth": self.frame.width * 0.7], views: ["cellLabel": self.cellLabel])
		} else {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[cellLabel]-|", options: [], metrics: nil, views: ["cellLabel": self.cellLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[valueLabel]-|", options: [], metrics: nil, views: ["valueLabel": self.stageLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cellLabel(cellLabelHeight)]-0-[valueLabel(valueLabelHeight)]", options: [], metrics: ["cellLabelHeight": self.getHeightOf(percent: 65), "valueLabelHeight": self.getHeightOf(percent: 35)], views: ["cellLabel": self.cellLabel, "valueLabel": self.stageLabel])
		}
		self.activate(constraints: constraints)
	}
	
	override func draw(_ rect: CGRect) {
	
		if self.isRateView {
			self.draw()
		} else {
			super.draw(rect)
		}
	}
	
	private func draw() {
		
		self.layer.mask = nil
		let traingleH = self.frame.width / 3
		let bezeirPath = UIBezierPath()
		let shapeLayer = CAShapeLayer()
		bezeirPath.move(to: CGPoint(x: 0, y: 0))
		bezeirPath.addLine(to: CGPoint(x: 0, y: self.frame.height))
		bezeirPath.addLine(to: CGPoint(x: self.frame.width - traingleH, y: self.frame.height))
		bezeirPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height / 2))
		bezeirPath.addLine(to: CGPoint(x: self.frame.width - traingleH, y: 0))
		bezeirPath.close()
		self.backgroundColor?.setFill()
		bezeirPath.fill()
		self.backgroundColor?.setStroke()
		bezeirPath.stroke()
		shapeLayer.path = bezeirPath.cgPath
		self.layer.mask = shapeLayer
	}
	
	private func setData() {
		
		if self.isRateView {
			self.cellLabel.text = self.data.label
		} else {
			self.stageLabel.text = self.data.label
			self.cellLabel.text = self.data.value
		}
	}
	
	internal func setUIOptions() {
		
		if self.isRateView {
			self.cellLabel.font = self.options.rateFont
			self.cellLabel.textColor = self.options.rateFontColor
		} else {
			
			self.stageLabel.font = self.options.stageFont
			self.stageLabel.textColor = self.options.stageFontColor
			self.cellLabel.font = self.options.valueFont
			self.cellLabel.textColor = self.options.valueFontColor
		}
	}
}

internal final class ZCRMClassicFunnelFooter: ZCRMCollectionViewCell {

	internal var text: String! {
		didSet {
			if text != nil {
				self.label.text = text
			}
		}
	}
	
	internal var color: UIColor! {
		didSet {
			if color != nil {
				self.roundedView.backgroundColor = color
			}
		}
	}
	
	internal var options: FunnelRenderOptions = FunnelRenderOptions()
	private let label: UILabel = UILabel()
	private let roundedView: UIView = UIView()
		
	internal override func addSubviews() {
		
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.label.textAlignment = .center
		self.label.font = self.options.stageFont
		self.label.textColor = self.options.stageFontColor
		self.addSubview(self.label)
		
		self.roundedView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.roundedView)
	}
	
	internal override func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		self.roundedView.layer.cornerRadius = self.getHeightOf(percent: 60) / 2
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[round(roundWidth)]-2-[label]|", options: [], metrics: ["roundWidth": self.getHeightOf(percent: 60)], views: ["round": self.roundedView, "label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[round(roundHeight)]", options: [], metrics: ["roundHeight": self.getHeightOf(percent: 60)], views: ["round": self.roundedView])
		constraints.append(NSLayoutConstraint(item: self.roundedView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		self.activate(constraints: constraints)
	}
}

internal final class ZCRMSegmentFunnelCell: ZCRMCollectionViewCell {
	
	internal var text: String! {
		didSet {
			if text != nil {
				self.label.text = text
			}
		}
	}
	
	internal var font: UIFont! {
		didSet {
			if font != nil {
				self.label.font = font
			}
		}
	}
	
	internal var fontColor: UIColor! {
		didSet {
			if fontColor != nil {
				self.label.textColor = fontColor
			}
		}
	}
	
	private let label: UILabel = UILabel()
	
	internal override func addSubviews() {
		
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.label.textAlignment = .center
		self.label.numberOfLines = 2
		self.addSubview(self.label)
	}
	
	internal override func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": self.label])
		NSLayoutConstraint.activate(constraints)
	}
}

internal final class ZCRMStandardFunnelConversionRateView: ZCRMView {
	
	internal let fromValueLabel: UILabel = UILabel()
	internal let toValueLabel: UILabel = UILabel()
	internal let rateLabel: UILabel = UILabel()
	internal var font: UIFont = UIFont.systemFont(ofSize: 14)
	internal var fontColor: UIColor = .black
	private let conversionRateView: UILabel = UILabel()
	
	internal init() {
		super.init(frame: .zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	internal override func willAddSubviews() {
		
		self.fromValueLabel.translatesAutoresizingMaskIntoConstraints = false
		self.fromValueLabel.textAlignment = .center
		
		self.toValueLabel.translatesAutoresizingMaskIntoConstraints = false
		self.toValueLabel.textAlignment = .center
		
		self.rateLabel.translatesAutoresizingMaskIntoConstraints = false
		self.rateLabel.numberOfLines = 2
		self.rateLabel.textAlignment = .center
		
		self.conversionRateView.translatesAutoresizingMaskIntoConstraints = false
		self.conversionRateView.numberOfLines = 2
		self.conversionRateView.textAlignment = .center
		self.conversionRateView.text = "Conversion Rate"
		self.conversionRateView.adjustsFontSizeToFitWidth = true
		self.conversionRateView.minimumScaleFactor = 0.75
	}
	
	internal override func addSubviews() {
		
		self.addSubview(self.fromValueLabel)
		self.addSubview(self.toValueLabel)
		self.addSubview(self.rateLabel)
		self.addSubview(self.conversionRateView)
	}
	
	internal override func didAddConstraints() {
		self.drawLines()
	}
	
	internal override func addConstraints() {
		
		if self.frame.height == 0 {
			return
		}
		let lHeight = self.frame.height * 0.15
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[fromValue]|", options: [], metrics: nil, views: ["fromValue": self.fromValueLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[rate]|", options: [], metrics: nil, views: ["rate": self.rateLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[toValue]|", options: [], metrics: nil, views: ["toValue": self.toValueLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[conversionRateView]-4-|", options: [], metrics: nil, views: ["conversionRateView": self.conversionRateView])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[fromValue(==lHeight)]", options: [], metrics:  ["lHeight": lHeight], views: ["fromValue": self.fromValueLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[toValue(==lHeight)]|", options: [], metrics:  ["lHeight": lHeight], views: ["toValue": self.toValueLabel, "fromValue": self.fromValueLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[rate(==lHeight)][conversionRateView(==lHeight)]", options: [], metrics:  ["lHeight": lHeight], views: ["rate": self.rateLabel, "conversionRateView": self.conversionRateView])
		constraints.append(NSLayoutConstraint(item: self.rateLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		constraints.append(NSLayoutConstraint(item: self.conversionRateView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		self.activate(constraints: constraints)
		self.conversionRateView.layoutIfNeeded()
	}
	
	private func drawLines() {
		
		self.layer.sublayers?.forEach({ (layer) in
			if layer is CAShapeLayer {
				layer.removeFromSuperlayer()
			}
		})
		let xPos: CGFloat  = self.frame.width / 2
		let labelHeight: CGFloat = self.frame.height * 0.125
		let lineHeight = self.frame.height * 0.225
		let linesInfo = [ (y1: labelHeight, y2: labelHeight + lineHeight),
						  (y1: self.frame.height - ( labelHeight + lineHeight), y2: self.frame.height - labelHeight)]
		
		for line in linesInfo {
			let path = UIBezierPath()
			path.move(to: CGPoint(x: xPos, y: line.y1))
			path.addLine(to: CGPoint(x: xPos, y: line.y2))
			let layer = CAShapeLayer()
			layer.path = path.cgPath
			layer.lineWidth = 2.0
			layer.strokeColor = self.fontColor.cgColor
			self.layer.insertSublayer(layer, at: 0)
		}
	}
	
	func setUIOptions() {
		
		self.fromValueLabel.font = self.font
		self.toValueLabel.font = self.font
		self.rateLabel.font = self.font
		self.conversionRateView.font = self.font
		self.fromValueLabel.textColor = self.fontColor
		self.toValueLabel.textColor = self.fontColor
		self.rateLabel.textColor = self.fontColor
		self.conversionRateView.textColor = self.fontColor
		self.drawLines()
	}
}
