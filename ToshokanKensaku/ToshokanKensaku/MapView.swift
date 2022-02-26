//
//  MapView.swift
//  ToshokanKensaku
//
//  Created by 国生将弥 on 2022/02/18.
//

import SwiftUI
import MapKit
import SafariServices

//スポットの構造体
struct Spot:Identifiable{
    let id = UUID()
    let name:String
    let category:String
    let urlStr:String
    let latitude:Double
    let longitude:Double
    var coordinate:CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView: View {
    //図書館リスト
    @StateObject var searcher = LibrarySearcher()
    
    //フィルターの吹き出しの表示の有無
    @State var showFilter:Bool = false
    //フィルターの条件をまとめるクラス
    @StateObject var filterItem = FilterItem(limit: "10")
    
    //managerの更新を観測する
    @ObservedObject var manager = LocationManager()
    //ユーザートラッキングモード:追従
    @State var trackingMode = MapUserTrackingMode.follow
    //図書館リストのシートの表示有無
    @State var showLibraryList:Bool = false
    
    
    //調べたい書籍のISBN
    @State var isbnCode:String = ""
    //書籍の貸出状況リスト
    //未実装
    
    var body: some View {
        
        ZStack{
            VStack{
                Map(coordinateRegion: $manager.region,
                    showsUserLocation: true,
                    userTrackingMode: $trackingMode,
                    annotationItems: searcher.spotList,
                    annotationContent: {spot in
                    MapAnnotation(coordinate: spot.coordinate,
                                  anchorPoint: CGPoint(x: 0.5, y: 0.5),
                                  content: {
                        //フィルタリング
                        if filterItem.scaleDisp[spot.category]!{
                            LibraryAnnotationView(spot: spot)
                        }
                    })
                })//Map
            }//ZStack
            
            VStack{
                HStack{
                    Spacer()
                    //絞り込み画面遷移ボタン
                    Button(action: {
                        self.showFilter.toggle()
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("Color2"))
                                .frame(width: 60, height: 60)
                            Text("▼")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                        }//ZStack
                    })//絞り込み画面遷移ボタン
                        .popover(isPresented: self.$showFilter, content: {
                            FilterView(showFilter: self.$showFilter,
                                       filterItem: self.filterItem,
                                       limit: Int(self.filterItem.limit)!,
                                       scaleDisp: self.filterItem.scaleDisp)
                        })
                    //図書館を探すボタン
                    Button(action: {
                        //現在地近くの図書館を検索
                        self.searcher.search(latitude: String(self.manager.region.center.latitude),
                                             longitude: String(self.manager.region.center.longitude),
                                             limit:self.filterItem.limit)
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("Color2"))
                                .frame(width: 250, height: 60)
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text("図書館を探す")
                                    .font(.title)
                            }.foregroundColor(.white)
                        }//ZStack
                    })//図書館を探すボタン
                }//HStack
                .padding().padding(.top,30)
                Spacer()
                HStack{
                    Spacer()
                    //リストを表示ボタン
                    Button(action: {
                        self.trackingMode = MapUserTrackingMode.none
                        if self.searcher.resultLibrarys != nil{
                            self.showLibraryList.toggle()
                        }
                    }, label: {
                        ZStack{
                            if self.searcher.resultLibrarys == nil{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.gray)
                                    .frame(width: 200, height: 60)
                                
                            }else{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("Color2"))
                                    .frame(width: 200, height: 60)
                                
                            }
                            Text("リストを表示")
                                .font(.title)
                                .foregroundColor(.white)
                        }//ZStack
                    })//リストを表示ボタン
                        .halfSheet(isPresented: self.$showLibraryList, sheet: {
                            Color(.white)
                            //キーボードを閉じれるようにする
                                .onTapGesture {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                                    to: nil, from: nil, for: nil)
                                }
                            VStack{
                                Button(action: {
                                    self.showLibraryList.toggle()
                                }, label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("Color2"))
                                            .frame(width: 200, height: 30)
                                        Text("閉じる")
                                            .font(.title3)
                                            .foregroundColor(.white)
                                    }//ZStack
                                }).padding()
                                HStack{
                                    TextField("書籍のISBNを入力(未実装)",text: self.$isbnCode)
                                        .frame(width: 150)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                    //調べるボタン
                                    Button(action: {
                                        //ISBNからほんの貸出状況を検索(未実装)
                                        print(self.isbnCode)
                                    }, label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color("Color2"))
                                                .frame(width: 80, height: 30)
                                            Text("調べる")
                                                .font(.title3)
                                                .foregroundColor(.white)
                                        }//ZStack
                                    })//調べるボタン
                                }//HStack
                                ZStack{
                                    if self.searcher.resultLibrarys != nil{
                                        LibraryListView(manager: self.manager,
                                                        spotList: self.searcher.spotList,
                                                        libraryList: self.searcher.resultLibrarys,
                                                        filterItem: self.filterItem)
                                        
                                    }
                                }//ZStack
                            }//VStack
                        }, onEnd: {return})//sheet
                    //矢印(追従モード切り替え)ボタン
                    Button(action: {
                        //現在地から図書館を探す、または、追従モード切り替えで
                        //『Modifying state during view update, this will cause undefined behavior.』が出る
                        self.trackingMode = MapUserTrackingMode.follow
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("Color2"))
                                .frame(width: 60, height: 60)
                            Image(systemName: "location.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }//ZStack
                    })//Button
                }//HStack
                .padding()
            }//VStack
        }.ignoresSafeArea()//ZStack 
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewInterfaceOrientation(.portrait)
    }
}
