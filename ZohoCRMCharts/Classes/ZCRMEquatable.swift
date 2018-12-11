//
//  ZCRMEquatable.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 06/12/18.
//

extension ZCRMKPIRow: Equatable {
	
	public static func == (lhs: ZCRMKPIRow, rhs: ZCRMKPIRow) -> Bool {
		return lhs.comparedToLabel == rhs.comparedToLabel && lhs.comparedToValue == rhs.comparedToValue && lhs.label == rhs.label && lhs.outcome == rhs.outcome && lhs.value == rhs.value && lhs.rate == rhs.rate
	}
}

extension ZCRMChunkData: Equatable {
	
	public static func == (lhs: ZCRMChunkData, rhs: ZCRMChunkData) -> Bool {
		return lhs.label == rhs.label && lhs.value == rhs.value && lhs.rate == rhs.rate && lhs.outcome == rhs.outcome 
	}
}

extension ZCRMComparatorGroup: Equatable {
	
	public static func == (lhs: ZCRMComparatorGroup, rhs: ZCRMComparatorGroup) -> Bool {
		return lhs.image == rhs.image && lhs.label == rhs.label && lhs.tag == rhs.tag
	}
}

extension ZCRMComparatorGroupings: Equatable {
	
	public static func == (lhs: ZCRMComparatorGroupings, rhs: ZCRMComparatorGroupings) -> Bool {
		return lhs.groups.isEqual(rhs.groups)  && lhs.isAvatarNeeded == rhs.isAvatarNeeded && lhs.label == rhs.label
	}
}

extension ZCRMComparatorChunk: Equatable {
	
	public static func == (lhs: ZCRMComparatorChunk, rhs: ZCRMComparatorChunk) -> Bool {
		return lhs.color == rhs.color && lhs.label == rhs.label && lhs.tag == rhs.tag
	}
}

extension ZCRMFunnelStage: Equatable {
	
	public static func == (lhs: ZCRMFunnelStage, rhs: ZCRMFunnelStage) -> Bool {
		return lhs.color == rhs.color && lhs.label == rhs.label && lhs.tag == rhs.tag
	}
}

extension ZCRMFunnelSegment: Equatable {
	
	public static func == (lhs: ZCRMFunnelSegment, rhs: ZCRMFunnelSegment) -> Bool {
		return lhs.label == rhs.label && lhs.tag == rhs.tag
	}
}

extension ZCRMFunnelData: Equatable {
	
	public static func == (lhs: ZCRMFunnelData, rhs: ZCRMFunnelData) -> Bool {
		return lhs.label == rhs.label && lhs.value == rhs.value
	}
}
