//
//  ContentView.swift
//  IPLocationApp
//
//  Created by Gamze Akyüz on 29.10.2024.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var ipAdress: String = ""
    @State private var locationInfo: IPLocation? = nil
    @State private var errorMesage: String = ""
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: 20){
            Text("IP Adresinde Konum Bulma")
                .font(.largeTitle)
                .bold()
                .padding()
            
            TextField("IP Adresini Girin: ", text: $ipAdress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.decimalPad)
            
            Button {
                fetchLocation()
            } label: {
               Text("Konumu Bul")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            
            if let location = locationInfo {
                
                List {
                    Section(header: Text("Konum Bilgileri")) {
                        Text("Ülke: \(location.country)")
                        Text("Bölge: \(location.regionName)")
                        Text("Şehir: \(location.city)")
                        Text("Enlem: \(location.lat)")
                        Text("Boylam: \(location.lon)")
                        Text("IP: \(location.query)")
                    }
                }
                .listStyle(InsetListStyle())
                .background(Color.white)
            }else if !errorMesage.isEmpty {
                Text(errorMesage)
                    .foregroundColor(.red)
                    .padding()
            }
            else {
                Text("Konum bilgisi bekleniyor..")
                    .padding()
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
    //MARK: - Func
    func fetchLocation(){
        guard !ipAdress.isEmpty else {
            errorMesage = "Lütfen geçerli bir IP adresi girin"
            locationInfo = nil
            return
        }
        
        let urlString = "http://ip-api.com/json/\(ipAdress)?fields=status,country,regionName,city,lat,lon,query"
        
        guard let url = URL(string: urlString) else {
            errorMesage = "Geçersiz URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errorMesage = "Veri alınamadı"
                    locationInfo = nil
                }
                return
            }
            
            if let result = try? JSONDecoder().decode(IPLocation.self, from: data) {
                DispatchQueue.main.async {
                    if result.status == "success" {
                        errorMesage = ""
                        locationInfo = result
                    } else {
                        errorMesage = "Konum bilgisi bulunamadı."
                        locationInfo = nil
                    }
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
