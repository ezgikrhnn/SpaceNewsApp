//
//  ContentView.swift
//  SpaceNewsApp
//
//  Created by Ezgi Karahan on 2.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: PROPERTIES
    @StateObject var data = SpaceAPI() ///APIClient dosyasındaki SPaceAPI sınıfından nesne oluşturdum.
    @State private var opac = 0.0
    
    
    var body: some View {
        NavigationView {
            VStack {
                NewsView()
                    .opacity(opac)
            }
            .navigationTitle("Space News") ///başlık verdim
            .environmentObject(data) ///burada bunu tanımlamak çok önemli.
            .onAppear{
                data.getData() ///açıldığı anda veri alma fonksiyonunu çağırdım.
                
                withAnimation(.easeIn(duration: 2)){
                    opac = 1.0
                }//: animasyon
            } //: onAppear
        }//: NAVIGATION VIEW
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
