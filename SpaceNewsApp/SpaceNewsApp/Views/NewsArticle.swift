//
//  NewsArticle.swift
//  SpaceNewsApp
//
//  Created by Ezgi Karahan on 2.10.2023.
//

import SwiftUI
import CachedAsyncImage  ///daha önceden yüklediğim bu paketi import ettim.

struct NewsArticle: View {
    
    //MARK: PROPERTIES
    let title : String
    let imageUrl: String
    let siteName: String
    let summary: String
    
    //MARK: BODY
    var body: some View {
        VStack(alignment: .leading){
            Text(siteName)
                .foregroundColor(.blue)
                .italic()
            
            /**
             Bu kod, bir asenkron resmin yüklenmesini yönetiyor ve yükleme sırasında bir yer tutucu gösteriyor. Eğer resim yüklenirse, resim düzeltilir ve ekranda gösterilir. Eğer yüklenmezse, bir yer tutucu gösterilir.
             */
            HStack(alignment: .center){
                CachedAsyncImage(url: URL(string: imageUrl), transaction: Transaction(animation: .easeInOut)) { phase in ///phase in bir kapanış (closure) bloğunu başlatır. CachedAsyncImage bileşeni yüklenirken çalıştırılır ve phase adlı bir parametre alır.
                    if let image = phase.image{ ///Bu, phase içindeki resmin nil olup olmadığını kontrol eder.
                        image ///Eğer nil değilse, bu durumda image adlı bir değişkene atanır. Bu, resmin başarıyla yüklendiği durumu temsil eder.
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .transition(.opacity)
                    } else{
                        HStack{///Eğer phase.image nil ise, bu kısım çalışır. Yani, resim yüklenmediği durumu temsil eder.Burada, bir yer tutucu (placeholder) oluşturuluyor
                            
                        }
                            // Place holder
                    }//: else
                    
                }
            }
            Text(title)
                .font(.headline)
                .padding(8)
            
            Text(summary)
                .lineLimit(6)
                .font(.body)
                .padding(8)
        }
    }
}

//MARK: PREVIEW
struct NewsArticle_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticle(title: "Code Palace", imageUrl: "...", siteName: "CodePalace Youtube", summary: "Check out Code Palace for more cool tutorials.")
    }
}
