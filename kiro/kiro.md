## 🧠 Kiroとは？

[Introducing Kiro: Claude and Amazon Q によるソフトウェア開発の自動化（公式ブログ）](https://aws.amazon.com/jp/blogs/news/introducing-kiro/)

---

### 💡 Kiroは何をするもの？

「**ソフトウェア開発をAIで自動化**」するためのAmazonの新ツール。  
以下のような開発フローを、**人間の代わりにAIが自律的に実行**してくれる。

1. GitHub上のIssueを読み取り、内容を理解
2. システム設計（構成・依存性・ロジック）を自動で生成
3. 実装コードとテストコードを自動作成
4. GitHubでPull Request（PR）を作成

---

### 🔧 技術スタックと特徴

- **Claude 3**（Anthropic社の大規模言語モデル）
- **Amazon Q**（AWSの生成AI）
- **GitHub**と連携して、Issue → PRまでの開発パイプラインを自動化
- **Amazon CodeCatalyst**と統合するとCI/CD自動化も可能

---

### 🛠️ Kiroの開発フロー（例）

```plaintext
① GitHubにIssueを書く（例：ログイン機能の追加）
② @kiro とコメント
③ KiroがIssueを解析 → 設計 → 実装 → テスト → PR作成
④ 開発者がPRを確認・マージ
### 🔥 特にすごいポイント

- コード生成だけでなく **「設計」も自動化** されている  
- **プロジェクト全体のコンテキスト** を考慮した実装  
- 人間がやっていた反復作業を **24時間AIが代行**

---

### 🚀 未来への展望

- 現在は **プレビュー版（試験導入段階）**
- 将来的には：
  - **要件を自然言語で書くだけでアプリ完成**
  - **人間は「設計・判断・レビュー」のみでOK**
  - **Self-Healing（自己修復）や進化的プログラミング** の基盤へ

---

### 📌 カンタンにまとめると…

> 🛠️ **Kiroは「AIエンジニア」**  
> Issueを書くと、設計からコード作成、テスト、PR作成まで全部やってくれる。

