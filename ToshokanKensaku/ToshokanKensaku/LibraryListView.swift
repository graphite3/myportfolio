//
//  LibraryListView.swift
//  ToshokanKensaku
//
//  Created by 国生将弥 on 2022/02/21.
//

import SwiftUI
import MapKit

struct LibraryUnitView: View{
    var resultLibrary:ResultLibrary
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Color"))
            HStack{
                ZStack{
                    Rectangle()
                        .fill(Color("Color"))
                        .frame(width: 120)
                    switch resultLibrary.category{
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
                            .frame(width: 70, height: 70)
                            .foregroundColor(.black)
                    }
                }
                VStack{
                    Text("\(resultLibrary.formal)")
                        .font(.title2)
                        .frame(maxWidth:.infinity,alignment: .leading)
                    Text("〒 \(resultLibrary.post)")
                        .font(.subheadline)
                        .frame(maxWidth:.infinity,alignment: .leading)
                    Text("\(resultLibrary.address)")
                        .font(.subheadline)
                        .frame(maxWidth:.infinity,alignment: .leading)
                    HStack{
                        Image(systemName: "phone.fill")
                        Text("\(resultLibrary.tel)")
                            .font(.subheadline)
                            .frame(maxWidth:.infinity,alignment: .leading)
                    }//HStack
                }//VStack
                Spacer()
            }//HStack
            .padding()
        }//VStack
    }
}


struct LibraryListView: View {
    var manager:LocationManager
    var spotList:[Spot]?
    var libraryList:[ResultLibrary?]?
    var filterItem:FilterItem
    var body: some View {
        List{
            if libraryList != nil{
                    ForEach(0..<libraryList!.count,id:\.self){num in
                        //表示する図書館をフィルタリング
                        if self.filterItem.scaleDisp[self.libraryList![num]!.category]!{
                            ZStack{
                                Button(action: {
                                    self.manager.region.center = CLLocationCoordinate2D(
                                        latitude: spotList![num].latitude,
                                        longitude: spotList![num].longitude)
                                }, label: {
                                    LibraryUnitView(resultLibrary: self.libraryList![num]!)
                                    
                                })//Button
                                    .foregroundColor(.black)
                            }//ZStack
                            
                        }
                    }//ForEach
            }
        }//ScrollView
        .frame(maxWidth:.infinity,maxHeight: .infinity)
    }
}

let LibraryList:[ResultLibrary] = [ResultLibrary(systemid: "None",systemname: "None",libkey: "None",formal: "None",
                                                 url_pc: "None",address: "None",pref: "None",city: "None",post: "000-0000",
                                                 tel: "0000-000-000",geocode:"0.0,0.0",category: "BM")]

let SpotList:[Spot] = [Spot(name: "None", category: "None", urlStr: "None", latitude: 0.0, longitude: 0.0)]

let filterItem = FilterItem(limit: "10")
struct LibraryListView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryListView(manager: LocationManager(), spotList: SpotList, libraryList: LibraryList,filterItem: filterItem)
        
        LibraryUnitView(resultLibrary: LibraryList[0])
         
    }
}

