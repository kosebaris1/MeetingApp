# app_toplanti
#📅 **Kurumsal Toplantı Bildirim Ağı**
Bu mobil uygulama, çeşitli kurumlarda çalışan kullanıcıların, kurumlarına özel alan kodları ile güvenli bir şekilde kayıt olup toplantı oluşturma, görüntüleme ve yönetme işlemlerini gerçekleştirebileceği bir platformdur. Flutter ile geliştirilen uygulama, Firebase servisleri kullanılarak kimlik doğrulama (authentication), yetkilendirme (authorization) ve veritabanı işlemleriyle desteklenmiştir.

##🎯 **Proje Amacı**
Kurumsal düzeyde, farklı departman veya şirket çalışanlarının kendi kurumlarına özel bir ağ üzerinden haberleşmesini ve toplantılarını yönetmesini sağlamak.
Her kurumun kendine özel bir alan kodu bulunur ve kullanıcılar bu kodu kullanarak yalnızca kendi kurumları bünyesinde toplantılar oluşturabilir ya da görüntüleyebilir. Bu sayede bilgi güvenliği korunur ve karmaşa önlenir.

##🔑 **Kimlik Doğrulama & Kayıt İşlemleri**
Uygulamada Firebase Authentication kullanılmıştır.

- Kullanıcılar, e-posta ve şifre kullanarak kayıt olabilir.

- Kayıt sırasında, kurum kodunu girerek doğrulama yapılır ve kullanıcı yalnızca kendi kurumundaki toplantıları görebilir.

- Giriş ekranı, kullanıcı dostu bir arayüzle desteklenmiştir.

##🔒 **Şifremi Unuttum Özelliği**
Kullanıcılar “Şifremi unuttum” seçeneği ile e-posta adreslerine doğrulama kodu alabilir.

Gönderilen kod ile dinamik parola sıfırlama işlemi gerçekleştirilir.

Güvenli ve hızlı şekilde parola yenileme sağlanır.

##🏠 **Ana Sayfa – Toplantı Listesi**
Kullanıcı giriş yaptıktan sonra ana sayfada, kurumuna ait tüm aktif toplantılar listelenir.

Toplantılar, tarihe göre sıralanır ve filtreleme yapılabilir.

Zamanı geçmiş toplantılar otomatik olarak pasif duruma geçer ve listede farklı bir şekilde (gri veya silik) gösterilir.

##🧾 **Toplantı Detayları**
Her toplantının detay sayfasında şu bilgiler bulunur:

📍 Toplantı konumu

🧑‍💼 Toplantıyı oluşturan kişinin adı ve e-posta adresi

🕒 Tarih ve saat bilgisi

📝 Toplantıya ait açıklama ve detaylar

Bu sayede kullanıcılar toplantı hakkında tüm bilgilere tek ekrandan erişebilir.

##🛠️ **Toplantı Oluşturma & Yetkilendirme**
Kullanıcılar, yeni bir toplantı oluşturabilir ve gerekli bilgileri girebilir.

Bir toplantı yalnızca onu oluşturan kullanıcı tarafından silinebilir veya güncellenebilir.

Firebase Firestore’daki veriler kullanıcı UID’lerine göre filtrelenerek güvenlik sağlanır.

Başka kullanıcıların toplantılarına müdahale edilemez.

##👤 **Profil Sayfası**
Drawer menüsü üzerinden erişilebilen bir Profil Sayfası bulunur.

Bu ekranda, kullanıcının adı, soyadı, e-posta adresi ve bağlı olduğu kurum gibi bilgiler gösterilir.

Gelecekte bu ekran üzerinden profil düzenleme gibi işlemler de eklenebilir.

##🧰 **Kullanılan Teknolojiler**

**Teknoloji**                         	**Açıklama**
Flutter	                                  Mobil uygulama geliştirme framework'ü
Firebase Auth	                            Kimlik doğrulama işlemleri için
Firebase Firestore	                      Gerçek zamanlı veritabanı kullanımı
Firebase Password Reset	                  Şifre sıfırlama süreci için
Provider	                                Durum yönetimi (isteğe bağlı)


## Login Page
![Ekran görüntüsü 2025-01-16 191400](https://github.com/user-attachments/assets/008d0015-1cae-4356-bfa7-009d95566070)

## SignUp Page
![Ekran görüntüsü 2025-01-16 191745](https://github.com/user-attachments/assets/1b6fda64-ef0a-45a7-aae3-a9515f100df3)

## ForgetPassword Page
![Ekran görüntüsü 2025-01-16 192044](https://github.com/user-attachments/assets/dcc108ba-8f92-4f60-a55c-41d74f0efba6)

## HomePage
![Ekran görüntüsü 2025-01-16 192400](https://github.com/user-attachments/assets/6a099095-a9e4-40bc-8c19-bd5702c14c7f)

## DataFilter Page
![Ekran görüntüsü 2025-01-16 192546](https://github.com/user-attachments/assets/bcaecd4d-be45-4462-8ba0-2dacb7296556)
![Ekran görüntüsü 2025-02-03 152221](https://github.com/user-attachments/assets/9dd7e52a-050a-4d7b-8194-cdbcb6af5531)

## MeetingDetailPage
![Ekran görüntüsü 2025-01-16 192737](https://github.com/user-attachments/assets/9d284956-f019-4a67-9a00-90b48a1a233f)

## MeetingAddPage
![Ekran görüntüsü 2025-01-16 192831](https://github.com/user-attachments/assets/5b032d28-d904-4429-8497-084d3b2b5745)
![Ekran görüntüsü 2025-01-16 193026](https://github.com/user-attachments/assets/b8ecd022-0abe-4ba0-9a8d-3f530377f35d)
![Ekran görüntüsü 2025-01-16 193049](https://github.com/user-attachments/assets/ca54d03f-3feb-46bb-bdc3-529bddae2bcc)

## MeetingUpdatePage
![Ekran görüntüsü 2025-01-16 193533](https://github.com/user-attachments/assets/11704d5e-eb5e-4296-80d5-64175b8f8544)

## DrawerPage
![Ekran görüntüsü 2025-01-16 193621](https://github.com/user-attachments/assets/e01b5cee-273b-4d26-b3f1-fe0e2c887473)

## ProfilePage
![Ekran görüntüsü 2025-01-16 193704](https://github.com/user-attachments/assets/7c490151-bd2d-4243-9124-65f23d750f4a)







A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
