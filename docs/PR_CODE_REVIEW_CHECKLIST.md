# PR & Code Review Checklist

Bu belge, Boğaziçi Barter kod tabanında yapılacak her PR veya code review sürecinde gözden kaçabilecek kritik noktaları hatırlatmak için hazırlanmıştır. Aşağıdaki maddeleri sırayla kontrol ederek ilerleyin.

## 1. Dependency Injection (DI) & Konfigürasyon
- `lib/injection_container.dart` dosyasında import edilen her sınıf gerçekten mevcut mu? (Örn. `data/datasources/remote/user_remote_datasource.dart`, `data/repositories/listing_repository_impl.dart`).
- GetIt kayıtları arabirimler yerine somut sınıfları mı işaret ediyor? (Örn. `AuthRemoteDataSourceImpl`).
- Kullanılan tüm use case sınıfları (`RejectOfferUseCase`, `CreateEscrowUseCase` vb.) gerçekten `lib/domain/usecases/` altında mevcut mu?
- Dosyanın başında `part 'injection_container.config.dart';` satırı var mı ve build_runner çıktısı repo dengesine uygun mu?
- Gerekirse `flutter pub run build_runner build --delete-conflicting-outputs` komutu çalıştırıldı mı?
- GetIt’in ayağa kalktığını kanıtlayan smoke test mevcut ve yeşil mi?

## 2. Authentication Katmanı
- `lib/domain/repositories/auth_repository.dart` tek bir `AuthRepository` tanımı içeriyor mu? Yinelenen tanımlar veya social-login placeholder’ları temizlendi mi?
- `RegisterRequest` gibi modeller doğrulama için gereken alanları sağlıyor mu (ör. `confirmPassword`)?
- Use case dosyalarında (`login_usecase.dart`, `register_usecase.dart`, `verify_otp_usecase.dart`) `isLoggedIn` yanlış kullanılmıyor mu? Bunun yerine `NetworkInfo` veya uygun kontroller kullanıldı mı?
- `firebase_auth` gibi bağımlılıklar gerçekten kullanıldığı yerlerde import edildi mi?
- Auth BLoC ve UI katmanında yapılan değişiklikler yeni domain sözleşmeleriyle uyumlu mu?

## 3. Payment Modülü
- `lib/presentation/blocs/payment/payment_bloc.dart` ve ilgili event/state dosyalarında `part` konfigürasyonu doğru mu? Çift tanımlı sınıf kalmamış mı?
- `ProcessPaymentUsecase` içinde `ValidationFailure` tekrar tanımlanmıyor mu? Ortak `core/errors/failures.dart` sürümü kullanılıyor mu?
- `lib/data/datasources/remote/payment_remote_datasource.dart` içindeki DTO’lar domain modelleriyle çakışmıyor mu? (Örn. `RemotePaymentRequest` gibi ayrı isimler).
- Tüm ödeme sağlayıcıları için `UnimplementedError` yerine gerçek implementasyon veya güvenli bir fallback var mı? UI’da desteklenmeyen sağlayıcılar saklandı mı?
- Papara / İyzico vb. sağlayıcıların gerektirdiği konfigürasyonlar (API anahtarları, callback URL’leri) dokümante edildi mi?

## 4. Data Source & Repository Eşleşmesi
- Domain katmanındaki her repository arabiriminin (`ListingRepository`, `BarterRepository`, `ChatRepository`, `LocalizationRepository` vb.) data katmanında bir `…Impl` karşılığı var mı?
- Eksik olan implementasyonlar varsa PR’da mı eklenmiş yoksa DI kayıtlarından mı çıkarılmış?
- Veri modellerinde konum karmaşası yok mu? (Örn. `EscrowEntity` ayrı dosyaya taşındıysa importlar doğru mu?).

## 5. Test & Kalite Kontrolleri
- `flutter analyze` ve `dart format --set-exit-if-changed .` çalıştırıldı mı ve sonuçlar temiz mi?
- `flutter test` (ve gerekiyorsa widget/integration testleri) geçiyor mu?
- Yeni kod için unit test, widget test veya repository katmanı testleri eklendi mi?
- Payment veya auth gibi kritik akışlar için regresyon testleri güncellendi mi?

## 6. Dokümantasyon & Operasyonel Kontroller
- `docs/CRITICAL_ISSUES.md` güncel mi? Yapılan düzeltmeler oradaki maddelerle uyumlu mu?
- PR açıklamasında çalıştırılan komutlar, test çıktıları ve olası konfigürasyon adımları listelendi mi?
- Ekip tarafından izlenen konfigürasyon dosyaları (ör. `.env`, Firebase ayarları) için yönergeler net mi?
- Gerekiyorsa `agents.txt` veya diğer mimari belgeler güncellendi mi?

## 7. UI / UX Etkileri
- UI’da yeni ekran veya değişiklik varsa ekran görüntüsü / video eklendi mi?
- Yerelleştirme için yeni anahtarlar eklendiyse `assets/translations/...` dosyaları güncellendi mi?
- Kullanıcı akışı (özellikle auth, payment, listing) doküman veya QA notlarıyla desteklendi mi?

## 8. Güvenlik & Konfigürasyon
- Kimlik doğrulama, ödeme veya KYC ile ilgili akışlarda hassas veri maskelemeleri gözden geçirildi mi?
- Logging/analytics (Crashlytics, Firebase Analytics) entegrasyonları doğru yerde tetikleniyor mu?
- Depolanan API anahtarları / sırlar `.env` veya güvenli storage üzerinden mi yönetiliyor?

## 9. Release Hazırlığı
- `pubspec.yaml` bağımlılık güncellemeleri varsa proje genelinde etkileri kontrol edildi mi?
- Flutter versiyonu / çevresel gereksinimler PR’da belirtilmiş mi?
- Gerekliyse build çıktıları (örn. `flutter build apk --flavor prod`) lokal ortamda denenmiş mi?

## 10. Review Süreci
- Her madde için “Done / Not applicable / Follow-up” şeklinde küçük notlar tutuldu mu?
- Eksik kalan maddeler için ayrı issue açıldı mı veya PR yorumlarına eklendi mi?
- Review tamamlanınca bu checklist kısa özetle PR yorumlarına kopyalandı mı?

Bu kontrol listesini düzenli kullanarak; DI sorunları, eksik implementasyonlar ve kritik ödeme/auth hataları gibi problemleri early-stage’de yakalayıp platformu stabil tutabilirsiniz.
