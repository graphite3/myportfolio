//
//  FilterView.swift
//  ToshokanKensaku
//
//  Created by 国生将弥 on 2022/02/25.
//

import SwiftUI

//図書館の種類
let scalekey:[String] = ["LARGE","MEDIUM","SMALL","UNIV","SPECIAL","BM"]

//フィルターの条件をまとめるクラス
class FilterItem:ObservableObject{
    //検索数
    @Published var limit:String = ""
    //図書館の種類とBool
    @Published var scaleDisp:[String:Bool] = ["LARGE":true,"MEDIUM":true,"SMALL":true,"UNIV":true,"SPECIAL":true,"BM":true]
    init(limit:String){
        self.limit = limit
    }
}

struct ScaleFilterView: View{
    //図書館の種類
    let libraryKinds:String
    var body: some View{
        ZStack{
            Rectangle()
                .fill(.white)
                .frame(width: 80)
            VStack{
                switch libraryKinds{
                case "SMALL":
                    Image("SMALL")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 27)
                case "MEDIUM":
                    Image("MEDIUM")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 26)
                case "LARGE":
                    Image("LARGE")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                case "UNIV":
                    Image("UNIV")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 36)
                case "SPECIAL":
                    Image("SPECIAL")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                case "BM":
                    Image("BM")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 21)
                default:
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.black)
                }
                Text(libraryKinds)
            }//VStack
        }//ZStack
    }
}

struct FilterView: View {
    //フィルターの吹き出しの表示の有無
    @Binding var showFilter:Bool
    //フィルターの条件をまとめるクラス
    var filterItem:FilterItem
    //検索数
    @State var limit:Int
    //図書館の種類とbool
    @State var scaleDisp:[String:Bool]
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.white)
                .frame(width: 220, height: 300)
            VStack{
                HStack{
                    Text("検索数  :")
                        .font(.title3)
                    Picker(selection: self.$limit, label: Text("検索数"),content: {
                        Text("10")
                            .tag(10)
                        Text("20")
                            .tag(20)
                        Text("30")
                            .tag(30)
                        Text("40")
                            .tag(40)
                        Text("50")
                            .tag(50)
                    })
                    
                }//HStack
                .padding(.top)
                
                ForEach(0..<scalekey.count,id:\.self){num in
                    HStack{
                        ScaleFilterView(libraryKinds: scalekey[num])
                        //チェックボックス
                        Button(action: {
                             //print(self.filterItem.scaleDisp)
                            self.scaleDisp[scalekey[num]]!.toggle()
                        }, label: {
                            Image(systemName: self.scaleDisp[scalekey[num]]! ? "checkmark.square" : "square")
                        })
                        //チェックボックス
                    }//HStack
                }
                //設定を反映ボタン
                Button(action: {
                    print(self.filterItem.scaleDisp)
                    self.filterItem.limit = "\(self.limit)"
                    self.filterItem.scaleDisp = scaleDisp
                    self.showFilter.toggle()
                }, label: {
                    Text("設定を反映")
                })//設定を反映ボタン
                    .padding(.bottom)
                
                
            }//VStack
        }//ZStack
    }
}

let filterItem_ = FilterItem(limit: "10")
struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(showFilter:.constant(true),
                   filterItem: filterItem_,
                   limit: 10,
                   scaleDisp: ["LARGE":true,"MEDIUM":true,"SMALL":true,"UNIV":true,"SPECIAL":true,"BM":true])
        ScaleFilterView(libraryKinds: "LARGE")
    }
}
