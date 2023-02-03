//
//  ArticleBookmarkViewModel.swift
//  Newier
//
//  Created by KhaleD HuSsien on 02/02/2023.

import Foundation
class ArticleBookmarkViewModel: ObservableObject{
    @Published private(set) var bookmarks: [Article] = []
    private let bookmarkStore = PlistDataStore<[Article]>(fileName: "bookmarks")
    
    static let shared = ArticleBookmarkViewModel()
    private init(){
        Task{
            await load()
        }
    }
    @MainActor
    private func load()async{
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    func isBookmarked(for article: Article)-> Bool{
        bookmarks.first {article.id == $0.id} != nil
    }
    func addBookmark(for article: Article){
        // لو هيا مش ف المفضلات هنكمل
        guard !isBookmarked(for: article) else{return}
        bookmarks.insert(article, at: 0)
        bookmarkUpdated()
    }
    func removeBookmark(for article: Article){
        //لو لما نيجي نحذف من المفضله ونلاقي نفس الid هنرج لانديكس بتاعها ونحذفها...
        guard let index = bookmarks.firstIndex(where: {article.id == $0.id})else{return}
        bookmarks.remove(at: index)
        bookmarkUpdated()
    }
    func bookmarkUpdated(){
        let bookmarks = self.bookmarks
        Task{
            await bookmarkStore.save(bookmarks)
        }
    }
}
