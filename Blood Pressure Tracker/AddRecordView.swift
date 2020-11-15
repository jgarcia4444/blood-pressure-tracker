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
    @State private var displayEntryConfirmAlert = false
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
                        withAnimation {
                            self.displayEntryConfirmAlert = true
                        }
                        }) {
                        Text("Add Record")
                            .padding()
                        .overlay(
                            Capsule()
                                .stroke(lineWidth: 3)
                                .foregroundColor(.black)
                        )
                            .background(LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .clipShape(Capsule())
                            .foregroundColor(.black)
                            .shadow(color: .black, radius:  3, x: 0, y: 3)
                    }
                    .animation(.easeOut
                    )
                }
                Spacer()
            }
        }
        .navigationBarTitle("Blood Pressure", displayMode: .large)
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $displayEntryConfirmAlert) {
            Alert(title: Text("New BP Entry"), message: Text("Your blood pressure input of \(systolic) / \(diastolic) (systolic/diastolic) will be saved when confirmed."), primaryButton: .default(Text("Confirm"), action: {
                self.saveBP()
            }), secondaryButton: .cancel(Text("Cancel")) )
        }
    }
    
    func saveBP() {
        let newRecord = Record(context: managedObjectContext)
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
            try managedObjectContext.save()
        } catch {
            print("\(error.localizedDescription)")
        }
        self.presentationMode.wrappedValue.dismiss()
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
