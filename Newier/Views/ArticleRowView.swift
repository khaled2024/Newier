//
//  ArticleRowView.swift
//  Newier
//
//  Created by KhaleD HuSsien on 31/01/2023.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: article.imageURL){phase in
                switch phase{
                case .empty:
                    HStack{
                        Spacer()
                        ProgressView {
                            Text("Loading")
                                .font(.system(size: 14).bold())
                        }
                        Spacer()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    HStack{
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large)
                        Spacer()
                    }
                @unknown default:
                    fatalError()
                }
            }
            .frame(minHeight: 200, maxHeight: 300)
            .background(Color.gray.opacity(0.3))
            .clipped()
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .lineLimit(3)
                HStack {
                    Text(article.captionText)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "bookmark")
                    }
                    .buttonStyle(.bordered)
                    .clipShape(Circle())
                    Button {
                        presentShareSheet(url: article.articleURL)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                    .clipShape(Circle())
                    
                }
                
            }
            .padding([.horizontal,.bottom])
        }
    }
}
extension View{
    func presentShareSheet(url: URL){
        let acticityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        // to present this acticity view controller...
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController?.present(acticityVC, animated: true)
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            List {
                ArticleRowView(article: Article.previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
    }
}
