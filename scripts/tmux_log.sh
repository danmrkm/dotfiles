#!/bin/bash

# 各種パラメータ設定
DATESTR=`date "+%Y%m%d"`
LOG_DIR=${HOME}/.tmux.d/log/${DATESTR}
LOG_FILE=${LOG_DIR}/tmux_${DATESTR}_${1}.log

# ログ出力ディレクトリ作成
if [ ! -d ${LOG_DIR} ]
then
    mkdir -p ${LOG_DIR}
fi

# メッセージ出力
tmux display-message "Started logging to ${LOG_FILE}"

# pane-pipeからの出力をログファイルに記載
cat >> ${LOG_FILE}
