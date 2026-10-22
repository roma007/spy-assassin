#!/bin/bash
# 把商店描述文本复制到剪贴板，供 App Store Connect 手动粘贴。
#
# 用法：
#   docs/asc/copy.sh <en|zh|es|ko>            # 整段描述（该语言还没有描述时用）
#   docs/asc/copy.sh <en|zh|es|ko> links      # 只要末尾两行 EULA/隐私政策链接（已有描述时追加用）
#
# 位置：App Store Connect -> 我的 App -> Spy Assassin -> 左侧「版本」(1.0.0)
#       -> 顶部语言下拉选语言 -> 「描述」框
set -euo pipefail

lang="${1:-}"
mode="${2:-full}"

case "${lang}" in
  en | zh | es | ko) ;;
  *)
    echo "用法: $0 <en|zh|es|ko> [links]" >&2
    exit 1
    ;;
esac

dir="$(cd "$(dirname "$0")" && pwd)"

case "${mode}" in
  full)
    file="${dir}/desc_${lang}.txt"
    hint="描述框内全选删除 -> 粘贴（Cmd+V）-> 保存"
    ;;
  links)
    file="${dir}/links_${lang}.txt"
    hint="光标点到描述框最末尾 -> 回车换行 -> 粘贴（Cmd+V）-> 保存"
    ;;
  *)
    echo "用法: $0 <en|zh|es|ko> [links]" >&2
    exit 1
    ;;
esac

if [[ ! -f "${file}" ]]; then
  echo "找不到 ${file}" >&2
  exit 1
fi

pbcopy < "${file}"
chars="$(wc -m < "${file}" | tr -d ' ')"

echo "已复制到剪贴板：${file}（${chars} 字符，模式：${mode}）"
echo "位置：App Store Connect -> 我的 App -> Spy Assassin -> 左侧「版本 1.0.0」"
echo "      -> 顶部语言下拉选语言 -> 「描述」框"
echo "操作：${hint}"
