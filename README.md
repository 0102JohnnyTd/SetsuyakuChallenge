## SetsuyakuChallenge

本アプリは、Firebaseの導入と設計パターンMVCのトレーニング用に開発した。

アカウント機能やデータ保存/取得の実装にFirebaseを使用した節約メモを記録するアプリ。

『節約して浮いたお金で実現したい目標を設定 → 節約できたらメモを書く → 節約できた合計金額をアプリが計算 』という流れで目標達成を目指す。

AppStore:
https://apps.apple.com/jp/app/uita-%E7%AF%80%E7%B4%84%E3%83%A1%E3%83%A2%E3%82%A2%E3%83%97%E3%83%AA/id6443558943
<!-- # 環境 -->



## 使用ライブラリ

| ライブラリ名  | 用途 |
| ------------- | ------------- |
| [SwiftLint](https://github.com/realm/SwiftLint)  | インデント崩れ等のコーディングミスを機械的に防ぐ為  |
| [IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager)  | キーボードの出現によってオブジェクトが隠れてしまう事態を避ける  |
| [Kingfisher](https://github.com/onevcat/Kingfisher)  | 画像をダウンロードしてキャッシュ  |
| [FirebaseAuth](https://github.com/firebase/firebase-ios-sdk)  | アカウント機能の実装  |
| [FirebaseFirestore](https://github.com/firebase/firebase-ios-sdk)  | 保存されたデータのコレクションを取得  |
| [FirebaseFirestoreSwift](https://github.com/firebase/firebase-ios-sdk)  | データをモデル型で保存/取得 |
| [FirebaseStorage](https://github.com/firebase/firebase-ios-sdk)  | 画像データを保存  |

## アプリ概要
| ホーム画面  | 目標設定画面 |　節約メモ一覧画面 |
| ------------- | ------------- | ------------- |
| ![Simulator Screen Shot - iPhone 13 Pro Max - 2022-11-14 at 00 01 41のコピー](https://user-images.githubusercontent.com/68774612/201528908-88d7310c-b25d-455b-b286-4eb9e107f50a.png)| ![Simulator Screen Shot - iPhone 13 Pro Max - 2022-11-14 at 00 00 32](https://user-images.githubusercontent.com/68774612/201528970-2b235b00-0356-40c7-bab7-4e16f8d829b9.png)| ![Simulator Screen Shot - iPhone 13 Pro Max - 2022-11-14 at 00 03 52](https://user-images.githubusercontent.com/68774612/201528983-50a72af8-c3a4-49d7-b80c-b1c65775378c.png)

### ホーム画面
- 自身が設定した『節約して浮いたお金で実現したい目標』一覧を表示する
- セグメントを切り替えると達成した目標一覧を表示する
- 目標のCellをタップすると目標ごとの節約メモ一覧画面を表示
- 画面右下の緑ボタンタップで目標設定画面に遷移
- 画面右上のアイコンタップでユーザー詳細画面に遷移
- 画面左上のアイコンタップで設定詳細画面に遷移

### 目標設定画面
- 目標を設定

### 節約メモ一覧画面
- すべての節約メモを閲覧できる
- 画面右上のボタンからメモを追加
