@tool
extends Control

@onready var dialogue_length = $"."  # RichTextLabelを想定
const MAX_LINE_LENGTH = 35

var _line_output := ""
var _total_count := 0
var _is_h_scene := false

func update_line_length(line_text: String, is_h_scene: bool = false) -> void:
	_is_h_scene = is_h_scene
	var counts := []

	# 話者形式（例：果乃: や 果乃：）をチェックして除去
	var speaker_regex := RegEx.new()
	speaker_regex.compile("^[^:：]{1,10}[:：]\\s?")  # 名前（1〜10文字）＋コロン＋空白（任意）

	var cleaned_text := line_text

	# 話者名があれば除去
	var match := speaker_regex.search(line_text)
	if match:
		cleaned_text = line_text.substr(match.get_end())

	# \n（文字列内のエスケープ）で分割
	var lines = cleaned_text.split("\\n")

	for l in lines:
		var trimmed := l.strip_edges()

		# 無視する行：#、~、=>、do で始まる
		if trimmed.begins_with("#") or trimmed.begins_with("~") or trimmed.begins_with("=>") or trimmed.begins_with("do"):
			continue
		if trimmed == "":
			continue

		counts.append(trimmed.length())

	# bbcode 有効化して色付きで表示
	dialogue_length.bbcode_enabled = true

	_line_output = ""
	var visible_line := 1
	for i in counts.size():
		var count = counts[i]
		if count > MAX_LINE_LENGTH:
			_line_output += "[color=#DD6666]%d行目：%d 文字[/color]\n" % [visible_line, count]
		else:
			_line_output += "%d行目：%d 文字\n" % [visible_line, count]
		visible_line += 1

	_update_display()

func update_total_length(total_count: int) -> void:
	_total_count = total_count
	_update_display()

func _update_display() -> void:
	var output := _line_output.strip_edges()

	# 全体文字数を追加表示
	if _total_count > 0:
		output += "\n\n全体文字数：%d 文字" % _total_count

	dialogue_length.text = output
