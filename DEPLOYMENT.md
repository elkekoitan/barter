# 🚀 Deployment Guide

This guide provides comprehensive instructions for deploying the Bogazici Barter application to various environments.

## 📋 Prerequisites

- Node.js 20.x or later
- Firebase CLI
- Flutter SDK 3.24.0 or later
- Google Cloud account with billing enabled
- GitHub repository with admin access

## 🏗️ Environment Setup

### 1. Environment Variables

Copy the appropriate environment file:

```bash
# For production
cp env.production .env

# For staging
cp env.staging .env

# For development
cp .env.development .env
```

### 2. Firebase Configuration

1. **Login to Firebase:**
   ```bash
   firebase login
   ```

2. **Select Project:**
   ```bash
   firebase use bogazici-barter-app
   ```

3. **Deploy Firebase Configuration:**
   ```bash
   firebase deploy
   ```

## 🚀 Deployment Options

### Option 1: Firebase Hosting (Recommended)

#### Web Deployment
```bash
# Build and deploy web app
flutter build web --release
firebase deploy --only hosting
```

#### Full Stack Deployment
```bash
# Deploy all Firebase services
firebase deploy
```

### Option 2: Docker Deployment

#### Using Docker Compose (Development)
```bash
# Start development environment
docker-compose --profile web up

# Start with database and cache
docker-compose --profile database --profile cache up

# Start all services
docker-compose up
```

#### Production Docker Deployment
```bash
# Build production image
docker build -t bogazici-barter .

# Run with environment variables
docker run -p 80:80 \
  -e ENVIRONMENT=production \
  -e FIREBASE_API_KEY=your_api_key \
  bogazici-barter
```

### Option 3: Manual Server Deployment

#### Nginx Setup
1. Build the Flutter web app:
   ```bash
   flutter build web --release
   ```

2. Copy build files to server:
   ```bash
   scp -r build/web/* user@server:/var/www/bogazici-barter/
   ```

3. Configure Nginx (see nginx.conf)

#### Apache Setup
1. Build the Flutter web app
2. Copy files to Apache document root
3. Configure .htaccess for SPA routing

## 🔧 CI/CD Pipeline

### GitHub Actions

The project includes automated CI/CD pipelines:

#### Features:
- ✅ Code formatting and linting
- ✅ Unit and integration tests
- ✅ Security vulnerability scanning
- ✅ Multi-platform builds (Web, Android, iOS)
- ✅ Firebase Hosting deployment
- ✅ Performance monitoring with Lighthouse
- ✅ Code coverage reporting

#### Manual Trigger:
```bash
# Trigger deployment manually
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/your-username/bogazici-barter/dispatches \
  -d '{"event_type": "deploy"}'
```

### Jenkins Pipeline

For Jenkins deployment, use the provided `Jenkinsfile`:

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh 'flutter test'
            }
        }

        stage('Build') {
            steps {
                sh 'flutter build web --release'
            }
        }

        stage('Deploy') {
            steps {
                sh 'firebase deploy --token $FIREBASE_TOKEN'
            }
        }
    }
}
```

## 🔐 Security Configuration

### Firebase Security Rules

#### Firestore Rules
Deploy security rules:
```bash
firebase deploy --only firestore:rules
```

#### Storage Rules
Deploy storage rules:
```bash
firebase deploy --only storage
```

### Environment Variables

Never commit sensitive data to version control:

```bash
# Add to .gitignore
.env
.env.local
.env.*.local
firebase-debug.log
*.log
```

## 📱 Mobile App Deployment

### Android Deployment

#### Google Play Store
1. Build release AAB:
   ```bash
   flutter build appbundle --release
   ```

2. Upload to Google Play Console

#### Firebase App Distribution
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Distribute APK
firebase appdistribution:distribute build/app/outputs/apk/release/app-release.apk \
  --app your-firebase-app-id \
  --groups "testers"
```

### iOS Deployment

#### TestFlight
1. Build iOS app:
   ```bash
   flutter build ios --release
   ```

2. Archive and upload to TestFlight

#### Firebase App Distribution
```bash
firebase appdistribution:distribute build/ios/ipa/your-app.ipa \
  --app your-firebase-app-id \
  --groups "testers"
```

## 🔍 Monitoring & Analytics

### Firebase Monitoring
- **Performance Monitoring**: Enabled by default
- **Crashlytics**: Enabled by default
- **Analytics**: Configured in main.dart

### Custom Monitoring
```bash
# View Firebase console
firebase hosting:open

# View analytics
firebase analytics:log-event
```

## 🧪 Testing in Production

### A/B Testing
1. Configure experiments in Firebase Console
2. Use Firebase Remote Config for feature flags
3. Monitor experiment results

### Staged Rollout
1. Deploy to staging environment first
2. Test thoroughly
3. Gradual rollout to production

## 🔄 Rollback Procedures

### Firebase Hosting Rollback
```bash
# View deployment history
firebase hosting:channel:list

# Rollback to previous version
firebase hosting:channel:deploy staging --rollback
```

### Docker Rollback
```bash
# Check image history
docker history bogazici-barter

# Rollback to previous image
docker run -p 80:80 your-registry/bogazici-barter:previous-tag
```

## 📊 Performance Optimization

### Web Performance
- Enable gzip compression
- Configure caching headers
- Optimize images
- Use CDN for static assets

### Mobile Performance
- Enable ProGuard/R8 for Android
- Enable iOS bitcode optimization
- Implement lazy loading
- Use Firebase Performance Monitoring

## 🆘 Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clean build
flutter clean
flutter pub get
flutter build web --release
```

#### Firebase Deployment Issues
```bash
# Check Firebase status
firebase --version
firebase projects:list

# Redeploy with force
firebase deploy --force
```

#### Environment Issues
```bash
# Check environment variables
flutter run --dart-define=ENVIRONMENT=production

# Validate configuration
firebase use --add
```

### Getting Help

1. Check Firebase Console: https://console.firebase.google.com
2. Review GitHub Actions logs
3. Check deployment logs: `firebase deploy --debug`
4. Contact support: support@bogazicibarter.com

## 📝 Maintenance

### Regular Tasks
- Monitor Firebase usage and billing
- Update dependencies monthly
- Review security rules quarterly
- Performance optimization reviews

### Backup Strategy
- Automated database backups (Firebase)
- Version control for code and configurations
- Regular security audits

---

**Last Updated**: $(date)
**Version**: 1.0.0
**Environment**: Production
