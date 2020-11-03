//
//  ContentView.swift
//  Blood Pressure Tracker
//
//  Created by Jake Garcia on 9/25/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Record.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Record.dateRecorded, ascending: false)])  var records: FetchedResults<Record>
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.red, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack {
                    VStack {
                        HStack {
                            if (records.count > 0) {
                                LastRecordedPressure()
                            } else {
                                
                                HStack {
                                    Text("No Blood Pressure Recorded Yet.")
                                        .font(.headline)
                                    .fixedSize(horizontal: true, vertical: false)
                                }
                                
                            }
                        }
                    }
                    VStack {
                        HStack {
                            NavigationLink(destination: AddRecordView()) {
                              Image(systemName:"plus")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(Color.gray)
                                .clipShape(Circle())
                                .foregroundColor(.red)
                                .shadow(color: .black, radius:  10, x: 0, y: 0)
                            }
                            .padding([.top, .bottom], 50)
                        }
                        NavigationLink(destination: RecordsView()) { 
                            HStack {
                                Text("All Records")
                                    .font(.title)
                                Image(systemName: "doc.on.doc")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                            .shadow(color: .black, radius: 10, x: 0, y: 0)
                            .padding([.top, .bottom], 50)
                        }
                        .foregroundColor(.black)
                        
                    }
                    
                }
                .padding(.top, 100)
                .navigationBarTitle("BP Numbers", displayMode: .large)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .accentColor(.black)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
