# app_toplanti
 
## Kurumsal Toplantı Bildirim Ağı
Bu mobil uygulama, çeşitli kurumlarda çalışan kullanıcıların, kurumlarına özel alan kodları ile güvenli bir şekilde kayıt olup toplantı oluşturma, görüntüleme ve yönetme işlemlerini gerçekleştirebileceği bir platformdur. Flutter ile geliştirilen uygulama, Firebase servisleri kullanılarak kimlik doğrulama (authentication), yetkilendirme (authorization) ve veritabanı işlemleriyle desteklenmiştir.

🎯
## Proje Amacı
Kurumsal düzeyde, farklı departman veya şirket çalışanlarının kendi kurumlarına özel bir ağ üzerinden haberleşmesini ve toplantılarını yönetmesini sağlamak.
Her kurumun kendine özel bir alan kodu bulunur ve kullanıcılar bu kodu kullanarak yalnızca kendi kurumları bünyesinde toplantılar oluşturabilir ya da görüntüleyebilir. Bu sayede bilgi güvenliği korunur ve karmaşa önlenir.

🔑
## Kimlik Doğrulama & Kayıt İşlemleri
- Uygulamada Firebase Authentication kullanılmıştır.

- Kullanıcılar, e-posta ve şifre kullanarak kayıt olabilir.

- Kayıt sırasında, kurum kodunu girerek doğrulama yapılır ve kullanıcı yalnızca kendi kurumundaki toplantıları görebilir.

- Giriş ekranı, kullanıcı dostu bir arayüzle desteklenmiştir.

🔒 
## Şifremi Unuttum Özelliği
- Kullanıcılar “Şifremi unuttum” seçeneği ile e-posta adreslerine doğrulama kodu alabilir.

- Gönderilen kod ile dinamik parola sıfırlama işlemi gerçekleştirilir.

- Güvenli ve hızlı şekilde parola yenileme sağlanır.

🏠
## Ana Sayfa – Toplantı Listesi
- Kullanıcı giriş yaptıktan sonra ana sayfada, kurumuna ait tüm aktif toplantılar listelenir.

- Toplantılar, tarihe göre sıralanır ve filtreleme yapılabilir.

- Zamanı geçmiş toplantılar otomatik olarak pasif duruma geçer ve listede farklı bir şekilde (gri veya silik) gösterilir.

🧾
## Toplantı Detayları
Her toplantının detay sayfasında şu bilgiler bulunur:

- 📍 Toplantı konumu

- 🧑‍💼 Toplantıyı oluşturan kişinin adı ve e-posta adresi

- 🕒 Tarih ve saat bilgisi

- 📝 Toplantıya ait açıklama ve detaylar

Bu sayede kullanıcılar toplantı hakkında tüm bilgilere tek ekrandan erişebilir.

🛠️
## Toplantı Oluşturma & Yetkilendirme
- Kullanıcılar, yeni bir toplantı oluşturabilir ve gerekli bilgileri girebilir.

- Bir toplantı yalnızca onu oluşturan kullanıcı tarafından silinebilir veya güncellenebilir.

- Firebase Firestore’daki veriler kullanıcı UID’lerine göre filtrelenerek güvenlik sağlanır.

- Başka kullanıcıların toplantılarına müdahale edilemez.

👤
## Profil Sayfası
- Drawer menüsü üzerinden erişilebilen bir Profil Sayfası bulunur.

- Bu ekranda, kullanıcının adı, soyadı, e-posta adresi ve bağlı olduğu kurum gibi bilgiler gösterilir.

- Gelecekte bu ekran üzerinden profil düzenleme gibi işlemler de eklenebilir.

🧰 
## Kullanılan Teknolojiler

### Teknoloji                               	Açıklama
    Flutter	                                  Mobil uygulama geliştirme framework'ü
    Firebase Auth	                            Kimlik doğrulama işlemleri için
    Firebase Firestore	                      Gerçek zamanlı veritabanı kullanımı
    Firebase Password Reset	                  Şifre sıfırlama süreci için
    Provider	                                Durum yönetimi (isteğe bağlı)

## Page
![Ekran görüntüsü 2025-04-26 033435](https://github.com/user-attachments/assets/4e9675c5-2e12-4bec-ac09-a78914c88bd8)


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
