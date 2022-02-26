//
//  LibraryAnnotationView.swift
//  ToshokanKensaku
//
//  Created by 国生将弥 on 2022/02/21.
//

import SwiftUI

struct LibraryAnnotationView: View {
    //蔵書を管理している構造体 //できれば追加
    //アノテーション構造体
    var spot:Spot
    //SafariViewの表示の有無を管理する
    @State var showSafari:Bool = false
    
    var body: some View {
        Button(action: {
            //サイトに飛べるようにする
            showSafari.toggle()
        }, label: {
            
            switch spot.category{
            case "SMALL":
                Image("SMALL")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 54)
            case "MEDIUM":
                Image("MEDIUM")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 52)
            case "LARGE":
                Image("LARGE")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
            case "UNIV":
                Image("UNIV")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 72)
            case "SPECIAL":
                Image("SPECIAL")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 64)
            case "BM":
                Image("BM")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 42)
            default:
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
            }
        })//Button
            .sheet(isPresented: $showSafari, content: {
                SafariView(urlStr: spot.urlStr)
            })//sheet
        Text(spot.name).italic()
            .background(.white)
    }
}

struct LibraryAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryAnnotationView(spot: Spot(name: "None", category: "None", urlStr: "http://library.kodaira.ed.jp/", latitude: 0.0, longitude: 0.0))
    }
}
