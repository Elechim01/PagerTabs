//
//  Home.swift
//  Home
//
//  Created by Michele Manniello on 09/09/21.
//

import SwiftUI

struct Home: View {
    
//  Currenttab.....
    @State var currentSelection: Int = 0
    var body: some View {
        PagerTabView(tint: .black, selection: $currentSelection) {
            Image(systemName: "house.fill")
                .pageLabel()
            Image(systemName: "magnifyingglass")
                .pageLabel()
            Image(systemName: "person.fill")
                .pageLabel()
            Image(systemName: "gearshape")
                .pageLabel()
        } content: {
            Color.red
                .pageView(ignoresSafeArea: true, edges: .bottom)
            Color.green
                .pageView(ignoresSafeArea: true, edges: .bottom)
            Color.yellow
                .pageView(ignoresSafeArea: true, edges: .bottom)
            Color.purple
                .pageView(ignoresSafeArea: true, edges: .bottom)
        }
        .padding(.top)
        .ignoresSafeArea(.container, edges: .bottom)

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
