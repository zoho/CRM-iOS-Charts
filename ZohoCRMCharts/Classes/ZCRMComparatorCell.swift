//
//  ZCRMComparatorCell.swift
//  Pods-ZohoCRMChartsTest
//
//  Created by Sarath Kumar Rajendran on 12/11/18.
//

import UIKit

internal class ZCRMComparatorCell: UICollectionViewCell {
	
	internal var type: ZCRMCharts.ZCRMComparatorComponent!
	internal var options: ComparatorRenderOptions = ComparatorRenderOptions()
	internal var objective: ZCRMCharts.Outcome = .neutral
	internal var isHeader: Bool = false
	private let label: UILabel = UILabel()
	private let container: UIView = UIView()
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
		
		self.addConstraints()
	}
	
	func render() {
		
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
			self.addElegantConstraints()
		}
	}
	
	private func addSportConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[label]-0-|", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[container]-0-|", options: [], metrics: nil, views: ["container": self.container])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label(==\(self.frame.height / 3))]", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[container(==\(self.getBarLength()))]-0-|", options: [], metrics: nil, views: ["label": self.label, "container": self.container])
		NSLayoutConstraint.activate(constraints)
	}
	
	private func addElegantConstraints() {
		
		var constraints: [NSLayoutConstraint] = []
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: ["label": self.label])
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label]-0-|", options: [], metrics: nil, views: ["label": self.label])
		NSLayoutConstraint.activate(constraints)
	}
	
	private func getBarLength() -> CGFloat {
		
		let availableHeight = self.frame.height - (self.frame.height / 3)
		if highValue == nil {
			return availableHeight
		}
		let onePercent = availableHeight / 100
		let percentOfDiff = (self.chunkData.value * 100) / self.highValue
		return percentOfDiff.toCGFloat() * onePercent
	}
	
	private func setData() {
		
		if self.type == .sport {
			self.label.text = self.chunkData.label
		} else if self.type == .elegant || self.type == .classic {
			self.label.attributedText = ZCRMComparatorUIUtil.getTextForChunkData(self.chunkData, options: self.options, objective: self.objective, isHeader: self.isHeader)
		}
	}
	
}

internal class ZCRMComparatorHeader: UIView {
	
	private let imageView: UIImageView = UIImageView()
	private let label: UILabel = UILabel()
	internal var alignVertical: Bool!
	internal var options: ComparatorRenderOptions = ComparatorRenderOptions()
	private var isAvatarNeeded: Bool
	private var type: ZCRMCharts.ZCRMComparatorComponent
	
	internal var group: ZCRMComparatorGroup! {
		didSet {
			self.setData()
		}
	}
	
	init(type: ZCRMCharts.ZCRMComparatorComponent, _ isAvatarNeeded: Bool) {
		self.type = type
		self.isAvatarNeeded = isAvatarNeeded
		super.init(frame: .zero)
		self.render()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		self.addConstraints()
	}
	
	func render() {
		
		self.clipsToBounds = true
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.label.textAlignment = .center
		self.addSubview(self.label)
		if self.isAvatarNeeded {
			self.imageView.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(self.imageView)
			self.imageView.backgroundColor = .red
		}
		self.setUIOptions()
	}
	
	func setUIOptions() {
		
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
		constraints.append(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
		
		if self.isAvatarNeeded {
			
			self.imageView.backgroundColor = .red
			constraints.append(NSLayoutConstraint(item: self.imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
			
			if self.alignVertical {
				
				self.label.transform = CGAffineTransform(rotationAngle: -1.5708)
				self.imageView.layer.cornerRadius = self.getHeightOf(percent: 25) / 2
				
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label]-2-[image(==\(self.getHeightOf(percent: 25)))]-|", options: [], metrics: nil, views: ["label": self.label, "image": self.imageView])
				constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "H:[image(==\(self.getHeightOf(percent: 25)))]", options: [ ], metrics: nil, views: ["image": self.imageView])
			} else {
				
				self.imageView.layer.cornerRadius = self.getHeightOf(percent: 40) / 2
				
				constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(self.getHeightOf(percent: 10))-[image(==\(self.getHeightOf(percent: 40)))]-[label]-|", options: [], metrics: nil, views: ["image": self.imageView, "label": self.label])
				constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "H:[image(==\(self.getHeightOf(percent: 40)))]", options: [ ], metrics: nil, views: ["image": self.imageView])
			}
		} else {
			self.label.transform = CGAffineTransform(rotationAngle: -1.5708)
			constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: [], metrics: nil, views: ["label": self.label])
		}
		NSLayoutConstraint.activate(constraints)
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
		NSLayoutConstraint.activate(constraints)
	}
	
	private func setData() {
		
		self.label.text = self.group.label
		if self.isAvatarNeeded {
			if self.group.image != nil {
				self.imageView.image = self.group.image
			}
		}
	}
}

internal class ZCRMComparatorChunkView: UIView {
	
	var options: ComparatorRenderOptions = ComparatorRenderOptions()
	var addBottomBorder: Bool = false
	let label: UILabel = UILabel()
	
	init() {
		
		super.init(frame: .zero)
		self.render()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		
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
		var constraints: [NSLayoutConstraint] = []
		constraints +=  NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [ ], metrics: nil, views: ["label": self.label])
		constraints.append(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
		NSLayoutConstraint.activate(constraints)
		self.setUIOptions()
	}
	
	func setUIOptions() {
		
		self.label.font = options.chunkFont
		self.label.textColor = options.chunkFontColor
	}
}
