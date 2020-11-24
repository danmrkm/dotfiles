#!/bin/bash
# シェルオプションの指定
# -u: 未定義変数使用時に異常終了
# -o pipefail: パイプで渡した後のコマンドでエラー発生時に異常終了
set -uo pipefail

# このシェルスクリプトの使い方
show_usage() {
    echo "Usage: ${0} -h [IP or Hostname] -p [Port] -t [Timeout second]" 1>&2
    echo "example: ./wait-for-port.sh -h 127.0.0.1 -p 3306 -t 15" 1>&2
    exit 1
}

# オプション解析
# 4つのオプションが必須
NUMOPT=0
MODE=""

# デフォルトのタイムアウト秒数
TIMEOUT=30


while getopts h:p:t:h OPT
do
    case ${OPT} in
	# ホスト
	h)
	    HOST=${OPTARG}
	    ;;
	# ポート
	p)
	    PORT=${OPTARG}
	    ;;
	# タイムアウト秒数
	t)
	    TIMEOUT=${OPTARG}
	    ;;
	# ヘルプ
	h)
	    show_usage
	    ;;
	# その他
	\?)
	    show_usage
	    ;;
    esac
    NUMOPT=`expr ${NUMOPT} + 1`
done

# オプションをコマンドから削除
shift $((OPTIND - 1))

if [ ! "${HOST+foo}" ]
then
    show_usage
fi

if [ ! "${PORT+foo}" ]
then
    show_usage
fi


start_ts=$(date +%s)

while :
do

    nc -z ${HOST} ${PORT}
    result=$?
    end_ts=$(date +%s)


    if [[ ${result} -eq 0 ]]; then

        echo "${0}: ${HOST}:${PORT} is available after $((end_ts - start_ts)) seconds"
        break
    fi

    elapsed_time=`expr ${end_ts} - ${start_ts}`
    echo ${elapsed_time}

    if [[ ${elapsed_time} -gt ${TIMEOUT} ]]
    then
        echo "${0}: timeout"
	break
    fi
    sleep 1
done
