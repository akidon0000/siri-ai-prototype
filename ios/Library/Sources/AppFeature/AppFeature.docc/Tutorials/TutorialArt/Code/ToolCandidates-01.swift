import AppIntents

// ○ ツールにする: 1文で頼めて、その文からパラメータを埋められる
// 「牛乳のメモを優先度高にして」なら、memo と priority が1文に入っている
@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent { /* 次のセクションで作る */ }
