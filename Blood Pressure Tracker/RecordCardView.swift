//
//  recordCardView.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/26/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct RecordCardView: View {
    var record: Record
    var body: some View {
        VStack {
            HStack {
                Text(formatDateToString())
            }
            .padding()
            HStack {
                VStack {
                    Text("Systolic")
//                        .font(.title)
                        .fontWeight(.black)
                        .padding()
                    Text("\(String(record.systolic))")
                    .fontWeight(.bold)
                }
                VStack {
                    Text("Diastolic")
//                        .font(.title)
                        .fontWeight(.black)
                        .padding()
                    Text("\(String(record.diastolic))")
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(Color.white.cornerRadius(5).shadow(color: .black, radius: 5, x: 0, y: 10))
        }
        
        .padding()
        
    }
    func formatDateToString() -> String {
        var returnString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        if let dateRecorded = record.dateRecorded {
            returnString = dateFormatter.string(from: dateRecorded)
        }
        return returnString
    }
}

//struct RecordCardView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        RecordCardView()
//    }
//}
