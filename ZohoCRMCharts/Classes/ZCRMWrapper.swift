//
//  ZCRMWrapper.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

/**
	Types of KPI components available in Zoho CRM Charts.
*/
public enum ZCRMKPIComponent: String {
	
	case standard
	case growthIndex
	case basic
	case scorecard
	case rankings
}

/**
	Types of Comparator components available in Zoho CRM Charts.
*/
public enum ZCRMComparatorComponent: String {
	
	case elegant
	case sport
	case classic
}

/**
	To point out the objective of a data.
*/
public enum ZCRMObjective {
	
	case increased
	case decreased
	case neutral
}

/**
	Data object for KPI components of all types.
*/
public struct ZCRMKPIRow {
	
	internal var value: String!
	internal var label: String!
	internal var rate: String!
	internal var objective: ZCRMObjective!
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
	public init(value: String, rate: String, objective: ZCRMObjective) {
		self.value = value
		self.rate = rate
		self.objective = objective
	}
	
	/**
	For KPI of type Scorecard.
	- parameters:
		- label: label for the kpi row data.
		- value: value for the kpi row.
		- rate: rate of increment/decrement.
		- status: it is a increment/decrement/neutral.
	*/
	public init(label: String, value: String, rate: String, objective: ZCRMObjective){
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
	
	internal var label: String
	internal var value: Int
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
	
	internal var label: String
	internal var value: String
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

public final class ZCRMComparatorGroupings {
	
	internal var groups: [ZCRMComparatorGroup]
	internal var isAvatarNeeded: Bool
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

public final class ZCRMComparatorChunk {
	
	internal var label: String
	internal var objective: ZCRMObjective!
	
	public init(label: String) {
		self.label = label
	}
	
}

public protocol ZCRMComparatorDataSource: class {
	
	func comparator(_ chunk: ZCRMComparatorChunk, _ group: ZCRMComparatorGroup, dataForRowAt: Int) -> ZCRMChunkData
}

/**
	Error.
*/
public struct ZCRMChartsError : Error {
	
	let message: String
	
	init(message: String) {
		self.message = "ZCRMCharts - \(message)"
	}
	
	public var localizedDescription: String {
		return self.message
	}
}
