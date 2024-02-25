#!/usr/bin/env python

import csv
import argparse
import os

T_DATE = 'T_Date'  # 交易日
P_DATE = 'PDate'  # 入账日期
CARD_NO = 'card_no'  # 卡号后四位
T_TYPE = 'type'  # 交易摘要
T_MERCHANT = 'merchant'  # 交易地点
T_AMT = 'amount'  # 交易金额/币种
STT_AMT = 'stt_amount'  # 入账金额/币种(支出为-)


def parse_data(filename):
    """
    从 txt 文本中解析数据并存储在 dict 中

    Args:
      filename: 待解析的 txt 文本文件名

    Returns:
      dict: 存储解析结果的字典
    """

    with open(filename, "r") as f:
        data = f.readlines()

        result = []
        for i in range(0, len(data), 7):
            # 交易日
            t_date = data[i].strip()

            # 入账日期
            p_date = data[i + 1].strip()

            # 卡号
            card_number = data[i + 2].strip()

            # 交易类型
            transaction_type = data[i + 3].strip()

            # 商户名称
            merchant_name = data[i + 4].strip()

            # 交易金额
            amount = data[i + 5].strip()

            # 入账金额
            stt_amount = data[i + 6].strip()

            result.append({
                T_DATE:     t_date,
                P_DATE:     p_date,
                CARD_NO:    card_number,
                T_TYPE:     transaction_type,
                T_MERCHANT: merchant_name,
                T_AMT:      amount,
                STT_AMT:    stt_amount,
            })

        return result
    pass


def output_csv(data, filename):
    """
    将数据输出成 csv 格式

    Args:
      data: 待输出的数据
      filename: 输出文件名
    """

    header = [T_DATE, P_DATE, CARD_NO, T_TYPE, T_MERCHANT, T_AMT, STT_AMT]
    with open(filename, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=header)
        writer.writeheader()
        writer.writerows(data)
    pass


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('input', type=str)
    parser.add_argument('output', type=str)
    args = parser.parse_args()

    # 待解析的 txt 文本文件名
    file_name = os.path.abspath(args.input)
    dump_file = os.path.abspath(args.output)

    # 解析数据
    data = parse_data(file_name)

    # 输出 csv 文件
    output_csv(data, dump_file)
