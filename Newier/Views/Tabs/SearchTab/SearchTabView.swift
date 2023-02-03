//
//  SearchTabView.swift
//  Newier
//
//  Created by KhaleD HuSsien on 02/02/2023.
//

import SwiftUI

struct SearchTabView: View {
    @StateObject var articleSearchVM = ArticleSearchViewModel.shared
    var body: some View {
        NavigationView{
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $articleSearchVM.searchQuery, suggestions: {
            suggestionsView
        })
        .onChange(of: articleSearchVM.searchQuery){ newValue in
            if newValue.isEmpty{
                articleSearchVM.phase = .empty
            }
        }
        .onSubmit(of: .search, search)
    }
    private var articles: [Article]{
        if case .success(let articles) = articleSearchVM.phase{
            return articles
        }else{
            return []
        }
    }
    //MARK: - ViewBuilder & Functions
    @ViewBuilder
    private var overlayView: some View{
        switch articleSearchVM.phase{
        case .empty:
            if !articleSearchVM.searchQuery.isEmpty{
                ProgressView()
            }else if !articleSearchVM.history.isEmpty{
                SearchHistoryListView(searchVM: articleSearchVM) { newValue in
                    print(newValue)
                    articleSearchVM.searchQuery = newValue
                    search()
                }
            }
            else{
                EmptyPlaceholderView(text: "Type your query to search from API", image: Image(systemName: "magnifyingglass"))
            }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
            
        case .failure(let error):
            RetryView(text: error.localizedDescription,retryAction: search)
        default:
            EmptyView()
        }
    }
    @ViewBuilder
    private var suggestionsView: some View{
        ForEach(["Swift","Al-ahly","iOS 16","BTC","Covid-19"], id: \.self){text in
            Button {
                articleSearchVM.searchQuery = text
            } label: {
                Text(text)
            }
        }
    }
    private func search(){
        let searchQuery = articleSearchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty{
            articleSearchVM.addHistory(searchQuery)
        }
        Task{
            await articleSearchVM.searchArticles()
        }
    }
}
struct SearchTabView_Previews: PreviewProvider {
    @StateObject static var bookmarkVM = ArticleBookmarkViewModel.shared
    static var previews: some View {
        SearchTabView()
            .environmentObject(bookmarkVM)
    }
}
