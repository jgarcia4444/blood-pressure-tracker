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
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                Spacer()
                VStack {
                    HStack {
                        TextField("Systolic", text: $systolic)
                            .shadow(color: .black, radius: 3, x: 0, y: 3)
                        TextField("Diastolic", text: $diastolic)
                            .shadow(color: .black, radius: 3, x: 0, y: 3)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                }
                .padding()
                HStack {
                    Text(systolic.count > 0 || diastolic.count > 0 ? "\(systolic) / \(diastolic)" : "")
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
                            .shadow(color: .black, radius:  3, x: 0, y: 3)
                    }
                
                }
                Spacer()
            }
        
        }
        .navigationBarTitle("Blood Pressure", displayMode: .large)
        
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $recordSaved) {
            Alert(title: Text("Record Saved"), message: Text("Your blood pressure input has been saved."), dismissButton: .default(Text("Okay"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
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
        
        
        
        if let dateRecorded = newRecord.dateRecorded {
            let isMorning = self.checkTime(dateRecorded: dateRecorded)
            newRecord.morning = isMorning
        }
        
        do {
            try context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
        recordSaved = true
    }
    
    func checkTime(dateRecorded: Date) -> Bool {
        var morningCheck = false
        let components = Calendar.current.dateComponents([.hour], from: dateRecorded)
        if let currentHour = components.hour {
            if currentHour < 12 {
                morningCheck = true
            } else {
                morningCheck = false
            }
        }
        return morningCheck
    }
    
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView()
    }
}
