//
//  APIClient.swift
//  SpaceNewsApp
//
//  Created by Ezgi Karahan on 2.10.2023.

// API endpoint: https://api.spaceflightnewsapi.net/v3/articles

import Foundation

///ilk olarak bir veri sınıfı oluşturmam gerekiyor.
struct SpaceData : Codable, Identifiable {
    var id: Int
    var title: String
    var url: String
    var imageUrl: String
    var newsSite: String
    var summary: String
    var publishedAt: String
}

/** @MainActor özelliği, bu sınıfın ana iş parçacığı (main thread) üzerinde çalışması gerektiğini belirtiyor. Ana iş parçacığı, bir uygulamanın kullanıcı arayüzünün işlendiği ve güncellendiği yerdir. Bu nedenle, SpaceAPI sınıfının işlevselliği büyük olasılıkla ana iş parçacığına özgüdür ve bu iş parçacığında çalışmalıdır.
 observable object = bu sınıfın bir veri modeli olduğunu ve bir swiftUI uygulamasında kullanıldıgını, değişikliklerin gölemlenebilir olduğunu anlatır.
 **/
@MainActor class SpaceAPI : ObservableObject {
    @Published var news: [SpaceData] = []   ///@Published özelliği, bu diziye yapılan herhangi bir değişikliği gözlemlenebilir hale getirir.
    
    ///VERİ ALMA FONKSİYONU
    /**
     Guard let url = --> bir URL oluşturma işlemi gerçekleştirir, eger bu işlem başarısız olursa, yeni url oluşturulamazsa --> else --> fonksiyon sonlanır.
     **/
    func getData(){
        guard let url = URL(string: "https://api.spaceflightnewsapi.net/v3/articles?_limit=10")
        else{
            return
        }
        
  /**
   URLSession.shared.dataTask(with: url) { ... } --> bu satır belirtilen urlden veri almak için asenkron işlem (task) başlatır.
   
   guard let data = data else { -->  Bu satır, alınan verinin nil olup olmadığını kontrol eder. Eğer veri yoksa, yani alınan veri nil ise, bu durumda bir hata oluşmuş demektir.
   */
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data
            else { ///veri alınamazsa durumu
                let tempError = error!.localizedDescription
                DispatchQueue.main.async { ///veri alımında hata olursa gerçekleşen işlemler.
                    self.news = [SpaceData(id: 0, title: tempError, url: "Error", imageUrl: "Error", newsSite: "Error", summary: "Try swiping down to refresh as soon as you have internet.", publishedAt: "Error")]
                    
                }
                return
            }//: else
            
            
/**Bu satır, alınan veriyi JSON formatından Swift nesnelerine dönüştürür. JSONDecoder() sınıfı, JSON verisini işlemek için kullanılır. decode(_:from:) metodu ile JSON verisi belirtilen türdeki Swift nesnelerine dönüştürülür. Eğer dönüştürme işlemi başarısız olursa, bu durumda bir hata alınacaktır.**/
            let spaceData = try! JSONDecoder().decode([SpaceData].self, from: data)
            
/**Bu bölüm, veri başarılı bir şekilde alındığında gerçekleşen işlemleri içerir. spaceData adlı dizi, alınan JSON verisinin dönüştürülmüş halini temsil eder. Bu dizi, news dizisine atanır ve arayüz güncellenir. DispatchQueue.main.sync bloğu, bu işlemin ana iş parçacığında gerçekleştirilmesini sağlar. Ayrıca, alınan haberlerin sayısı da ekrana yazdırılır.**/
            DispatchQueue.main.sync {
                print("Loaded newdata successfully. Articles: \(spaceData.count)")
                self.news = spaceData
            }
        }.resume()
    }//: FUNC
}
