//
//  RecordsView.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/26/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct RecordsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Record.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Record.dateRecorded, ascending: false)]) var records: FetchedResults<Record>
    @State private var filterRecordsIndex = 0
    var avgSystolic: Float {
        var inputCount: Int = 0
        var sumOfSystolic: Float = 0.0
        filterRecords().forEach { (record) in
            inputCount += 1
            sumOfSystolic += Float(record.systolic)
        }
        if sumOfSystolic == 0.0 {
            return 0.0
        } else {
            return sumOfSystolic / Float(inputCount)
        }
        
    }
    var avgDiastolic: Float {
        var inputCount: Int = 0
        var sumOfDiastolic: Float = 0.0
        filterRecords().forEach { (record) in
            inputCount += 1
            sumOfDiastolic += Float(record.diastolic)
        }
        if sumOfDiastolic == 0.0 {
            return 0.0
        } else {
          return sumOfDiastolic / Float(inputCount)
        }
        
    }
    
    let filterOptions = ["All", "Morning", "Evening"]
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                VStack {
                    ScrollView {
                        Picker(selection: $filterRecordsIndex, label: Text("Filter")) {
                            ForEach(0..<filterOptions.count) { index in
                                Text(self.filterOptions[index]).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                            .onAppear {
                                UISegmentedControl.appearance().selectedSegmentTintColor = .black
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
                        }
                        VStack {
                            HStack {
                                Text("\(self.filterOptions[self.filterRecordsIndex]) records avgs")
                                    .font(.title)
                            }
                            HStack {
                                VStack {
                                    Text("Systolic")
                                        .font(.headline)
                                    Text("\(avgSystolic, specifier: "%.2f")")
                                    
                                }
                                VStack {
                                    Text("Diastolic")
                                        .font(.headline)
                                    Text("\(avgDiastolic, specifier: "%.2f")")
                                }
                            }
                        }
                        ForEach(filterRecords(), id: \.self) { (record: Record) in
                            VStack {
                                RecordCardView(record: record)
                            }
                        }
                    }
                    .offset(x: 0, y: UIScreen.main.bounds.size.height * 0.2)
                }
                .padding(.bottom, 200)
            }
            .navigationBarItems(trailing: Button(action: {
                self.setupPrinterAction()
            }) {
                Image(systemName: "printer")
            })
            .navigationBarTitle(Text("Records"), displayMode: .large)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func createTextFormatter() -> UISimpleTextPrintFormatter {
        print("Hello World")
        var recordString = "\(self.filterOptions[self.filterRecordsIndex]) Records\n"
        let filter = self.filterOptions[self.filterRecordsIndex]
        recordString += "Avg \(filter) Systolic: \(avgSystolic)\n"
        recordString += "Avg \(filter) Diastolic: \(avgDiastolic)\n"
        self.filterRecords().forEach { (record) in
            recordString += "\(formatDateToString(record: record)), Systolic: \(record.systolic) Diastolic: \(record.diastolic)\n"
        }
        return UISimpleTextPrintFormatter(text: recordString)
        
    }
    
    func setupPrinterAction() {
        let recordFormatter = createTextFormatter()
        recordFormatter.color = .black
        let vc = UIActivityViewController(activityItems: [recordFormatter], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true)
    }
    
    func formatDateToString(record: Record) -> String {
        var returnString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        if let dateRecorded = record.dateRecorded {
            returnString = dateFormatter.string(from: dateRecorded)
        }
        return returnString
    }
    
    func filterRecords() -> [Record] {
        var filteredRecords: [Record]
        switch(filterRecordsIndex) {
        case 0:
            filteredRecords = self.records.filter({ (record) -> Bool in
                record == record
            })
            break
        case 1:
            filteredRecords = self.records.filter({ (record) -> Bool in
                record.morning == true
            })
            break
        case 2:
            filteredRecords = self.records.filter({ (record) -> Bool in
                record.morning == false
            })
            break
        default:
            filteredRecords = self.records.filter({ (record) -> Bool in
                record == record
            })
            break
        }
        return filteredRecords
    }
    
}

struct RecordsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsView()
    }
}
