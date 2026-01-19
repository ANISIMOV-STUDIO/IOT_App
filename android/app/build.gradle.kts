plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.hvac_control"
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
        applicationId = "com.example.hvac_control"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // =========================================================================
    // RELEASE SIGNING CONFIGURATION
    // =========================================================================
    //
    // Для production релизов необходимо настроить подпись приложения:
    //
    // 1. Создать keystore:
    //    keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
    //            -keysize 2048 -validity 10000 -alias upload
    //
    // 2. Создать файл android/key.properties (НЕ коммитить в git!):
    //    storePassword=<пароль keystore>
    //    keyPassword=<пароль ключа>
    //    keyAlias=upload
    //    storeFile=<путь к keystore, например /Users/username/upload-keystore.jks>
    //
    // 3. Добавить android/key.properties в .gitignore
    //
    // 4. Раскомментировать блок signingConfigs ниже и настроить release buildType
    //
    // Документация: https://docs.flutter.dev/deployment/android#signing-the-app
    // =========================================================================

    // Раскомментировать для production релизов:
    //
    // val keystoreProperties = Properties()
    // val keystorePropertiesFile = rootProject.file("key.properties")
    // if (keystorePropertiesFile.exists()) {
    //     keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    // }
    //
    // signingConfigs {
    //     create("release") {
    //         keyAlias = keystoreProperties["keyAlias"] as String
    //         keyPassword = keystoreProperties["keyPassword"] as String
    //         storeFile = file(keystoreProperties["storeFile"] as String)
    //         storePassword = keystoreProperties["storePassword"] as String
    //     }
    // }

    buildTypes {
        release {
            // =====================================================================
            // ВАЖНО: Для production релизов замените debug signing на release:
            // signingConfig = signingConfigs.getByName("release")
            // =====================================================================
            signingConfig = signingConfigs.getByName("debug")

            // ProGuard/R8 конфигурация для минификации и обфускации
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
