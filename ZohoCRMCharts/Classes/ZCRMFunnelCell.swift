//
//  ZCRMFunnelCell.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 26/11/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

internal final class ZCRMPathFunnelCell: UIView {
	
	internal var data: ZCRMFunnelData! {
		didSet {
			if data != nil {
				self.setData()
			}
		}
	}
	private let isStart: Bool
	private let bgColor: UIColor
	private let cellLabel: UILabel = UILabel()
	private let valueLabel: UILabel = UILabel()
	
	init(isStart: Bool, bgColor: UIColor) {
		self.isStart = isStart
		self.bgColor = bgColor
		super.init(frame: .zero)
		self.render()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		self.addConstraints()
	}
	
	private func render() {
		
		let font = UIFont.systemFont(ofSize: 13)
		self.cellLabel.translatesAutoresizingMaskIntoConstraints = false
		self.cellLabel.textAlignment = .center
		self.cellLabel.font = font
		self.addSubview(cellLabel)
		
		self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
		self.valueLabel.textAlignment = .center
		self.valueLabel.font = font
		self.addSubview(valueLabel)
	}
	
	private func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cellLabel]-0-|", options: [], metrics: nil, views: ["cellLabel": self.cellLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[valueLabel]-0-|", options: [], metrics: nil, views: ["valueLabel": self.valueLabel])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[cellLabel(>=cellLabelWidth)]-2-[valueLabel]-|", options: [], metrics: ["cellLabelWidth": self.getWidthOf(percent: 65)], views: ["cellLabel": self.cellLabel, "valueLabel": self.valueLabel])
		NSLayoutConstraint.activate(constraints)
	}
	
	override func draw(_ rect: CGRect) {
		
		let bezeirPath = UIBezierPath()
		let traingleH = self.frame.height / 3
		let radius = self.frame.height / 2
		if self.isStart {
			bezeirPath.move(to: CGPoint(x: radius, y: 0))
			let arcCenter = CGPoint(x: traingleH + (radius / 2), y: radius)
			bezeirPath.addArc(withCenter: arcCenter, radius: radius, startAngle: CGFloat(270).toRadians(), endAngle: CGFloat(90).toRadians(), clockwise: false)
		} else {
			bezeirPath.move(to: CGPoint(x: 0, y: 0))
			bezeirPath.addLine(to: CGPoint(x: traingleH, y: self.frame.height / 2))
			bezeirPath.addLine(to: CGPoint(x: 0, y: self.frame.height))
		}
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
}

internal final class ZCRMCompactFunnelCell: UIView {
	
	internal var data: ZCRMFunnelData! {
		didSet {
			if data != nil {
				self.setData()
			}
		}
	}
	private let isRateView: Bool
	private let cellLabel: UILabel = UILabel()
	private let valueLabel: UILabel = UILabel()
	private let bezeirPath = UIBezierPath()
	
	init(isRateView: Bool) {
		self.isRateView = isRateView
		super.init(frame: .zero)
		self.render()
	}
	
	override func layoutSubviews() {
		self.addConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func render() {
		
		self.cellLabel.translatesAutoresizingMaskIntoConstraints = false
		self.cellLabel.font = UIFont.systemFont(ofSize: 17)
		self.cellLabel.textAlignment = .center
		self.addSubview(self.cellLabel)
		
		if !self.isRateView {
			
			self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
			self.valueLabel.textAlignment = .center
			self.valueLabel.font = UIFont.systemFont(ofSize: 13)
			self.addSubview(valueLabel)
		}
	}
	
	private func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		
		if self.isRateView {
			
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cellLabel]-0-|", options: [], metrics: nil, views: ["cellLabel": self.cellLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[cellLabel(cellWidth)]", options: [], metrics: ["cellWidth": self.frame.width * 0.7], views: ["cellLabel": self.cellLabel])

		} else {
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[cellLabel]-|", options: [], metrics: nil, views: ["cellLabel": self.cellLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[valueLabel]-|", options: [], metrics: nil, views: ["valueLabel": self.valueLabel])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cellLabel(cellLabelHeight)]-0-[valueLabel(valueLabelHeight)]", options: [], metrics: ["cellLabelHeight": self.getHeightOf(percent: 65), "valueLabelHeight": self.getHeightOf(percent: 35)], views: ["cellLabel": self.cellLabel, "valueLabel": self.valueLabel])
		}
		NSLayoutConstraint.activate(constraints)
	}
	
	override func draw(_ rect: CGRect) {
	
		if self.isRateView {
			self.draw()
		} else {
			super.draw(rect)
		}
	}
	
	private func draw() {
		
		let traingleH = self.frame.width / 3
		self.bezeirPath.move(to: CGPoint(x: 0, y: 0))
		self.bezeirPath.addLine(to: CGPoint(x: 0, y: self.frame.height))
		self.bezeirPath.addLine(to: CGPoint(x: self.frame.width - traingleH, y: self.frame.height))
		self.bezeirPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height / 2))
		self.bezeirPath.addLine(to: CGPoint(x: self.frame.width - traingleH, y: 0))
		self.backgroundColor?.setFill()
		self.bezeirPath.fill()
		self.backgroundColor?.setStroke()
		self.bezeirPath.stroke()
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = self.bezeirPath.cgPath
		self.layer.mask = shapeLayer
	}
	
	private func setData() {
		
		if self.isRateView {
			self.cellLabel.text = self.data.label
		} else {
			self.valueLabel.text = self.data.label
			self.cellLabel.text = String(self.data.value)
		}
	}
}

internal final class ZCRMClassicFunnelFooter: UICollectionViewCell {
	
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
	
	override func layoutSubviews() {
		self.addConstraints()
	}
	
	internal func render() {
		
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.label.textAlignment = .center
		self.label.font = UIFont.systemFont(ofSize: 11)
		self.addSubview(self.label)
		
		self.roundedView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.roundedView)
	}
	
	private func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		self.roundedView.layer.cornerRadius = self.getHeightOf(percent: 60) / 2
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[round(roundWidth)][label]|", options: [], metrics: ["roundWidth": self.getHeightOf(percent: 60)], views: ["round": self.roundedView, "label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[round(roundHeight)]", options: [], metrics: ["roundHeight": self.getHeightOf(percent: 60)], views: ["round": self.roundedView])
		constraints.append(NSLayoutConstraint(item: self.roundedView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		NSLayoutConstraint.activate(constraints)
	}
}


internal final class ZCRMSegmentFunnelCell: UICollectionViewCell {
	
	internal var text: String! {
		didSet {
			if text != nil {
				self.label.text = text
			}
		}
	}
	internal var options: FunnelRenderOptions = FunnelRenderOptions()
	internal var isHeader: Bool = false
	private let label: UILabel = UILabel()
	
	internal func render() {
		
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.label.textAlignment = .center
		self.label.numberOfLines = 2
		self.label.font = UIFont.systemFont(ofSize: 11)
		self.addSubview(self.label)
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": self.label])
		NSLayoutConstraint.activate(constraints)
	}
}
