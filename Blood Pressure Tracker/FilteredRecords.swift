//
//  FilteredRecords.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/26/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct FilteredRecords: View {
    var records: FetchRequest<Record>
    var body: some View {
        VStack {
            ForEach(self.records, id: \.self) { record in
                    RecordCardView(record: record)
            }
        }
    }
    
    init(filter: Int) {
        var predicateValue = ""
        if filter == 0 {
            records = FetchRequest<Record>(entity: Record.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Record.dateRecorded, ascending: false)])
            return
        } else if filter == 1 {
            predicateValue = "true"
        } else {
            predicateValue = "false"
        }
        records = FetchRequest<Record>(entity: Record.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Record.dateRecorded, ascending: false)], predicate: NSPredicate(format: "morning == %@", predicateValue))
    }
}

struct FilteredRecords_Previews: PreviewProvider {
    static var previews: some View {
        FilteredRecords(filter: 0)
    }
}
