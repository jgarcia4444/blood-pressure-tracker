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
    let activeButtonBG = LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let disabledButtonBG = LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.5) as? LinearGradient
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing                )
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
                        .padding([.bottom, .top], 20)
                        VStack {
                            HStack {
                                Text("Notes")
                                Spacer()
                            }
                            .padding(.leading, 20)
                            TextEditor(text: $notes)
                                .frame(width: 350, height: 50 )
                                .cornerRadius(5)
                            Text("Was there a specific reason you recorded your blood pressure")
                                .font(.caption)
                            }
                        .padding(.bottom, 50)
                        .onTapGesture {
                            hideKeyboard()
                        }
                        VStack {
                                Text("Which arm did you take your reading on?")
                                    .font(.headline)
                                    .onTapGesture {
                                        hideKeyboard()
                                    }
                                Picker("Arm Reading", selection: $armTaken) {
                                    ForEach(0..<armTakenOptions.count) {
                                        Text(armTakenOptions[$0]).tag(armTakenOptions[$0])
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                    .padding([.top, .bottom], 125)
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
                                    .background(disableAddRecordButton() ? disabledButtonBG : activeButtonBG)
                                    .clipShape(Capsule())
                                    .foregroundColor(.black)
                                    .shadow(color: .black, radius: disableAddRecordButton() ? 0 : 3, x: 0, y: disableAddRecordButton() ? 0 : 3)
                            }
                            .animation(.easeOut)
                            .disabled(disableAddRecordButton())
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
    
    func disableAddRecordButton() -> Bool {
        let systolicCount = self.systolic.count
        let diastolicCount = self.diastolic.count
        let systolicCountInRange = systolicCount > 0 && systolicCount < 4 ? true : false
        let diastolicCountInRange = diastolicCount > 0 && diastolicCount < 4 ? true : false
        if systolicCountInRange && diastolicCountInRange {
            if self.armTaken != "" {
                return false
            }
        }
        return true
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
        newRecord.notes = notes
        newRecord.armTaken = armTaken
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

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
#endif

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView()
    }
}
