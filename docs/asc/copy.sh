#!/bin/bash
# 把某个语言的 App 描述（已含 EULA + 隐私政策链接）复制到剪贴板，
# 供 App Store Connect → App 信息 → 本地化 → 描述框 直接粘贴。
#
# 用法：docs/asc/copy.sh en|zh|es|ko
set -euo pipefail

lang="${1:-}"
case "${lang}" in
  en | zh | es | ko) ;;
  *)
    echo "用法: $0 en|zh|es|ko" >&2
    exit 1
    ;;
esac

dir="$(cd "$(dirname "$0")" && pwd)"
file="${dir}/desc_${lang}.txt"

if [[ ! -f "${file}" ]]; then
  echo "找不到 ${file}" >&2
  exit 1
fi

pbcopy < "${file}"
chars="$(wc -m < "${file}" | tr -d ' ')"

echo "已复制到剪贴板：${file}（${chars} 字符）"
echo "下一步：App Store Connect -> 我的 App -> Spy Assassin -> 左侧「版本（1.0）」"
echo "        -> 顶部语言下拉选语言 -> 「描述（Description）」框内全选删除 -> 粘贴（Cmd+V）-> 保存"
