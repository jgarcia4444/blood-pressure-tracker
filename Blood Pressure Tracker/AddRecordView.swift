//
//  AddRecordView.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/25/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct AddRecordView: View {
    @State private var systolic = ""
    @State private var diastolic = ""
    var body: some View {
        ZStack {
            Color.red
            VStack {
                VStack {
                    HStack {
                        TextField("Systolic", text: $systolic)
                        TextField("Diastolic", text: $diastolic)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                }
                .padding()
                VStack {
                    Button(action: {
                        self.saveBP()
                    }) {
                        Text("Add Record")
                    }
                }
            }
        }
        .navigationBarTitle("Blood Pressure", displayMode: .large)
        .edgesIgnoringSafeArea(.all)
    }
    func saveBP() {
        
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView()
    }
}
