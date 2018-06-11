#!/usr/bin/env python

import csv
import sys
import os

if __name__ == '__main__':

    # 入力CSVファイルヘッダー
    IMPORT_CSVHEADER = ["#"]
    # 出力CSVファイルヘッダー
    OUTPUT_CSVHEADER = [""]


    # 引数取得
    args = sys.argv

    # 引数判定
    if len(args) != 3:
        print(
            'Usage: python3 ./exchange.py CSVFILE_PATH START_ID')
        quit()

    # CSVファイル存在チェック
    csvfilepath = args[1]
    if not (os.path.exists(csvfilepath)):
        print('Invalid csv file path.')
        quit()

    # START_ID
    start_couponid = args[2]

    with open('names.csv', newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            print(row['first_name'], row['last_name'])

