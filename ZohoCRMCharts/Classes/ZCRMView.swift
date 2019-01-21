//
//  ZCRMView.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit

public class ZCRMView: UIView, ZCRMLayoutConstraintDelegate {

	internal var viewConstraints: [NSLayoutConstraint] = []
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.`init`()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.`init`()
	}
	
	public override func layoutSubviews() {
		self.deactivateConstraints()
		self.willAddConstraints()
		self.addConstraints()
		self.didAddConstraints()
	}
	
	private func `init`() {
		self.willAddSubviews()
		self.addSubviews()
	}
	
	internal func willAddSubviews() {}
	
	internal func addSubviews() {}
	
	internal func willAddConstraints() {}
	
	internal func addConstraints() {}
	
	internal func didAddConstraints() {}
}


public class ZCRMCollectionViewCell: UICollectionViewCell, ZCRMLayoutConstraintDelegate {
	
	internal var viewConstraints: [NSLayoutConstraint] = []
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.`init`()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.`init`()
	}
	
	private func `init`() {
		self.willAddSubviews()
		self.addSubviews()
	}
	
	public override func layoutSubviews() {
		self.deactivateConstraints()
		self.willAddConstraints()
		self.addConstraints()
		self.didAddConstraints()
	}
	
	public func willAddSubviews() {}
	
	public func addSubviews() {}
	
	public func willAddConstraints() {}
	
	public func addConstraints() {}
	
	public func didAddConstraints() {}
}
