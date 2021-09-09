//
//  PagerHelper.swift
//  PagerHelper
//
//  Created by Michele Manniello on 09/09/21.
//

import SwiftUI

// custom View Builder...

struct PagerTabView<Content :View, Label : View>: View {
    
    var content: Content
    var label : Label
//    Tint...
    var tint: Color
//    Selection...
    @Binding var selection: Int
    
    init(tint: Color,selection: Binding<Int>,@ViewBuilder labels : @escaping ()->Label,@ViewBuilder content: @escaping ()->Content){
        self.content = content()
        self.label = labels()
        self.tint = tint
        self._selection = selection
    }
//    Offset for Page Scroll...
    @State var offset : CGFloat = 0
    @State var maxTabs : CGFloat = 0
    @State var tabOffset : CGFloat = 0
    var body: some View {
        VStack(spacing:0){
            HStack(spacing: 0){
                label
            }
//            For Tab to change tab..
            .overlay(
                HStack(spacing: 0){
                    ForEach(0..<Int(maxTabs),id: \.self){ index in
                        Rectangle()
                            .fill(Color.black.opacity(0.01))
                            .onTapGesture {
//                                Changing Offset...
//                                Based on Index...
                                let newOffset = CGFloat(index) * getScreenBounds().width
                                self.offset = newOffset
                            }
                    }
                }
            )
            .foregroundColor(tint)
//            Indicator....
            Capsule()
                .fill()
                .frame(width: maxTabs == 0 ? 0 : (getScreenBounds().width / maxTabs), height: 5)
                .padding(.top,10)
                .frame(maxWidth: .infinity,alignment: .leading)
                .offset(x: tabOffset)
            OffsetPageTabView(selction: $selection,offsett: $offset) {
                HStack(spacing: 0){
                    content
                }
//                Getting How many tabs are there by getting the total Content Size...
                .overlay(
                    GeometryReader{proxy in
                        Color.clear
                            .preference(key: TabPreferencekey.self, value: proxy.frame(in: .global))
                    }
                )
//                When value Changes...
                .onPreferenceChange(TabPreferencekey.self) { proxy in
                    let minx = -proxy.minX
                    let maxWidth = proxy.width
                    let screenWidth = getScreenBounds().width
                    let maxTabs = (maxWidth / screenWidth).rounded()
//                    Gerring Tab Offset...
                    let progress = minx / screenWidth
                    let tabOffset = progress * (screenWidth / maxTabs)
                    self.tabOffset = tabOffset
                    
                    self.maxTabs = maxTabs
                }
            }
        }
    }
}

struct PagerHelper_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Geometry preference...
struct TabPreferencekey:PreferenceKey {
    static var defaultValue: CGRect = .init()
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


// Extending View for pageLabel and PageView Modifier....
extension View{
    func pageLabel() -> some View{
//        Just Filling all Empty Space..
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
//    Modifications for SafeArea Inoring...
//  Same For PageView....
    func pageView(ignoresSafeArea: Bool = false, edges: Edge.Set = []) -> some View{
//        Just Filling all Empty Space..
        self
            .frame(width: getScreenBounds().width, alignment: .center)
            .ignoresSafeArea(ignoresSafeArea ? .container : .init(),edges: edges)
    }
    
//  Getting Screen Bounds...
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
