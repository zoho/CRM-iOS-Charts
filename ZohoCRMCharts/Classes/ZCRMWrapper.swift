//
//  ZCRMWrapper.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 10/10/18.
//  Copyright © 2018 Zoho CRM. All rights reserved.
//

import Foundation

/**
	Types of KPI components available in Zoho CRM Charts.
*/
public enum ZCRMKPIComponent : String {
	
	case standard
	case growthIndex
	case basic
	case scorecard
	case rankings
}

/**
	Data object for KPI components of all types.
*/
public class ZCRMKPIRow {
	
	internal var value: String!
	internal var label: String!
	internal var rate: String!
	internal var objective: ZCRMKPIObjective!
	public var comparedToLabel: String!
	public var comparedToValue: String!
	
	private init() {}
	
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
	public init(value: String, rate: String, objective: ZCRMKPIObjective) {
		
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
	public init(label: String, value: String, rate: String, objective: ZCRMKPIObjective){
		
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

/**
	To point out the objective of a ZCRMKPIRow.
*/
public enum ZCRMKPIObjective {
	
	case increased
	case decreased
	case neutral
}


public struct ZCRMChartsError : Error {
	
	let message: String
	
	init(message: String) {
		self.message = message
	}
	
	public var localizedDescription: String {
		return self.message
	}
}


