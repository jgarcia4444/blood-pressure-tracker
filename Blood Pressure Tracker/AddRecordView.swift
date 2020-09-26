//
//  AddRecordView.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/25/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct AddRecordView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var systolic = ""
    @State private var diastolic = ""
    @State private var recordSaved = false
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
                HStack {
                    Text("\(systolic) / \(diastolic)")
                        .font(.largeTitle)
                }
                .padding()
                VStack {
                    Button(action: {
                        self.saveBP()
                    }) {
                        Text("Add Record")
                            .padding()
                            .background(Color.gray)
                            .clipShape(Capsule())
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationBarTitle("Blood Pressure", displayMode: .large)
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $recordSaved) { () -> Alert in
            Alert(title: Text("Record Saved"), message: Text("Your blood pressure input has been saved."), dismissButton: .default(Text("Okay")))
        }
    }
    func saveBP() {
        let context = managedObjectContext
        let newRecord = Record(context: context)
        guard let systolicInput = Int16(systolic) else {
            print("Unable to convert systolic input to int")
            return
        }
        guard let diastolicInput = Int16(diastolic) else {
            print("Unable to convert diastolic input to int")
            return
        }
        newRecord.systolic = systolicInput
        newRecord.diastolic = diastolicInput
        newRecord.dateRecorded = Date()
        
        do {
            try context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
        recordSaved = true
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView()
    }
}
