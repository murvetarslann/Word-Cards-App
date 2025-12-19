# WordCardsApp
Swift UIKit ile MVVM yapısını ve API kullanarak geliştirdiğim, ingilizce kelime ezberleme yöntemi için geliştirilmiş eğlenceli kart uygulamasıdır.

## Uygulamadaki Özellikler:

- Kullanıcı karta dokunduğunda kart arkasını döner ve kelimenin Türkçe/İngilizce karşılığını gösterir.
- Kart sağa veya sola kaydırıldığında animasyonlu bir şekilde ekrandan çıkar ve sıradaki yeni kelime gelir.
- Liste bittiğinde kelimeler otomatik olarak karıştırılır (shuffle) ve tekrar kullanıcıya sunulur.
- ** Çift Kayıt Engelleme ** özelliği ile kullanıcı yeni bir kelime eklemek istediğinde, uygulama önce arka planda mevcut listeyi kontrol eder.
Eğer kelime zaten listede varsa, API'ye gereksiz istek atılmaz ve kullanıcı "Bu kelime zaten listenizde mevcut" şeklinde uyarılır.
- ** Otomatik Düzenleme ** ile kullanıcı kelimeyi yazarken sonuna yanlışlıkla boşluk bıraksa bile (Trim), sistem bunu algılar ve temizleyerek kaydeder.
- ** Karanlık Mod ** uyumu ile uygulama, cihazın tema ayarlarına uyum sağlar. Kartların üzerindeki metinler, arka plan rengine göre (siyah/beyaz) otomatik olarak görünürlüğünü korur.
