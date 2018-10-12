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
	public var difference: String!
	public var rate: String!
	public var objective: ZCRMKPIObjective!
	
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
	- difference: value differed from the compared one.
	- status: it is a increment/decrement/neutral.
	*/
	public init(value: String, difference: String, objective: ZCRMKPIObjective) {
		
		self.value = value
		self.difference = difference
		self.objective = objective
	}
	
	/**
	For KPI of type Scorecard.
	- parameters:
	- value: name of the kpi row.
	- difference: value of the row data.
	- rate: rate of increment/decrement.
	- status: it is a increment/decrement/neutral.
	*/
	public init(value: String, difference: String, rate: String, objective: ZCRMKPIObjective){
		
		self.value = value;
		self.difference = difference
		self.rate = rate
		self.objective = objective
	}
	
	/**
	For KPI of type Rankings.
	- parameters:
	- value: name of the kpi row.
	- difference: value of the row data.
	*/
	public init(value: String, difference: String) {
		
		self.value = value;
		self.difference = difference
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
