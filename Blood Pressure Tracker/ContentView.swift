//
//  ContentView.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/25/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Record.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Record.dateRecorded, ascending: false)])  var records: FetchedResults<Record>
    var body: some View {
        ZStack {
            Color.red
            NavigationView {
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            if (records.count > 0) {
                                LastRecordedPressure()
                            } else {
                                Text("No Blood Pressure Recorded Yet.")
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        HStack {
                            NavigationLink(destination: AddRecordView()) {
                              Text("Hello World")
                            }
                        }
                    }
                    Spacer()
                }
                .navigationBarTitle("Blood Pressure Tracker", displayMode: .inline)
                .navigationBarItems(trailing: Text("+"))
            }
            .background(Color.gray)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
