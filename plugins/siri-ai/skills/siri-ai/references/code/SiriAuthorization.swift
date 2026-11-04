import Intents

// SiriKitで必要だった利用許可のダイアログ。App Intentsでは要らない
func requestSiriAccess() {
    INPreferences.requestSiriAuthorization { status in
        print("Siri:", status == .authorized ? "許可" : "未許可")
    }
}
