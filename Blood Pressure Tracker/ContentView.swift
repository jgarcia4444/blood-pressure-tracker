//
//  ContentView.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/25/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.red
            NavigationView {
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            LastRecordedPressure()
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
