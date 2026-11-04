import Intents

func requestSiriAccess() {
    INPreferences.requestSiriAuthorization { status in
        print("Siri:", status == .authorized ? "許可" : "未許可")
    }
}
