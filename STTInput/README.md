### 📅 2025/07/02 STTInputのローカル環境構築
- 実施時間：約2時間

**📋 基本情報**
- ツール名：STTInput
- バージョン：1.0.0
- 元リポジトリ：[YutaFujii0/STTInput](https://github.com/YutaFujii0/STTInput)
- オリジナルREADME：[README_original.md](README_original.md)

**🎯 目的**
- OpenAIのAPIを使わずに、オフライン環境でも動作するローカル完結型の音声入力ツールとして利用したい。

**⚙️ 実行した内容**
- **開発環境のセットアップ**:
    - Xcodeをインストール
    - Homebrew経由でffmpegをインストール
- **プロジェクトの改修**:
    - `SwiftWhisper`ライブラリを導入し、OpenAI APIへの依存を排除
    - 音声認識処理をローカルで実行するようにソースコードを変更
    - アプリケーションのビルドと動作確認

**💡 学んだこと**
- `SwiftWhisper`ライブラリと`ffmpeg`を組み合わせることで、比較的容易にローカルでの音声認識を実現できる。
- Xcodeプロジェクトの依存関係やビルド設定の変更方法について理解が深まった。
- 音声認識の精度は、使用するモデル（例: `ggml-base.en.bin`）に依存する。
- **Whisperについて詳しく学習** → [Whisperの詳細まとめ](../../study_web2/memo/memo_study.md)

**😊 感想・評価**
- 良かった点：
    - APIキーが不要
    - オフラインで動作するため、セキュリティやプライバシーの面で安心
- 気になった点：
    - ローカルモデルでの認識精度は、利用シーンによっては調整が必要


**🔗 参考になったリソース**
- [SwiftWhisper (exPHAT/SwiftWhisper)](https://github.com/exPHAT/SwiftWhisper)

**📝 今後の活用予定**
- 日常的なテキスト入力、特に長文作成時に積極的に活用していく。