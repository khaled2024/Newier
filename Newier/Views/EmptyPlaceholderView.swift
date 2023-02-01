//
//  EmptyPlaceholderView.swift
//  Newier
//
//  Created by KhaleD HuSsien on 02/02/2023.
//

import SwiftUI

struct EmptyPlaceholderView: View{
    let text: String
    let image: Image?
    
    var body: some View{
        VStack(spacing: 8) {
            Spacer()
            if let image{
                image
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            Text(text)
            Spacer()
        }
    }
}

struct EmptyPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(text: "No Bookmark",image: Image(systemName: "bookmark"))
    }
}
