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
    @State private var dateFormatter : DateFormatter?
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Last record")
                    .font(.largeTitle)
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
                    Text("")
                        .font(.largeTitle)
                }
            }
        .padding()
            .background(Color.gray)
        }
    .cornerRadius(20)
        .shadow(color: Color.gray, radius: 20, x: 0, y: 0)
        .onAppear {
            self.setupDateFormatter()
        }
        
    }
    func setupDateFormatter() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        self.dateFormatter = dateFormatter
    }
}

struct LastRecordedPressure_Previews: PreviewProvider {
    static var previews: some View {
        LastRecordedPressure()
    }
}
