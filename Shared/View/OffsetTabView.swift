//
//  OffsetTabView.swift
//  OffsetTabView
//
//  Created by Michele Manniello on 09/09/21.
//

import SwiftUI

//See My Animated Indicator video...
//Custom View that will return offset for pagign control...
struct OffsetPageTabView<Content: View>: UIViewRepresentable {
    
    
    var content : Content
    @Binding var offset : CGFloat
    @Binding var selction:  Int
    
    func makeCoordinator() -> Coordinator {
        return OffsetPageTabView.Coordinator(parent: self)
    }
    init(selction: Binding<Int>,offsett : Binding<CGFloat>,@ViewBuilder conent: @escaping ()-> Content ){
        self.content = conent()
        self._offset = offsett
        self._selction = selction
    }
    func makeUIView(context: Context) -> UIScrollView {
            let scrollview = UIScrollView()
//        Extracting SwiftUi View and embedding into UIKit Scrollview...
        let hostview = UIHostingController(rootView: content)
        hostview.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostview.view.topAnchor.constraint(equalTo: scrollview.topAnchor),
            hostview.view.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            hostview.view.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            hostview.view.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
            
//            if you are using vertical Paging...
//            then dont declare height constraint...
            hostview.view.heightAnchor.constraint(equalTo: scrollview.heightAnchor),
        ]
        scrollview.addSubview(hostview.view)
        scrollview.addConstraints(constraints)
//        enable Paging..
        scrollview.isPagingEnabled = true
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
//        Setting Delgate..
        scrollview.delegate = context.coordinator
        return scrollview
    }
    func updateUIView(_ uiView: UIScrollView, context: Context) {
//        need to update only when offset changed manually...
//        just check the current and scrollView offset...
        let currentOffset = uiView.contentOffset.x
        if currentOffset != offset{
            print("updating")
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
        
    }
//    Pager Offset..
    class Coordinator: NSObject,UIScrollViewDelegate{
        var parent : OffsetPageTabView
        init(parent : OffsetPageTabView) {
            self.parent = parent
        }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
//            Safer side updatin selection on scrolll..
            let maxSize = scrollView.contentSize.width
            let currentSelection = (offset / maxSize).rounded()
            parent.selction = Int(currentSelection)
            parent.offset = offset
        }
    }
}
