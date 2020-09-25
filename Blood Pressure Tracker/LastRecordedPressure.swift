//
//  LastRecordedPressure.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/25/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct LastRecordedPressure: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Last record")
                    .font(.largeTitle)
                Spacer()
            }
            .padding([.top, .bottom], 10)
            .background(Color.red)
            
            HStack {
                VStack {
                    Text("BP")
                    Text("120/80")
                    .font(.largeTitle)
                }
                Spacer()
                VStack{
                    Text("Date")
                    Text("9/25/2020")
                        .font(.largeTitle)
                }
            }
        .padding()
            .background(Color.gray)
        }
    .cornerRadius(20)
        .shadow(color: Color.gray, radius: 20, x: 0, y: 0)
        
        
    }
}

struct LastRecordedPressure_Previews: PreviewProvider {
    static var previews: some View {
        LastRecordedPressure()
    }
}
