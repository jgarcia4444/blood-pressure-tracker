//
//  recordCardView.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/26/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct RecordCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    var record: Record
    @State private var newSystolic = ""
    @State private var newDiastolic = ""
    @State private var editingRecord = false
    @State private var newNotes = ""
    @State private var newArmTaken = ""
    @State private var showDetails = false
    let armOptions = ["Right", "Left"]
    var body: some View {
        VStack {
            HStack {
                Text(formatDateToString())
            }
            VStack {
                HStack {
                    Button(action: {
                        showDetails.toggle()
                    }) {
                        if editingRecord != true {
                            if showDetails == false {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(Color.blue)
                            } else {
                                Image(systemName: "arrowtriangle.up.square.fill")
                                    .foregroundColor(Color.blue)
                            }
                        }
                    }
                }
            HStack {
                VStack {
                    Text("Systolic")
                        .fontWeight(.black)
                        .padding()
                    if editingRecord {
                        TextField("\(record.systolic)", text: $newSystolic )
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .foregroundColor(self.computedForegroundColor())
                    } else {
                        Text("\(String(record.systolic))")
                            .fontWeight(.bold)
                    }
                    
                }
                VStack {
                    Text("Diastolic")
                        .fontWeight(.black)
                        .padding()
                    if editingRecord {
                        TextField("\(record.diastolic)", text: $newDiastolic)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .foregroundColor(self.computedForegroundColor())
                    } else {
                        Text("\(String(record.diastolic))")
                            .fontWeight(.bold)
                    }
                    
                }
                
            }
                if editingRecord {
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Notes")
                            .fontWeight(.black)
                        TextEditor(text: $newNotes)
                            .foregroundColor(self.computedForegroundColor())
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2.0)
                            )
                    }
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Arm Taken")
                            .fontWeight(.black)
                        Picker("Arm Taken", selection: $newArmTaken) {
                            ForEach(0..<self.armOptions.count) {
                                Text(armOptions[$0]).tag(armOptions[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                if showDetails && !editingRecord {
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Notes")
                            .fontWeight(.black)
                        Text(record.notes ?? "")
                    }
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Arm Taken")
                            .fontWeight(.black)
                        Text(record.armTaken ?? "")
                    }
                }
            }
            .padding()
            .background(Color.white.cornerRadius(5).shadow(color: .black, radius: 5, x: 0, y: 3))
            .foregroundColor(.black)
            HStack {
                if self.editingRecord {
                    HStack {
                        Button(action: {
                            self.updateBP()
                        }) {
                            Text("Confirm")
                        }
                        .frame(width: 70, height: 40)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black, radius: 3, x: 0, y: 1)
                        .padding(.trailing, 10)
                        Button(action: {
                            editingRecord.toggle()
                        }) {
                            Text("Cancel")
                                .frame(width: 70, height: 40)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: .black, radius: 3, x: 0, y: 1)
                                .padding(.trailing, 10)
                                .foregroundColor(Color.red)
                        }
                    }
                } else {
                    HStack {
                        Button(action: {
                            self.editingRecord = true
                            self.newSystolic = String(self.record.systolic)
                            self.newDiastolic = String(self.record.diastolic)
                            self.newNotes = String(self.record.notes ?? "")
                            self.newArmTaken = String(self.record.armTaken ?? "")
                        }) {
                            Text("Edit")
                        }
                        .frame(width: 70, height: 40)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black, radius: 3, x: 0, y: 1)
                        .padding(.trailing, 10)
                        Button(action: {
                            self.deleteBP()
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        }
                        .frame(width: 70, height: 40)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black, radius: 3, x: 0, y: 1)
                        .padding(.leading, 10)
                    }
                    .padding(.top, 10)
                }
            }
        }
        .padding()
    }
    
    func computedForegroundColor () -> Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    func deleteBP() {
        self.moc.delete(self.record)
        do {
            try self.moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateBP() {
        guard let updatedSystolic = Int16(self.newSystolic) else {
            print("Unable to turn updated systolic into an integer")
            return
        }
        guard let updatedDiastolic = Int16(self.newDiastolic) else {
            print("Unable to turn updated diastolic into an integer")
            return
        }
        
        record.systolic = updatedSystolic
        record.diastolic = updatedDiastolic
        record.notes = newNotes
        record.armTaken = newArmTaken
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
        self.editingRecord = false
    }
    
    func formatDateToString() -> String {
        var returnString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        if let dateRecorded = record.dateRecorded {
            returnString = dateFormatter.string(from: dateRecorded)
        }
        return returnString
    }
}

//struct RecordCardView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        RecordCardView()
//    }
//}
