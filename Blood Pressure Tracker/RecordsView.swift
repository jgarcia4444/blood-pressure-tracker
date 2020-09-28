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
    
    let filterOptions = ["All", "Morning", "Evening"]
    var body: some View {
        ZStack {
            Color.red
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
                    ForEach(filterRecords(), id: \.self) { (record: Record) in
                            VStack {
                                RecordCardView(record: record)
                            }
                        }
                }
                .offset(x: 0, y: UIScreen.main.bounds.size.height * 0.2)
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
    
    func createPageRenderer() -> UIPrintPageRenderer {
        print(self.records)
        var recordString = "\(self.filterOptions[self.filterRecordsIndex]) Records\n"
        
        self.filterRecords().forEach { (record) in
            recordString += "\(formatDateToString(record: record)), Systolic: \(record.systolic) Diastolic: \(record.diastolic)\n"
        }
        let formatter = UISimpleTextPrintFormatter(text: recordString)
        let pageRenderer = UIPrintPageRenderer()
        pageRenderer.addPrintFormatter(formatter, startingAtPageAt: 0)
        return pageRenderer
    }
    
    func setupPrinterAction() {
        let recordPageRenderer = createPageRenderer()
        let vc = UIActivityViewController(activityItems: [recordPageRenderer], applicationActivities: nil)
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
