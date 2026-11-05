import Intents

// The permission prompt SiriKit required. App Intents doesn't need it
func requestSiriAccess() {
    INPreferences.requestSiriAuthorization { status in
        print("Siri:", status == .authorized ? "authorized" : "not authorized")
    }
}
