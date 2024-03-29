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
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding([.top, .bottom], 10)
                HStack {
                    VStack {
                        Text("BP")
                        Text("\(self.records[0].systolic) / \(self.records[0].diastolic)")
                            .font(.largeTitle)
                    }
                    Spacer()
                    VStack{
                        Text("Date")
                        Text("\(self.formatDateToString())")
                            .font(.headline)
                        Text("\(self.formateDateToTimeString())")
                            .font(.headline)
                    }
                }
                .padding()
                .background(Color.white.cornerRadius(5).clipShape(RoundedRectangle(cornerRadius: 15)).shadow(color: .black, radius: 3, x: 0, y: 5))
                .foregroundColor(.black)
                
            }
            
    
            .padding()
    }
    

    
    func formateDateToTimeString() -> String {
        var returnString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        if let dateRecorded = records[0].dateRecorded {
            returnString = dateFormatter.string(from: dateRecorded)
        }
        return returnString
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
