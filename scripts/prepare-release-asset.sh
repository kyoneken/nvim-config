#!/usr/bin/env bash
# タグ vX.Y.Z のコミットから、Git 履歴を含まない Release 用 zip と
# CHANGELOG の該当節を作る。
#
# 使い方: ./scripts/prepare-release-asset.sh v3.0.0
# CI では引数の代わりに GITHUB_REF_NAME を使う。
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

tag="${1:-${GITHUB_REF_NAME:-}}"
if [[ -z "$tag" ]]; then
  echo "タグを指定してください。例: v3.0.0" >&2
  exit 1
fi

if [[ ! "$tag" =~ ^v([0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?)$ ]]; then
  echo "タグは v1.2.3 または v1.2.3-rc.1 の形にしてください: ${tag}" >&2
  exit 1
fi
version="${BASH_REMATCH[1]}"
# CHANGELOG の見出し照合用。ドットを正規表現の任意文字にしない。
version_re="${version//./\\.}"

if ! awk -v ver="$version_re" '$0 ~ "^## \\[" ver "\\]([[:space:]]|$)" { found=1 } END { exit !found }' CHANGELOG.md; then
  echo "CHANGELOG.md に '## [${version}]' がありません。タグを打つ前に追記してください。" >&2
  exit 1
fi

outdir="${RELEASE_OUT_DIR:-$root/dist}"
mkdir -p "$outdir"
asset="$outdir/nvim-config-${tag}.zip"
notes="$outdir/release-notes.md"
rm -f "$asset" "$notes"

# 追跡ファイルだけを入れる。未追跡ファイルと .git は git archive の対象外。
git archive --format=zip --prefix="nvim-config-${tag}/" -o "$asset" HEAD

awk -v ver="$version_re" '
  $0 ~ "^## \\[" ver "\\]" { capture=1 }
  capture && /^## / && $0 !~ "^## \\[" ver "\\]" { exit }
  capture { print }
' CHANGELOG.md > "$notes"

if [[ ! -s "$notes" ]]; then
  echo "リリースノートを CHANGELOG から取り出せませんでした。" >&2
  exit 1
fi

listing="$(unzip -l "$asset")"
if ! grep -q "nvim-config-${tag}/init.lua" <<< "$listing"; then
  echo "アーカイブに init.lua がありません。" >&2
  exit 1
fi
if grep -q '/\.git/' <<< "$listing"; then
  echo "アーカイブに .git が含まれています。" >&2
  exit 1
fi

echo "asset=${asset}"
echo "notes=${notes}"
