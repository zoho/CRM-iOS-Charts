//
//  ZCRMComparatorCell.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 12/11/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

internal final class ZCRMComparatorCell: UICollectionViewCell, ZCRMLayoutConstrainDelegate {
	
	internal var type: ZCRMCharts.ZCRMComparatorType!
	internal var options: ComparatorRenderOptions = ComparatorRenderOptions()
	internal var isHeader: Bool = false
	private let label: UILabel = UILabel()
	private let container: UIView = UIView()
	internal var viewConstraints: [NSLayoutConstraint] = []
	internal var chunkData: ZCRMChunkData! {
		didSet {
			if chunkData != nil {
				self.setData()
			} 
		}
	}
	internal var highValue: Int!
	internal var containerColor: UIColor! {
		didSet {
			if containerColor != nil && self.type == .sport {
				self.container.backgroundColor = containerColor
			}
		}
	}
	
	override func layoutSubviews() {
		
		self.deactivateConstraints()
		self.addConstraints()
	}
	
	internal func render() {
		
		self.clipsToBounds = true
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.label.textAlignment = .center
		self.addSubview(self.label)
		if self.type == .sport {
			self.layer.borderWidth = 1
			self.container.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(self.container)
		}
	}
	
	private func addConstraints() {
		
		if self.type == .sport {
			self.addSportConstraints()
		} else if self.type == .elegant || self.type == .classic{
			self.addElegantOrClassicConstraints()
		}
	}
	
	private func addSportConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[label]-0-|", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[container]-0-|", options: [], metrics: nil, views: ["container": self.container])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label(==\(self.frame.height / 3))]", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[container(==\(self.getBarLength()))]-0-|", options: [], metrics: nil, views: ["label": self.label, "container": self.container])
		self.activate(constraints: constraints)
	}
	
	private func addElegantOrClassicConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label]-0-|", options: [], metrics: nil, views: ["label": self.label])
		self.activate(constraints: constraints)
	}
	
	private func getBarLength() -> CGFloat {
		
		let availableHeight: CGFloat = self.frame.height - (self.frame.height / 3)
		if highValue == nil || self.highValue == 0 {
			return 0
		}
		let onePercent: CGFloat = availableHeight / 100
		let percentOfDiff: Int = (self.chunkData.value * 100) / self.highValue
		return percentOfDiff.toCGFloat() * onePercent
	}
	
	private func setData() {
		self.label.attributedText = ZCRMComparatorUIUtil.getTextForChunkData(self.chunkData, options: self.options, isHeader: self.isHeader)
	}
}

internal final class ZCRMComparatorHeader: UIView, ZCRMLayoutConstrainDelegate {
	
	private let imageView: UIImageView = UIImageView()
	private let label: UILabel = UILabel()
	internal var alignVertical: Bool = false
	internal var options: ComparatorRenderOptions = ComparatorRenderOptions()
	private var isAvatarNeeded: Bool
	private var type: ZCRMCharts.ZCRMComparatorType
	private var didSetConstraints: Bool = false
	internal var viewConstraints: [NSLayoutConstraint] = []
	
	internal var group: ZCRMComparatorGroup! {
		didSet {
			if group != nil {
				self.setData()
			}
		}
	}
	
	init(type: ZCRMCharts.ZCRMComparatorType, _ isAvatarNeeded: Bool) {
		self.type = type
		self.isAvatarNeeded = isAvatarNeeded
		super.init(frame: .zero)
		self.render()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		self.deactivateConstraints()
		self.addConstraints()
	}
	
	internal func render() {
		
		self.clipsToBounds = true
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.label.textAlignment = .center
		self.addSubview(self.label)
		if self.isAvatarNeeded {
			self.imageView.translatesAutoresizingMaskIntoConstraints = false
			self.imageView.clipsToBounds = true
			self.addSubview(self.imageView)
		}
		self.setUIOptions()
	}
	
	internal func setUIOptions() {
		
		self.label.font = options.groupFont
		self.label.textColor = options.groupFontColor
	}
	private func addConstraints() {
		
		if self.type == .sport {
			self.addSportHeaderConstraints()
		} else if self.type == .elegant {
			self.addElegantHeaderConstraints()
		}
	}
	
	private func addSportHeaderConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
	
		constraints.append(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
		
		if self.isAvatarNeeded {
			
			self.imageView.layer.cornerRadius = self.getHeightOf(percent: 40) / 2
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[image(==\(self.getHeightOf(percent: 40)))]", options: [], metrics: nil, views: ["image": self.imageView])
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": self.label])
			constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "H:|[image(==\(self.getHeightOf(percent: 40)))]-[label]|", options: [ ], metrics: nil, views: ["image": self.imageView, "label": self.label])
			constraints.append(NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
			
		} else {
			constraints.append(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
		}
		self.activate(constraints: constraints)
	}
	
	private func addElegantHeaderConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		if self.isAvatarNeeded {
			
			let imageViewRadius =  self.getWidthOf(percent: 20)
			let horizontalSpacing = self.getWidthOf(percent: 10)
			self.imageView.layer.cornerRadius = imageViewRadius / 2
			
			constraints.append(NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
			constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(horizontalSpacing)-[image(==\(imageViewRadius))]-3-[label]-\(horizontalSpacing)-|", options: [ ], metrics: nil, views: ["image": self.imageView, "label": self.label])
			constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "V:[image(==\(imageViewRadius))]", options: [], metrics: nil, views: ["image": self.imageView])
		} else {
			constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [ ], metrics: nil, views: ["label": self.label])
		}
		constraints.append(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
		self.activate(constraints: constraints)
	}
	
	private func setData() {
		
		self.label.text = self.group.label
		if self.isAvatarNeeded {
			if self.group.image != nil {
				self.imageView.backgroundColor = .clear
				self.imageView.image = self.group.image
			} else {
				self.imageView.backgroundColor = self.group.avatarBgColor
			}
		}
	}
}

internal final class ZCRMComparatorChunkView: UIView, ZCRMLayoutConstrainDelegate {
	
	internal var options: ComparatorRenderOptions = ComparatorRenderOptions()
	internal var addBottomBorder: Bool = false
	internal let label: UILabel = UILabel()
	internal var viewConstraints: [NSLayoutConstraint] = []
	init() {
		super.init(frame: .zero)
		self.render()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		
		self.deactivateConstraints()
		self.addConstraints()
		if self.addBottomBorder {
			self.addBottomBorder(color: .black, width: 1)
		}
	}
	
	private func render() {
		
		self.clipsToBounds = true
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.label.textAlignment = .center
		self.label.numberOfLines = 2
		self.addSubview(self.label)
		self.setUIOptions()
	}
	
	private func addConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [ ], metrics: nil, views: ["label": self.label])
		constraints.append(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
		self.activate(constraints: constraints)
	}
	
	internal func setUIOptions() {
		
		self.label.font = options.chunkFont
		self.label.textColor = options.chunkFontColor
	}
}
