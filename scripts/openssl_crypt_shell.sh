#!/bin/bash

# このシェルスクリプトの使い方
show_usage() {
    echo "Usage: $0 [-e] [-d] [-i input_file] [-o output_file] [-k key_file]" 1>&2
    echo "How to create keyfiles ..."
    echo "openssl req -x509 -nodes -newkey rsa:2048 -keyout private_ssl_key.pem -out public_key.pem -subj '/'"
    exit 1
}

# オプション解析
# 4つのオプションが必須
NUMOPT=0
MODE=""

while getopts edi:o:k:h OPT
do
    case ${OPT} in
	# 暗号化モード
	e)
	    if [ "${MODE}" = "decrypt" ]
	    then
		echo 'Already specified [-d] option.'
		show_usage
	    fi
	    MODE="encrypt"
	    ;;
	# 復号化モード
	d)
	    if [ "${MODE}" = "encrypt" ]
	    then
		echo 'Already specified [-e] option.'
		show_usage
	    fi
	    MODE="decrypt"
	    ;;
	# 暗号 or 復号元のファイルパス
	i)
	    INPUT_FILE=${OPTARG}
	    echo ${OPTARG}
	    ;;
	# 出力ファイルパス
	o)
	    OUTPUT_FILE="$OPTARG"
	    ;;
	# 暗号 or 復号に用いる鍵ファイルパス
	k)
	    KEY_FILE="$OPTARG"
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

# オプション指定チェック
if [ ! ${NUMOPT} -gt 3 ]
then
    echo 'too few options..'
    show_usage
fi

# ファイル存在チェック
if [ ! -e ${INPUT_FILE} ]
then
    echo 'Not found' ${INPUT_FILE}
    exit 1

elif [ -e ${OUTPUT_FILE} ]
then
    echo 'Already exist' ${OUTPUT_FILE}
    echo 'Do you delete' ${OUTPUT_FILE} "? [y/n]"
    read yn
    if [ ! ${yn} = 'y' ]
    then
	echo 'Exit program'
	exit 1
    fi
    rm ${OUTPUT_FILE}
elif [ ! -e ${KEY_FILE} ]
then
    echo 'Not found' ${KEY_FILE}
    exit 1
fi

# 暗号化モード
if [ ${MODE} = "encrypt" ]
then
    echo "Encrypt" ${INPUT_FILE} "..."
    openssl smime -encrypt -aes256 -in ${INPUT_FILE} -binary -outform DEM -out ${OUTPUT_FILE} ${KEY_FILE}
    if [ $? -eq 0 ]
    then
	echo 'Encrypting process is succeed. Output file is' ${OUTPUT_FILE}
	exit 0
    fi
fi

# 復号化モード
if [ ${MODE} = "decrypt" ]
then
    echo "Decrypt" ${INPUT_FILE} "..."
    openssl smime -decrypt -in ${INPUT_FILE} -binary -inform DEM -inkey ${KEY_FILE} -out ${OUTPUT_FILE}

    if [ $? -eq 0 ]
    then
	echo 'Decrypting process is succeed. Output file is' ${OUTPUT_FILE}
	exit 0
    fi

fi
