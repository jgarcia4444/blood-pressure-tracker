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
    @State private var notes = ""
    @State private var displayEntryConfirmAlert = false
    @State private var armTaken = ""
    private var armTakenOptions = ["Right", "Left"]
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
            ScrollView {
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            VStack {
                                TextField("Systolic", text: $systolic)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            VStack {
                                TextField("Diastolic", text: $diastolic)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                Spacer()
                            }
                        .padding(.bottom, 20)
                        VStack {
                                Text("Notes")
                                TextEditor(text: $notes)
                                    .frame(width: 350, height: 50 )
                                    .cornerRadius(5)
                                Text("Was there a specific reason you recorded your blood pressure")
                                    .font(.caption)
                            }
                        .padding(.bottom, 50)
                        VStack {
                                Text("Which arm did you take your reading on?")
                                    .font(.headline)
                                Picker("Arm Reading", selection: $armTaken) {
                                    ForEach(0..<armTakenOptions.count) {
                                        Text(armTakenOptions[$0]).tag(armTakenOptions[$0])
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        .padding(.top, 125)
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
                            .animation(.easeOut)
                            .disabled(self.systolic.count == 0 || self.diastolic.count == 0)
                        }
                    }
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
            print("Unable to convert the systolic input")
            return
        }
        guard let diastolicInput = Int16(diastolic) else {
            print("Unable to convert the systolic input")
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
