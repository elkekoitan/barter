#!/bin/bash

# Boğaziçi Barter Production Deployment Script
# Author: Turhan Hamza
# Version: 1.0.0

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ID="bogazici-barter-app"
ENVIRONMENT="${1:-production}"
BUILD_TYPE="${2:-web}"

echo -e "${BLUE}🚀 Starting Boğaziçi Barter Deployment${NC}"
echo -e "${BLUE}Environment: $ENVIRONMENT${NC}"
echo -e "${BLUE}Build Type: $BUILD_TYPE${NC}"
echo -e "${BLUE}Project ID: $PROJECT_ID${NC}"
echo ""

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi

    # Check Firebase CLI
    if ! command -v firebase &> /dev/null; then
        print_error "Firebase CLI is not installed"
        echo "Install it with: npm install -g firebase-tools"
        exit 1
    fi

    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed"
        exit 1
    fi

    print_status "All prerequisites are met"
}

# Setup environment
setup_environment() {
    echo -e "${BLUE}🔧 Setting up environment...${NC}"

    # Copy environment file
    if [ "$ENVIRONMENT" = "production" ]; then
        cp env.production .env
        print_status "Production environment configured"
    elif [ "$ENVIRONMENT" = "staging" ]; then
        cp env.staging .env
        print_status "Staging environment configured"
    else
        print_warning "Using development environment"
    fi

    # Check if .env file exists
    if [ ! -f ".env" ]; then
        print_error ".env file not found"
        exit 1
    fi

    print_status "Environment setup complete"
}

# Clean previous builds
clean_builds() {
    echo -e "${BLUE}🧹 Cleaning previous builds...${NC}"

    flutter clean
    rm -rf build/
    rm -rf .firebase/

    print_status "Clean up complete"
}

# Install dependencies
install_dependencies() {
    echo -e "${BLUE}📦 Installing dependencies...${NC}"

    flutter pub get
    flutter pub upgrade

    print_status "Dependencies installed"
}

# Run tests
run_tests() {
    echo -e "${BLUE}🧪 Running tests...${NC}"

    if [ "$ENVIRONMENT" = "production" ]; then
        flutter test --coverage

        # Check coverage
        if [ -f "coverage/lcov.info" ]; then
            print_status "Tests completed successfully"
        else
            print_warning "No coverage report generated"
        fi
    else
        print_warning "Skipping tests for non-production environment"
    fi
}

# Build application
build_application() {
    echo -e "${BLUE}🔨 Building application...${NC}"

    case $BUILD_TYPE in
        "web")
            echo "Building Flutter Web..."
            flutter build web --release --web-renderer html

            if [ $? -eq 0 ]; then
                print_status "Web build completed successfully"
            else
                print_error "Web build failed"
                exit 1
            fi
            ;;
        "android")
            echo "Building Android APK..."
            flutter build apk --release

            echo "Building Android AAB..."
            flutter build appbundle --release

            print_status "Android builds completed"
            ;;
        "ios")
            echo "Building iOS..."
            flutter build ios --release --no-codesign

            print_status "iOS build completed"
            ;;
        "all")
            echo "Building all platforms..."

            # Web
            flutter build web --release --web-renderer html

            # Android
            flutter build apk --release
            flutter build appbundle --release

            # iOS
            flutter build ios --release --no-codesign

            print_status "All platform builds completed"
            ;;
        *)
            print_error "Invalid build type: $BUILD_TYPE"
            echo "Valid options: web, android, ios, all"
            exit 1
            ;;
    esac
}

# Deploy to Firebase
deploy_firebase() {
    echo -e "${BLUE}🚀 Deploying to Firebase...${NC}"

    # Login to Firebase (if not already logged in)
    if ! firebase projects:list &> /dev/null; then
        print_warning "Firebase CLI not authenticated"
        echo "Please login to Firebase:"
        firebase login
    fi

    # Select project
    firebase use $PROJECT_ID

    # Deploy based on build type
    if [ "$BUILD_TYPE" = "web" ]; then
        firebase deploy --only hosting

        if [ $? -eq 0 ]; then
            print_status "Firebase Hosting deployment completed"
            echo -e "${GREEN}🌐 Your app is live at: https://$PROJECT_ID.web.app${NC}"
        else
            print_error "Firebase deployment failed"
            exit 1
        fi
    elif [ "$BUILD_TYPE" = "all" ]; then
        firebase deploy

        if [ $? -eq 0 ]; then
            print_status "Full Firebase deployment completed"
        else
            print_error "Firebase deployment failed"
            exit 1
        fi
    else
        print_warning "Skipping Firebase deployment for mobile builds"
    fi
}

# Security scan
security_scan() {
    if [ "$ENVIRONMENT" = "production" ]; then
        echo -e "${BLUE}🔒 Running security scan...${NC}"

        if command -v trivy &> /dev/null; then
            trivy fs .
            print_status "Security scan completed"
        else
            print_warning "Trivy not installed, skipping security scan"
        fi
    fi
}

# Main deployment flow
main() {
    echo -e "${BLUE}🎯 Starting deployment process...${NC}"

    check_prerequisites
    setup_environment
    clean_builds
    install_dependencies
    run_tests
    build_application
    security_scan
    deploy_firebase

    echo ""
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
    echo ""
    echo -e "${BLUE}📋 Next steps:${NC}"
    echo "1. Test your application"
    echo "2. Monitor Firebase Console for errors"
    echo "3. Check performance metrics"
    echo "4. Update documentation if needed"
    echo ""
    echo -e "${GREEN}Happy deploying! 🚀${NC}"
}

# Handle script arguments
case "${1:-help}" in
    "production")
        ENVIRONMENT="production"
        ;;
    "staging")
        ENVIRONMENT="staging"
        ;;
    "development")
        ENVIRONMENT="development"
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [environment] [build_type]"
        echo ""
        echo "Environments:"
        echo "  production    Deploy to production (default)"
        echo "  staging       Deploy to staging"
        echo "  development   Development environment"
        echo ""
        echo "Build Types:"
        echo "  web           Build Flutter web (default)"
        echo "  android       Build Android APK and AAB"
        echo "  ios           Build iOS app"
        echo "  all           Build all platforms"
        echo ""
        echo "Examples:"
        echo "  $0 production web"
        echo "  $0 staging all"
        echo "  $0 production android"
        exit 0
        ;;
    *)
        print_warning "Unknown environment: $1"
        print_warning "Using default: production web"
        ENVIRONMENT="production"
        BUILD_TYPE="web"
        ;;
esac

# Run main deployment function
main
