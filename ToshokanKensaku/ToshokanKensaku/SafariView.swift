//
//  SafariView.swift
//  ToshokanKensaku
//
//  Created by 国生将弥 on 2022/02/20.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    var urlStr:String
    func makeUIViewController(context: Context) -> SFSafariViewController {
        if let url = URL(string:  urlStr){
            
            return SFSafariViewController(url: url)
        }else{
            return SFSafariViewController(url: URL(string: "https://www.apple.com/jp/")!)
        }
    }
    
    func updateUIViewController(_ uiViewController:  SFSafariViewController, context: Context) {
        
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(urlStr: "https://www.youtube.com/")
    }
}
