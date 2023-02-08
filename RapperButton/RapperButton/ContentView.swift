//
//  ContentView.swift
//  RapperButton
//
//  Created by Ganesh Raju Galla on 07/02/23.
//

import SwiftUI

struct ContentView: View {
    //MARK: - Varibles
    @State private var offsetOne:CGSize = .zero
    @State private var offsetTwo:CGSize = .zero
    @State private var isCollapsed:Bool = false
    
    //MARK: - Body
    var body: some View {
        ZStack{
            backgroundView()
            rapperButton()
        }
    }
}

extension ContentView{
    private func backgroundView() -> some View{
        Rectangle()
            .fill(.linearGradient(colors: [.black.opacity(0.9),.black,.black.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
    }
    
    private func rapperButton() -> some View{
        ZStack{
            Rectangle()
                .fill(.linearGradient(colors: [.purple,.pink], startPoint: .top, endPoint: .bottom))
                .mask {
                    Canvas{context ,size in
                        context.addFilter(.alphaThreshold(min: 0.8,color: .black))
                        context.addFilter(.blur(radius: 8))
                        
                        context.drawLayer { ctx in
                            for index in [1,2,3]{
                                if let resolvedView = context.resolveSymbol(id: index){
                                    ctx.draw(resolvedView,at: CGPoint(x: size.width/2, y: size.height/2))
                                }
                            }
                        }
                    }symbols: {
                        symbol(diameter: 120)
                            .tag(1)
                        
                        symbol(offset: offsetOne)
                            .tag(2)
                        
                        symbol(offset: offsetTwo)
                            .tag(3)
                    }
                }
            cancelButton()
                .blendMode(.softLight)
                .rotationEffect(Angle(degrees: isCollapsed ? 90 : 45))
            
            settingsButton()
                .offset(offsetOne)
                .blendMode(.softLight)
                .opacity(isCollapsed ? 1 : 0)
            
            homeButton()
                .offset(offsetTwo)
                .blendMode(.softLight)
                .opacity(isCollapsed ? 1 : 0)
        }
        .frame(width: 120,height: 500)
        .contentShape(Circle())
    }
    
    private func symbol(offset:CGSize = .zero,diameter:CGFloat = 75) -> some View{
        Circle()
            .frame(width: diameter,height: diameter)
            .offset(offset)
    }
    
    private func homeButton() -> some View{
        ZStack{
            Image(systemName: "house")
                .resizable()
                .frame(width: 25,height: 25)
        }
        .frame(width: 65,height: 65)
    }
    
    private func cancelButton() -> some View{
        ZStack{
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 35,height: 35)
                .aspectRatio(.zero, contentMode: .fit)
                .contentShape(Circle())
        }
        .frame(width: 100,height: 100)
        .contentShape(Rectangle())
        .onTapGesture {
            debugPrint("-- Cancel Tapped --")
            withAnimation {
                isCollapsed.toggle()
            }
            
            withAnimation(.interactiveSpring(response: 0.35,dampingFraction: 0.8,blendDuration: 0.1).speed(0.5)){
                offsetOne = isCollapsed ? CGSize(width: 0, height: -120) : .zero
                offsetTwo = isCollapsed ? CGSize(width: 0, height: -205) : .zero
            }
        }
    }
    
    private func settingsButton() -> some View{
        ZStack{
            Image(systemName: "gear")
                .resizable()
                .frame(width: 28,height: 28)
        }
        .frame(width: 65,height: 65)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
