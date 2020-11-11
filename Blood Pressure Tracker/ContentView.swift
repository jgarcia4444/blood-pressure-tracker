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
                LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
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
                                .overlay(
                                    Circle()
                                        .stroke(lineWidth: 3)
                                        .foregroundColor(.black)
                                )
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.red)
                                .shadow(color: .black, radius: 3, x: 0, y: 3)
                            }
                            .padding([.top, .bottom], 50)
                        }
                        NavigationLink(destination: withAnimation{RecordsView()}.animation(.default)) { 
                            HStack {
                                Text("All Records")
                                    .font(.title)
                                Image(systemName: "doc.on.doc")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.red)
                            }
                            .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 3)
                                )
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black, radius: 3, x: 0, y: 3)
                            .padding([.top, .bottom], 50)
                        }
                        .foregroundColor(.black)
                        
                    }
                    
                }
                .padding(.top, 100)
                .navigationBarTitle(Text("BP Numbers").foregroundColor(.black), displayMode: .large)
            }
            .edgesIgnoringSafeArea(.all)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .white
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
        }
    .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
