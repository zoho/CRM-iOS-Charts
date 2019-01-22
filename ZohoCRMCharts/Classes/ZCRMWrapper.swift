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
	
	internal var displayValue: String
	internal var displayLabel: String!
	internal var value: Int!
	internal var rate: String!
	internal var outcome: ZCRMCharts.Outcome!
	public var comparedToLabel: String!
	public var comparedToValue: String!
	
	/**
	For KPI of type Basic.
	- parameters:
		- displayValue: The value of the basic kpi component.
	*/
	public init(displayValue: String){
		self.displayValue = displayValue
	}
	
	/**
	For KPI of type Standard/Growth Index.
	- parameters:
		- displayValue: value of the standard/growth index kpi component.
		- rate: rate differed from the compared one.
		- outcome: outcome of the kpi.
	*/
	public init(displayValue: String, rate: String, outcome: ZCRMCharts.Outcome) {
		self.displayValue = displayValue
		self.rate = rate
		self.outcome = outcome
	}
	
	/**
	For KPI of type Scorecard.
	- parameters:
		- displayLabel: label for the kpi row data.
		- displayValue: value for the kpi row.
		- rate: rate of growth outcome.
		- status: it is a increment/decrement/neutral.
	*/
	public init(displayLabel: String, displayValue: String, rate: String, outcome: ZCRMCharts.Outcome){
		self.displayLabel = displayLabel
		self.displayValue = displayValue
		self.rate = rate
		self.outcome = outcome
	}
	
	/**
	For KPI of type Rankings.
	- parameters:
		- displayLabel: label for the kpi row data.
		- displayValue: value for the kpi row.
	*/
	public init(displayLabel: String, displayValue: String, value: Int) {
		self.displayLabel = displayLabel
		self.displayValue = displayValue
		self.value = value
	}
	
}

public struct ZCRMChunkData {
	
	internal let label: String
	internal let value: Int
	internal var rate: String!
	internal var outcome: ZCRMCharts.Outcome!
	
	public init(label: String, value: Int) {
		self.label = label
		self.value = value
	}
	
	public init(label: String, value: Int, rate: String, outcome: ZCRMCharts.Outcome) {
		self.label = label
		self.value = value
		self.rate = rate
		self.outcome = outcome
	}
}

public struct ZCRMComparatorGroup {
	
	public let label: String
	internal var image: UIImage!
	public var tag: String = ""
	public var bgColor: UIColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
	public var avatarBgColor: UIColor = .gray
	
	public init(label: String) {
		self.label = label
	}
}

public struct ZCRMComparatorGroupings {
	
	public let groups: [ZCRMComparatorGroup]
	public var loadingImage: UIImage!
	public private(set) var isAvatarNeeded: Bool = false
	public private(set) var label: String!
	
	public init(groups: [ZCRMComparatorGroup]) {
		self.groups = groups
	}
	
	public init(groups: [ZCRMComparatorGroup], isAvatarNeeded: Bool) {
		self.groups = groups
		self.isAvatarNeeded = isAvatarNeeded
	}
	
	public init(groups: [ZCRMComparatorGroup], label: String) {
		self.groups = groups
		self.label = label
	}
	
}

public struct ZCRMComparatorChunk {
	
	public let label: String
	public internal(set) var color: UIColor = .green
	public var tag: String = ""
	
	public init(label: String) {
		self.label = label
	}
	
	public init(label: String, color: UIColor) {
		self.label = label
		self.color = color
	}
}

public protocol ZCRMComparatorDataSource: class {
	
	func comparator(_ chunk: ZCRMComparatorChunk, _ group: ZCRMComparatorGroup, chunkIndex: Int, groupIndex: Int) -> ZCRMChunkData
	
	func groupImage(of group: ZCRMComparatorGroup, completion : @escaping (UIImage?) -> () )
}

public struct ZCRMFunnelStage{
	
	public let label: String
	public private(set) var color: UIColor!
	public var tag: String = ""
	
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
	public var tag: String = ""
	
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
	
	func rateFor(_ fromStage: ZCRMFunnelStage, _ toStage: ZCRMFunnelStage) -> ZCRMFunnelData
	
	func rateFor(_ fromStage: ZCRMFunnelStage, _ toStage: ZCRMFunnelStage, segment: ZCRMFunnelSegment) -> ZCRMFunnelData
	
	func funnel(_ stage: ZCRMFunnelStage) -> ZCRMFunnelData
	
	func funnel(_ stage: ZCRMFunnelStage, segment: ZCRMFunnelSegment) -> ZCRMFunnelData
	
	func conversionRateFor(_ funnel: ZCRMFunnel) -> ZCRMFunnelData
	
	func overallDropRateFor(_ funnel: ZCRMFunnel) -> ZCRMFunnelData
	
	func conversionRateFor(_ funnel: ZCRMFunnel, _ segment: ZCRMFunnelSegment) -> ZCRMFunnelData
}
