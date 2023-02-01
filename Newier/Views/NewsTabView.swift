//
//  NewsTabView.swift
//  Newier
//
//  Created by KhaleD HuSsien on 02/02/2023.
//

import SwiftUI

struct NewsTabView: View {
    /// we want to init that ArticleViewModel once that why we use "StateObject" not "ObservedObject"...
    //MARK: - Proparties
    @StateObject var articleNewsNM = ArticleViewModel()
    private var articles: [Article]{
        if case let .success(articles) = articleNewsNM.phase{
            return articles
        }else{
            return []
        }
    }
    //MARK: - Body
    var body: some View {
        NavigationView{
            ArticleListView(articles: articles)
                .overlay(overlayView)
            /// if selectedCategory or token (Current Date) will fetch the "loadTask"
                .task(id: articleNewsNM.fetchTaskToken, loadTask)
                .refreshable {
                    refreshTask()
                }
                .navigationTitle(articleNewsNM.fetchTaskToken.category.text)
                .navigationBarItems(trailing: menu)
        }
    }
    //MARK: - ViewBuilders & Functions
    @ViewBuilder
    private var overlayView: some View{
        switch articleNewsNM.phase{
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No articles",image: nil)
        case .failure(let error):
            RetryView(text: error.localizedDescription) {
                /// Refresh the news API...
                refreshTask()
            }
        default:
            EmptyView()
        }
    }
    private func loadTask() async {
        await articleNewsNM.loadArticles()
    }
    private func refreshTask(){
        articleNewsNM.fetchTaskToken = FetchTaskToken(category: articleNewsNM.fetchTaskToken.category, token: Date())
    }
    private var menu: some View{
        Menu {
            Picker("Category", selection: $articleNewsNM.fetchTaskToken.category) {
                ForEach(Category.allCases) { category in
                    Text(category.text).tag(category)
                }
            }
        } label: {
            Image("filter")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25,alignment: .trailing)
                .imageScale(.small)
        }
    }
}

struct NewsTabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NewsTabView(articleNewsNM: ArticleViewModel(articles: Article.previewData))
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
        }
    }
}
