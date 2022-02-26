//
//  LibrarySearcher.swift
//  ToshokanKensaku
//
//  Created by 国生将弥 on 2022/02/18.
//

import Foundation
import SwiftUI

struct ResultLibrary:Codable{
    let systemid:String
    let systemname:String
    let libkey:String
    let formal:String
    let url_pc:String
    let address:String
    let pref:String
    let city:String
    let post:String
    let tel:String
    let geocode:String
    let category:String
    //let distance:String?
}


func LibraryToSpot(_ library:ResultLibrary) -> Spot{
    let spot:Spot
    let geocode = library.geocode.components(separatedBy: CharacterSet(charactersIn: ","))
    if let latitude = Double(geocode[1]),
       let longitude = Double(geocode[0]){
        spot = Spot(name: library.formal, category: library.category, urlStr: library.url_pc, latitude: latitude, longitude: longitude)
    }else{
        spot = Spot(name: "None", category: "None",urlStr: "https://www.apple.com/jp/",latitude: 0.0, longitude: 0.0)
    }
    return spot
}


class LibrarySearcher:ObservableObject{
    @Published var resultLibrarys:[ResultLibrary?]?
    @Published var spotList:[Spot] = []
    
    //APIキー
    let APIKey = "886cf6c95edf280fc45b5eacacf591ee"
    
    //最大検索数
    
    func search(latitude:String,longitude:String,limit:String) -> (){
        
        let urlString = "https://api.calil.jp/library?appkey={\(APIKey)}&geocode=\(longitude),\(latitude)&limit=\(limit)&format=json&callback="
        guard let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)else{
            return
            //fatalError("URL String Error")
        }
        //URLに変換
        guard let url = URL(string: urlStr)else{
            return
            //fatalError("Could'nt convert to url:\(urlStr)")
        }
        let request = URLRequest(url: url)
        
        
        let task = URLSession.shared.dataTask(with: request){(data,response,error) in
            if let jsonData = data{
                
                let decodedDatas:[ResultLibrary?]
                do{
                    
                    let decoder = JSONDecoder()
                    decodedDatas = try decoder.decode([ResultLibrary].self, from: jsonData)
                    
                }catch{
                    
                    return
                    //fatalError("Could'nt decode JSON data.")
                }
                //メインスレッド
                DispatchQueue.main.async {
                    self.resultLibrarys = decodedDatas
                    self.spotList = []
                    for library_ in self.resultLibrarys!{
                        self.spotList.append(LibraryToSpot(library_!))
                    }
                }
            }else{
                return
                //fatalError("request error")
            }
        }
        task.resume()
    }
}
