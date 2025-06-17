#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#include <WiFiUdp.h>
#include <NTPClient.h>

// Ganti dengan kredensial WiFi Anda
#define WIFI_SSID "vivo V30"
#define WIFI_PASSWORD "dianlestari"

// Host dan Token Firebase yang benar
#define FIREBASE_HOST "project-chicken-rpl-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define FIREBASE_AUTH "thkYmQGJ1CDpHzuOplLgRbaPVnLOkfo709O4eugS"

// Pin sensor infrared
#define IR_SENSOR_PIN_1 D7
#define IR_SENSOR_PIN_2 D6

// Timeout untuk koneksi WiFi (dalam milidetik)
#define WIFI_TIMEOUT 10000  // 10 detik

FirebaseData firebaseData;
FirebaseConfig firebaseConfig;
FirebaseAuth firebaseAuth;

// NTP untuk waktu
WiFiUDP udp;
NTPClient timeClient(udp, "pool.ntp.org", 3600, 60000);  // Time zone offset +3600 (UTC+1) dan refresh setiap 60 detik

void setup() {
  Serial.begin(115200);

  // Koneksi ke WiFi
  Serial.print("Connecting to Wi-Fi");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  unsigned long startTime = millis();  // Catat waktu mulai
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");

    // Jika timeout tercapai, hentikan percobaan koneksi
    if (millis() - startTime > WIFI_TIMEOUT) {
      Serial.println();
      Serial.println("Failed to connect to Wi-Fi. Please check your credentials or network.");
      return;  // Keluar dari setup() jika gagal terhubung
    }
  }

  // Jika terhubung, tampilkan IP address
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Inisialisasi Firebase
  firebaseConfig.host = FIREBASE_HOST;
  firebaseConfig.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&firebaseConfig, &firebaseAuth);
  Firebase.reconnectWiFi(true);

  // Mulai NTP Client
  timeClient.begin();
  timeClient.setTimeOffset(3600);  // Sesuaikan dengan zona waktu Anda
}

void handleSensor(int sensorPin, String ayamId) {
  // Baca status sensor infrared
  int irStatus = digitalRead(sensorPin);

  // Jika sensor mendeteksi objek (LOW), lakukan penambahan
  if (irStatus == LOW) {
    // Update waktu dari NTP
    timeClient.update();
    time_t epochTime = timeClient.getEpochTime();

    // Konversi epoch ke waktu lokal
    struct tm *ptm = gmtime((time_t *)&epochTime);

    // Format tanggal
    int year = ptm->tm_year + 1900;
    int month = ptm->tm_mon + 1;
    int day = ptm->tm_mday + 1;

    // Buat string tanggal "YYYY-MM-DD"
    char dateString[11];
    sprintf(dateString, "%04d-%02d-%02d", year, month, day);
    String currentDate = String(dateString);

    // Path tempat data telur disimpan
    String eggPath = "/dataTelur/" + ayamId;

    // Baca nilai saat ini dari Firebase
    if (Firebase.getInt(firebaseData, eggPath + "/jumlah")) {
      int currentTotal = firebaseData.intData();  // Ambil nilai saat ini
      int newTotal = currentTotal + 1;            // Tambahkan 1

      // Kirim nilai yang diperbarui ke Firebase
      if (Firebase.setInt(firebaseData, eggPath + "/jumlah", newTotal)) {
        Serial.println("Sensor " + ayamId + " - Data sent to Firebase: " + String(newTotal));

        // Kirim ID ayam dan tanggal ke Firebase
        if (Firebase.setString(firebaseData, eggPath + "/id_ayam", ayamId)) {
          Serial.println("Sensor " + ayamId + " - ID Ayam sent to Firebase: " + ayamId);
        }

        if (Firebase.setString(firebaseData, eggPath + "/tanggal", currentDate)) {
          Serial.println("Sensor " + ayamId + " - Tanggal sent to Firebase: " + currentDate);
        }
      } else {
        Serial.println("Sensor " + ayamId + " - Failed to send data to Firebase");
        Serial.println("Reason: " + firebaseData.errorReason());
      }
    } else {
      Serial.println("Sensor " + ayamId + " - Failed to read data from Firebase");
      Serial.println("Reason: " + firebaseData.errorReason());
    }

    // Tunggu sampai objek tidak terdeteksi lagi (debouncing)
    while (digitalRead(sensorPin) == LOW) {
      delay(100);
    }
  }
}

void loop() {
  // Jika WiFi tidak terhubung, jangan jalankan loop
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi not connected. Please check your connection.");
    delay(5000);  // Tunggu 5 detik sebelum mencoba lagi
    return;
  }

  // Handle sensor pertama (ID ayam 007)
  handleSensor(IR_SENSOR_PIN_1, "007");
  
  // Handle sensor kedua (ID ayam 008)
  handleSensor(IR_SENSOR_PIN_2, "008");

  delay(100);  // Tunggu sebentar sebelum membaca lagi
}