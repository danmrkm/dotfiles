#!/bin/bash

# このシェルスクリプトの使い方
show_usage() {

    echo "Usage: $0 [-e] [-d] [-in input_file] [-out output_file] [-key key_file]" 1>&2
    echo "How to create keyfiles ..."
    echo "openssl req -x509 -nodes -newkey rsa:2048 -keyout private_ssl_key.pem -out public_key.pem -subj '/'"
    exit 1
}

# オプション解析
# 4つのオプションが必須
NUMOPT=0
while getopts edin:out:key:h OPT
do
    case $OPT in
        e)
	    if [ ${MODE} = "decrypt" ]
	    then
		echo 'Already select mode.'
		show_usage
	    fi
	    MODE="encrypt"
            ;;
        d)
	    if [ ${MODE} = "encrypt" ]
	    then
		echo 'Already select mode.'
		show_usage
	    fi
	    MODE="decrypt"
            ;;
	in)
	    INPUT_FILE="$OPTARG"
	    ;;
	out)
	    OUTPUT_FILE="$OPTARG"
	    ;;
        key)
	    KEY_FILE="$OPTARG"
	    ;;
	h)
	    show_usage
            ;;
        \?)
	    show_usage
            ;;
    esac
    NUMOPT=`expr ${NUMOPT} + 1`
done

# オプションをコマンドから削除
shift $((OPTIND - 1))

# オプション指定チェック
if [ ! ${NUMOPT} -eq 4 ]
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
    echo 'Already exist ' ${OUTPUT_FILE}
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
    echo "Encrypt " ${INPUT_FILE} "..."
    openssl smime -encrypt -aes256 -in ${INPUT_FILE} -binary -outform DEM -out ${OUTPUT_FILE} ${KEY_FILE}
    if [ $? -eq 0 ]
    then
	echo 'Encrypting process is succeed. Output file is ' ${OUTPUT_FILE}
	exit 0
    fi
fi

# 復号化モード
if [ ${MODE} = "decrypt" ]
then
    echo "Decrypt " ${INPUT_FILE} "..."
    openssl smime -decrypt -in ${INPUT_FILE} -binary -inform DEM -inkey ${KEY_FILE} -out ${OUTPUT_FILE}

    if [ $? -eq 0 ]
    then
	echo 'Decrypting process is succeed. Output file is ' ${OUTPUT_FILE}
	exit 0
    fi

fi



