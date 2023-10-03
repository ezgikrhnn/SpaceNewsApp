//
//  NewsView.swift
//  SpaceNewsApp
//
//  Created by Ezgi Karahan on 2.10.2023.
//

import SwiftUI

struct NewsView: View {
    
    //MARK: PROPERTIES
    @EnvironmentObject var data : SpaceAPI
    @Environment(\.openURL) var openURL
    private var textWidth = 300.0
    
    
    var body: some View {
        List{
            ForEach(data.news){ news in
                NewsArticle(title: news.title, imageUrl: news.imageUrl, siteName: news.newsSite, summary: news.summary)
                    .onTapGesture {
                        openURL(URL(string: news.url)!)
                    }
            }
        }
        .refreshable {
            data.getData()
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        let spaceAPI = SpaceAPI()
        return NewsView()
                .environmentObject(spaceAPI)
    }
}
