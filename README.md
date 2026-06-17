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

`プロジェクト > プロジェクト設定` の `Dialogue Manager Counter > 一般` にて、設定変更が可能です。

| 設定項目 | 説明 | デフォルト値 |
|---|---|---|
| Max Line Length | 1行あたりの最大文字数。超過した行を赤字で警告します。 | 35 |

---

A character count plugin for the [Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager) addon.
While editing a dialogue file, it displays the character count of each line at the cursor position and the total character count of the entire file in real time.

## Requirements

- Godot 4.x
- [Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager) addon

## Installation

1. Copy the `addons/dialogue_manager_counter` folder into your project's `addons/` directory.
2. Open `Project > Project Settings > Plugins` and enable **Dialogue Manager Counter**.

## Usage

When you open the Dialogue Manager editor, character counts are automatically displayed in the dock at the top right.

- Shows the character count for each line at the cursor position. If the line contains `\n` line breaks, they are split and counted individually.
- Lines that exceed the maximum character limit are highlighted in red.
- Displays the total character count of all dialogue lines in the entire file.

## Character Count Rules

The following are excluded from the character count.

| Excluded Content | Example |
|---|---|
| Control tags | `[wave]`, `[speed=2]`, etc. in `[...]` format |
| Speaker names | The name part before the colon, e.g. `Alice: ` or `Alice：` |
| Comment lines | `# comment` |
| Title lines | `~ title` |
| Jumps | `=> END` |
| Conditionals | `if`, `elif`, `else` |
| Variable operations | `do`, `set` |
| Choices | `- choice text` |
| Empty lines |

## Settings

Open `Project > Project Settings` to find the `Dialogue Manager Counter > General` category.

| Setting | Description | Default |
|---|---|---|
| Max Line Length | Maximum number of characters per line. Lines that exceed this limit are highlighted in red as a warning. | 35 |
