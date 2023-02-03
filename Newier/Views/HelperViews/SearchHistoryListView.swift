//
//  SearchHistoryListView.swift
//  Newier
//
//  Created by KhaleD HuSsien on 03/02/2023.
//

import SwiftUI

struct SearchHistoryListView: View {
    @ObservedObject var searchVM: ArticleSearchViewModel
    let onSubmit: (String)->()
    var body: some View {
        List{
            HStack{
                Text("Recently Searched")
                    .fontWeight(.semibold)
                Spacer()
                Button("Clear") {
                    searchVM.removeAllHistory()
                }
                .foregroundColor(.accentColor)
            }
            .listRowSeparator(.hidden)
            // list of History text...
            ForEach(searchVM.history,id: \.self) { history in
                Button(history) {
                    onSubmit(history)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        searchVM.removeHistory(history)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct SearchHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryListView(searchVM: ArticleSearchViewModel.shared, onSubmit: {_ in })
    }
}
