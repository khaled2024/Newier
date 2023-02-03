//
//  BookmarkTabView.swift
//  Newier
//
//  Created by KhaleD HuSsien on 02/02/2023.
//

import SwiftUI

struct BookmarkTabView: View {
    @EnvironmentObject private var articleBookmarkVM: ArticleBookmarkViewModel
    @State var searhText: String = ""
    var body: some View {
        let articles = self.articles
        NavigationView{
            ArticleListView(articles: articles)
                .overlay(
                    overlayView(isEmpty: articles.isEmpty)
                )
                .navigationTitle("Saved Articles")
        }
        .searchable(text: $searhText)
    }
    //MARK: - ViewBuilder
    private var articles: [Article]{
        if searhText.isEmpty{
            return articleBookmarkVM.bookmarks
        }
        return articleBookmarkVM.bookmarks
            .filter { article in
                article.title.lowercased().contains(searhText.lowercased()) ||
                article.descriptionText.lowercased().contains(searhText.lowercased())
            }
    }
    @ViewBuilder
    func overlayView(isEmpty: Bool)-> some View{
        if isEmpty{
            EmptyPlaceholderView(text: "No Saved Articles", image: Image(systemName: "bookmark"))
        }
    }
}

struct BookmarkTabView_Previews: PreviewProvider {
    @EnvironmentObject static var articleBookmarkVM: ArticleBookmarkViewModel
    static var previews: some View {
        BookmarkTabView()
            .environmentObject(articleBookmarkVM)
    }
}
