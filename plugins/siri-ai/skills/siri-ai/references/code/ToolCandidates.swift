import AppIntents

// ○ ツールにする: 1文で頼めて、その文からパラメータを埋められる
// 「牛乳のメモを優先度高にして」なら、memo と priority が1文に入っている
@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent { /* 次のセクションで作る */ }

// × 付けない: Siriで使えるスキーマに合わせたintentは、それだけでSiriに公開されている
// @AppIntent(.tool, schema: .reminders.createReminder) と書くとビルドエラーになる
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* 第5章 */ }

// × 付けない: 実行する操作を持たない、ウィジェットの設定用intent
// （perform() で独自の操作をしているなら、WidgetConfigurationIntent でもツールにできる）
struct SelectMemoListIntent: WidgetConfigurationIntent { /* … */ }
// × 付けない: ショートカットの途中の1手順としてしか意味を持たないintent
// × 付けない: 注文や支払いのように、人が明示的に始めるべき副作用を持つintent

// ○ ツールにする: スキーマに無い「条件でメモを探す」
@AppIntent(.tool)
struct FindMemosIntent: AppIntent { /* 後のセクションで作る */ }
