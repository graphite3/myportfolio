//
//  HalfSheet.swift
//  ToshokanKensaku
//
//  Created by 国生将弥 on 2022/02/23.
//
import SwiftUI

//ハーフシートができるように拡張
extension View {
  func halfSheet<Sheet: View>(isPresented: Binding<Bool>,@ViewBuilder sheet: @escaping () -> Sheet,onEnd: @escaping () -> Void) -> some View {
    return self.background(HalfSheetViewController(sheet: sheet(),isShow: isPresented,onClose: onEnd)
      )
  }
}


struct HalfSheetViewController<Sheet: View>: UIViewControllerRepresentable {
    var sheet: Sheet
    @Binding var isShow: Bool
    var onClose: () -> Void
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ viewController: UIViewController,context: Context) {
        if isShow {
            let sheetController = CustomHostingController(rootView: sheet)
            sheetController.presentationController!.delegate = context.coordinator
            viewController.present(sheetController, animated: true)
        } else {
            viewController.dismiss(animated: true) { onClose() }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetViewController
        
        init(parent: HalfSheetViewController) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.isShow = false
        }
    }
    
    //sheetの大きさなどを変更
    class CustomHostingController<Content: View>: UIHostingController<Content> {
        override func viewDidLoad() {
            super.viewDidLoad()
            if let sheet = self.sheetPresentationController {
                sheet.detents = [.medium(),]
                sheet.preferredCornerRadius = 30
            }
        }
    }
}
