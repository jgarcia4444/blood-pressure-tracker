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
        NavigationView {
            ZStack {
                Color.red
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            if (records.count > 0) {
                                LastRecordedPressure()
                            } else {
                                Text("No Blood Pressure Recorded Yet.")
                                    .font(.largeTitle)
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        HStack {
                            NavigationLink(destination: AddRecordView()) {
                              Image(systemName:"plus")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(Color.gray)
                                .clipShape(Circle())
                                .foregroundColor(.red)
                                .shadow(color: .black, radius:  10, x: 0, y: 0)
                            }
                        }
                    }
                    Spacer()
                }
                .navigationBarTitle("BP Tracker", displayMode: .large)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
