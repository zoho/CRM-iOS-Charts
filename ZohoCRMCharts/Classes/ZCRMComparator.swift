//
//  ZCRMComparator.swift
//  ZohoCRMCharts
//
//  Created by Sarath Kumar Rajendran on 31/10/18.
//

public final class ZCRMComparator: UIView {
	
	private var title: String
	private var type: ZCRMComparatorComponent
	private var groupings: ZCRMComparatorGroupings
	private var chunks: [ZCRMComparatorChunk]

	public init(title: String, type: ZCRMComparatorComponent, groupings: ZCRMComparatorGroupings, chunks: [ZCRMComparatorChunk]) {
		self.title = title
		self.type = type
		self.groupings = groupings
		self.chunks = chunks
		super.init(frame: .zero)
	}
	
	public init(frame: CGRect, title: String, type: ZCRMComparatorComponent, groupings: ZCRMComparatorGroupings, chunks: [ZCRMComparatorChunk]) {
		self.title = title
		self.type = type
		self.groupings = groupings
		self.chunks = chunks
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

fileprivate extension ZCRMComparator {
	
	func render() {
		
	}
}
