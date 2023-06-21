//
//  ContentView.swift
//  A_16_Dynamic Animated Tab Indicator
//
//  Created by Kan Tao on 2023/6/21.
//

import SwiftUI

struct ContentView: View {
    @State var current: Tab = sample_datas.first!
    @State var offset:CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let screenSize = proxy.size
            
            ZStack(alignment: .top) {

                TabView(selection: $current) {
                    ForEach(sample_datas, id: \.id) { tab in
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            Image(tab.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipped()
                        }
                        .ignoresSafeArea()
                        .offsetX { value in
                            if current == tab {
                                offset = value - (screenSize.width * CGFloat(indexOf(tab: tab)))
                            }
                        }
                        .tag(tab)
                    }
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
                

                // MARK: Building Custom Header With Dynamic Tabs
                DynamicTabHeader(size: screenSize)
            }
            .frame(width: screenSize.width, height: screenSize.height)
        }
    }
    
    
    
    @ViewBuilder
    func DynamicTabHeader(size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Dynamic Tabs")
                .font(.title.bold())
                .foregroundColor(.white)
            
            // MARK: Dynamic Tabs
            DynamicTabsType1(size: size)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background {
            // TODO: 背景色模糊效果
            Rectangle()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .ignoresSafeArea()
        }
    }
    
    func tabOffset(size: CGSize, padding: CGFloat) -> CGFloat {
        return (-offset / size.width) * ((size.width - padding) / CGFloat(sample_datas.count))
    }
    
    
    
    func indexOf(tab: Tab) -> Int {
        let index = sample_datas.firstIndex { t in
            t.id == tab.id
        } ?? 0
        return index
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension ContentView {
    @ViewBuilder
    func DynamicTabsType1(size: CGSize) -> some View {
        HStack(spacing: 0) {
            ForEach(sample_datas) { tab in
                Text(tab.name)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
        }
        .background(alignment: .bottomLeading) {
            Capsule()
                .fill(.white)
                .frame(width: (size.width - 30) / CGFloat(sample_datas.count),height: 4)
                .offset(y: 12)
                .offset(x: tabOffset(size: size, padding: 30))
        }
    }
}

