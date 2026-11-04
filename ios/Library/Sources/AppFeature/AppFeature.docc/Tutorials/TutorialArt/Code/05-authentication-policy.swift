import AppIntents

// @Propertyごとに認証ポリシーや可視性を指定できる。
// 本文は人に見せる前に認証を求め、内部IDはSiri/Shortcutsには一切出さない。
extension MemoEntity {
    static let authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
}

struct MemoDetail {
    @Property(title: "本文", authenticationPolicy: .requiresAuthentication)
    var body: String

    @Property(title: "内部リビジョンID", visibility: .internal)
    var internalRevisionID: String
}
