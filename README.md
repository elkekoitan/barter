# 🏪 Boğaziçi Barter

Türkiye'nin ilk akıllı barter platformu - **Boğaziçi Barter** Flutter mobil uygulaması.

## 🚀 Production Ready

[![Firebase Hosting](https://img.shields.io/badge/Firebase%20Hosting-FFCA28?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-blue?style=flat&logo=github-actions)](https://github.com/features/actions)

### 🌐 Live Applications
- **🚀 Production (LIVE)**: [https://bogazici-barter-app.web.app](https://bogazici-barter-app.web.app)
- **📊 Firebase Console**: [https://console.firebase.google.com/project/bogazici-barter-app](https://console.firebase.google.com/project/bogazici-barter-app/overview)
- **🔧 GitHub Repository**: [https://github.com/elkekoitan/barter](https://github.com/elkekoitan/barter)

## 🌟 Özellikler

- 🔐 **Güvenli Giriş**: KYC doğrulamalı kullanıcı kaydı ve giriş
- 📦 **Akıllı İlan**: 6 adımlı ilan oluşturma sihirbazı
- 🔄 **Barter Sistemi**: Emanet (escrow) sistemi ile güvenli takas
- 💳 **Çoklu Ödeme**: 7 farklı Türk ödeme sağlayıcısı desteği
- 💬 **Gerçek Zamanlı Sohbet**: WebSocket tabanlı mesajlaşma
- 🌍 **Çoklu Dil**: Türkçe, İngilizce, Arapça desteği
- 👮‍♂️ **Admin Paneli**: Moderasyon ve analitik dashboard
- 📊 **Analitik**: Firebase entegrasyonlu performans takibi
- 🛡️ **Güvenlik**: 2FA, şifreleme, güvenlik taraması
- 🔄 **CI/CD**: Otomatik test ve deployment pipeline

## 🏗️ Mimari

Bu proje **Clean Architecture** prensiplerine uygun olarak tasarlanmıştır:

```
lib/
├── core/           # Temel katman (network, theme, utils, etc.)
├── data/           # Veri katmanı (datasources, repositories, models)
├── domain/         # İş mantığı katmanı (entities, repositories, usecases)
└── presentation/   # Sunum katmanı (blocs, pages, widgets)
```

### Kullanılan Teknolojiler

- **State Management**: Flutter BLoC
- **Dependency Injection**: GetIt + Injectable
- **Network**: Dio
- **Local Storage**: Shared Preferences + Flutter Secure Storage
- **Firebase**: Authentication, Firestore, Storage, Analytics, Crashlytics
- **Localization**: Easy Localization
- **UI**: Flutter ScreenUtil, Cached Network Image

## 🚀 Kurulum

### Gereksinimler

- Flutter SDK >= 3.0.0
- Dart SDK >= 2.19.0
- Android Studio / VS Code
- Firebase hesabı
- Ödeme sağlayıcısı hesapları (Papara, İyzico, vb.)

### Adımlar

1. **Proje Klonlama**
   ```bash
   git clone <repository-url>
   cd bogazici-barter
   ```

2. **Bağımlılıkları Yükleme**
   ```bash
   flutter pub get
   ```

3. **Ortam Değişkenleri Ayarlama**
   ```bash
   cp .env.example .env
   ```

   `.env` dosyasını düzenleyin ve gerçek API anahtarlarınızı ekleyin.

4. **Firebase Ayarlama**
   - Firebase projesi oluşturun
   - `google-services.json` dosyasını `android/app/` altına yerleştirin
   - `GoogleService-Info.plist` dosyasını `ios/Runner/` altına yerleştirin

5. **Build**
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   ```

## 🚀 Deployment

### 🔥 Firebase Deployment (Recommended)

#### 1. Firebase CLI Setup
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Select project
firebase use bogazici-barter-app
```

#### 2. Environment Configuration
```bash
# Copy production environment file
cp env.production .env

# Edit with your production API keys
nano .env
```

#### 3. Deploy to Firebase
```bash
# Deploy all services
firebase deploy

# Deploy only hosting
firebase deploy --only hosting

# Deploy only functions
firebase deploy --only functions
```

### 🐳 Docker Deployment

#### Development Environment
```bash
# Start development services
docker-compose --profile web up

# Start with database
docker-compose --profile database up
```

#### Production Deployment
```bash
# Build production image
docker build -t bogazici-barter .

# Run production container
docker run -p 80:80 \
  -e ENVIRONMENT=production \
  bogazici-barter
```

### 📱 Mobile App Stores

#### Google Play Store
```bash
# Build release AAB
flutter build appbundle --release

# Upload to Google Play Console
```

#### Apple App Store
```bash
# Build iOS release
flutter build ios --release

# Archive and upload to App Store Connect
```

### 🔄 CI/CD Pipeline

The project includes automated deployment via GitHub Actions:

- ✅ **Code Quality**: Formatting, linting, testing
- ✅ **Multi-platform Builds**: Web, Android, iOS
- ✅ **Firebase Deployment**: Automatic hosting deployment
- ✅ **Security Scanning**: Vulnerability checks
- ✅ **Performance Testing**: Lighthouse CI

### 📊 Monitoring

- **Firebase Console**: [https://console.firebase.google.com/project/bogazici-barter-app](https://console.firebase.google.com/project/bogazici-barter-app)
- **Performance Monitoring**: Built-in Firebase Performance
- **Error Tracking**: Firebase Crashlytics
- **Analytics**: Firebase Analytics

### 🔐 Security

- **Firestore Rules**: Row-level security
- **Storage Rules**: File upload security
- **Authentication**: Firebase Auth with 2FA
- **API Security**: Rate limiting and validation

For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md).

## 🔧 Yapılandırma

### Ödeme Sağlayıcıları

Proje aşağıdaki ödeme sağlayıcılarını destekler:

- **Papara** - Popüler dijital cüzdan
- **İyzico** - Marketplace ödeme çözümü
- **Tosla** - Online ödeme sistemi
- **PayTR** - Sanal POS çözümü
- **BKM Express** - Banka kartı hızlı ödeme
- **Paycell** - Mobil ödeme platformu
- **Param** - POS ve online ödeme

### API Yapılandırması

Backend API'niz şu endpoint'leri sağlamalıdır:

```
POST   /auth/login
POST   /auth/register
POST   /auth/verify-otp
POST   /payments/process
GET    /payments/{id}
POST   /escrow
POST   /escrow/{id}/release
```

## 📱 Kullanım

### Temel Kullanım

```dart
import 'package:bogazici_barter/injection_container.dart' as di;
import 'package:bogazici_barter/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency injection setup
  await di.configureDependencies();

  // Firebase initialization
  await Firebase.initializeApp();

  runApp(const BogaziciBarterApp());
}
```

### Ödeme İşleme

```dart
final paymentBloc = PaymentBloc(processPaymentUsecase: getIt());

paymentBloc.add(ProcessPaymentRequested(PaymentRequest(
  referenceId: 'BARTER123',
  userId: 'user456',
  amount: 100.0,
  currency: 'TRY',
  provider: 'papara',
  description: 'Barter ödemesi',
  callbackUrl: 'https://app.bogazicibarter.com/callback',
)));
```

## 🧪 Test

```bash
# Unit tests
flutter test

# Widget tests
flutter test --type=widget

# Integration tests
flutter test integration_test/

# Coverage report
flutter test --coverage
```

## 📊 Analytics

Proje Firebase Analytics ile entegre edilmiştir:

- Kullanıcı davranışları
- Ödeme dönüşüm oranları
- Barter tamamlama oranları
- Hata raporları

## 🔐 Güvenlik

- JWT tabanlı kimlik doğrulama
- AES-256 şifreleme
- Secure Storage kullanımı
- SSL pinning
- Rate limiting

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📞 İletişim

- **Email**: info@bogazicibarter.com
- **Website**: https://bogazicibarter.com
- **GitHub**: https://github.com/bogazicibarter

---

*Boğaziçi Barter - Akıllı takasın adresi* 🚀
