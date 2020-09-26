//
//  LastRecordedPressure.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/25/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI



struct LastRecordedPressure: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Record.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Record.dateRecorded, ascending: false)]) var records: FetchedResults<Record>
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Last record")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Spacer()
            }
            .padding([.top, .bottom], 10)
            .background(Color.black)
            
            HStack {
                VStack {
                    Text("BP")
                    Text("\(records[0].systolic) / \(records[0].diastolic)")
                    .font(.largeTitle)
                }
                Spacer()
                VStack{
                    Text("Date")
                    Text("\(self.formatDateToString())")
                        .font(.headline)
                }
            }
        .padding()
            .background(Color.gray)
        }
    .cornerRadius(20)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
        
    }
    func formatDateToString() -> String {
        var returnString = "9/25/2020"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        if let dateRecorded = records[0].dateRecorded {
            returnString = dateFormatter.string(from: dateRecorded)
        }
        return returnString
    }
}

struct LastRecordedPressure_Previews: PreviewProvider {
    static var previews: some View {
        LastRecordedPressure()
    }
}
