import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.testver2_heart"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.testver2_heart"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 릴리즈 서명 설정을 위한 signingConfigs 블록 추가
    signingConfigs {
        create("release") {
            // 여기에 여러분의 릴리즈 키스토어 정보를 직접 입력하세요.
            // my-release-key.jks 파일은 android/app 폴더에 있어야 합니다.
            storeFile = file("my-release-key.jks")
            storePassword = "123456"
            keyAlias = "my-alias"
            keyPassword = "123456"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // 코드 축소 및 Proguard 규칙을 활성화합니다.
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}