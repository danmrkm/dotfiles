#!/bin/bash

# Mac標準ファイル比較ツール(Xcodeインストール必須)
opendiff fileA fileB

# 特定フィールドのみの文字検索

# 第3フィールドが sudo である行を抽出
cat something.log | awk '$3=="sudo"'

# 第5フィールドが sshd で始まる（正規表現）
cat something.log | awk '$5~/^sshd/'

# 3文字 month 表記を数字表記に変更
sed 's/Jan/01/' | sed 's/Feb/02/' | sed 's/Mar/03/' | sed 's/Apr/04/' | sed 's/Mar/05/' | sed 's/Jun/06/' | sed 's/Jul/07/' | sed 's/Aug/08/' | sed 's/Sep/09/' | sed 's/Oct/10/' | sed 's/Nov/11/' | sed 's/Dec/12/'

# 日付を正規化
# 形式は [dd/mm/yyyy:HH:MM:SS の場合
# ;以降の数字は並べ順
sed 's;\[\(..\)/\(..\)/\(....\):\(..\):\(..\):\(..\) ;\3\2\1\4\5\6;'

# JSTの時差表示を削除
sed 's/+0900]//'

# apache ログのフィールドをスペース区切りに
B='\(.*\)'
D='"\(.*\)"'
P='\[\(.*\)\]'
STR='\1\x0\2\x0\3\x0\4\x0\5\x0\6\x0\7\x0\8\x0\9\x0'

sed 's;\\\\;%5C;g' < /dev/stdin             |
sed 's;\\";%22;g'                           |
sed "s/^$B $B $B $P $D $B $B $D $D\$/$STR/" |
sed 's/_/\\_/g'                             |
sed 's/ /_/g'                               |
sed 's/\x0\x0/\x0_\x0/g'                    |
sed 's/\x0\x0/\x0_\x0/g'                    |
tr '\000' ' '                               |
sed 's/ $//'

# sort の高速化

# LANG=C + -s 安定ソートオプション
LANG=C sort -k1,1 -s SAMPLE_DATA

# sed の高速化
LANG=C sed

# xargs で並列処理
# -P でプロセス数 -n で引き継ぐ引数の数
ls SAMPLE_DATE_[1-9] |xargs -P 5 -n 1 gzip

# tr で文字削除
# カンマ削除
tr -d ,

# 文字コード関連
# 文字コード判定
nkf -g FILE

# Shift-JIS => UTF-8 への変換
nkf -Sw FILE

# UTF-8 => Shift-JIS への変換
nkf -Ws FILE

# 改行コード判別
file FILE

# CRLF->LF 改行コード変換
nkf -Lu FILE
nkf -d FILE

# LF->CRLF 改行コード変換
nkf -Lw FILE
nkf -c FILE

# Unix 環境 => Windows 環境 (UTF-8,LF -> Shift-JIS,CRLF)
nkf -Ws -c FILE

# Windows 環境 => Unix 環境 (Shift-JIS,CRLF -> UTF-8,LF)
nkf -Sw - FILE

