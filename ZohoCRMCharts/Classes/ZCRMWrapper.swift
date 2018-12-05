//
//  ZCRMWrapper.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import UIKit


public struct ZCRMCharts {
	
	public enum ZCRMKPIType: String {
		
		case standard
		case growthIndex
		case basic
		case scorecard
		case rankings
	}
	
	public enum ZCRMComparatorType: String {
		
		case elegant
		case sport
		case classic
	}
	
	public enum ZCRMFunnelType: String {
		
		case standard
		case path
		case segment
		case compact
		case classic
	}

	public enum Outcome {
		
		case positive
		case negative
		case neutral
	}
}

/**
	Data object for KPI components of all types.
*/
public struct ZCRMKPIRow {
	
	internal var value: String!
	internal var label: String!
	internal var rate: String!
	internal var objective: ZCRMCharts.Outcome!
	public var comparedToLabel: String!
	public var comparedToValue: String!
	
	/**
	For KPI of type Basic.
	- parameters:
		- value: The value of the basic kpi component.
	*/
	public init(value: String){
		self.value = value
	}
	
	/**
	For KPI of type Standard/Growth Index.
	- parameters:
		- value: value of the standard/growth index kpi component.
		- rate: rate differed from the compared one.
		- objective: objective of the kpi.
	*/
	public init(value: String, rate: String, objective: ZCRMCharts.Outcome) {
		self.value = value
		self.rate = rate
		self.objective = objective
	}
	
	/**
	For KPI of type Scorecard.
	- parameters:
		- label: label for the kpi row data.
		- value: value for the kpi row.
		- rate: rate of growth outcome.
		- status: it is a increment/decrement/neutral.
	*/
	public init(label: String, value: String, rate: String, objective: ZCRMCharts.Outcome){
		self.label = label
		self.value = value;
		self.rate = rate
		self.objective = objective
	}
	
	/**
	For KPI of type Rankings.
	- parameters:
		- label: label for the kpi row data.
		- value: value for the kpi row.
	*/
	public init(label: String, value: String) {
		self.label = label
		self.value = value;
	}
	
}

public struct ZCRMChunkData {
	
	internal let label: String
	internal let value: Int
	internal var rate: String!
	
	public init(label: String, value: Int) {
		self.label = label
		self.value = value
	}
	
	public init(label: String, value: Int, rate: String) {
		self.label = label
		self.value = value
		self.rate = rate
	}
}

public struct ZCRMComparatorGroup {
	
	internal let label: String
	internal let value: String
	internal var image: UIImage!
	
	public init(label: String, value: String) {
		self.label = label
		self.value = value
	}
	
	public init(label: String, value: String, image: UIImage) {
		self.label = label
		self.value = value
		self.image = image
	}
	
}

public struct ZCRMComparatorGroupings {
	
	internal let groups: [ZCRMComparatorGroup]
	internal let isAvatarNeeded: Bool
	internal var label: String!
	
	public init(groups: [ZCRMComparatorGroup], isAvatarNeeded: Bool) {
		self.isAvatarNeeded = isAvatarNeeded
		self.groups = groups
	}
	
	public init(groups: [ZCRMComparatorGroup], isAvatarNeeded: Bool, label: String) {
		self.isAvatarNeeded = isAvatarNeeded
		self.groups = groups
		self.label = label
	}
	
}

public struct ZCRMComparatorChunk {
	
	internal let label: String
	internal var color: UIColor = .green
	internal var objective: ZCRMCharts.Outcome!
	
	public init(label: String) {
		self.label = label
	}
	
	public init(label: String, objective: ZCRMCharts.Outcome) {
		self.label = label
		self.objective = objective
	}
	
	public init(label: String, color: UIColor) {
		self.label = label
		self.color = color
	}
}

public protocol ZCRMComparatorDataSource: class {
	
	func comparator(_ chunk: ZCRMComparatorChunk, _ group: ZCRMComparatorGroup, groupIndex: Int, chunkIndex: Int) -> ZCRMChunkData
}



public struct ZCRMFunnelStage{

	public let label: String
	public private(set) var color: UIColor!

	public init(label: String) {
		self.label = label
		self.color = UIColor.yellow
	}

	public init(label: String, color: UIColor) {
		self.label = label
		self.color = color
	}
	
}

public struct ZCRMFunnelSegment{

	public let label: String

	public init(label: String) {
		self.label = label
	}
}

public struct ZCRMFunnelData{

	internal let label: String
	internal let value: Int

	public init(label: String, value: Int) {
		self.label = label
		self.value = value
	}
}

public protocol ZCRMFunnelDataSource: class {

	func rateFor(_ fromStage: ZCRMFunnelStage, _ toStage: ZCRMFunnelStage, fromStageIndex: Int, toStageIndex: Int, segment: ZCRMFunnelSegment?) -> ZCRMFunnelData

	func funnel(_ stage: ZCRMFunnelStage, segment: ZCRMFunnelSegment?) -> ZCRMFunnelData

	func conversionRateFor(_ funnel: ZCRMFunnel, _ segment: ZCRMFunnelSegment?) -> ZCRMFunnelData
}


