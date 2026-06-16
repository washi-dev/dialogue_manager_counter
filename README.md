# Dialogue Manager Counter

[Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager) アドオン用の文字数カウントプラグインです。
ダイアログファイルの編集中に、カーソル行の各行文字数とファイル全体の文字数をリアルタイムで表示します。

## 必要環境

- Godot 4.x
- [Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager) アドオン

## インストール

1. `addons/dialogue_manager_counter` フォルダをプロジェクトの `addons/` にコピーします。
2. `プロジェクト > プロジェクト設定 > プラグイン` を開き、**Dialogue Manager Counter** を有効にします。

## 使い方

Dialogue Manager の編集画面を開くと、右上のドックに文字数が自動で表示されます。

- カーソルを置いた行の各行文字数を表示します。`\n` で改行している場合は分割してそれぞれカウントします。
- 1行あたりの文字数が上限を超えた行は赤字で表示されます。
- ファイル全体のセリフ文字数の合計を表示します。

## 文字数カウントのルール

以下は文字数のカウント対象から除外されます。

| 除外される内容 | 例 |
|---|---|
| 制御タグ | `[wave]`, `[speed=2]` など `[...]` 形式 |
| 話者名 | `アリス: ` や `アリス：` などコロン前の名前部分 |
| コメント行 | `# コメント` |
| タイトル行 | `~ タイトル` |
| ジャンプ | `=> END` |
| 条件分岐 | `if`, `elif`, `else` |
| 変数操作 | `do`, `set` |
| 選択肢 | `- 選択肢テキスト` |
| 空行 |

## 設定

`プロジェクト > プロジェクト設定` を開くと `Dialogue Manager Counter > General` カテゴリが表示されます。

| 設定項目 | 説明 | デフォルト値 |
|---|---|---|
| Max Line Length | 1行あたりの最大文字数。超過した行を赤字で警告します。 | 35 |
