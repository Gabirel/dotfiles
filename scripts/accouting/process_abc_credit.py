#!/usr/bin/env python3

import csv
import argparse
import os

T_DATE = 'T_Date'  # 交易日
P_DATE = 'PDate'  # 入账日期
NUMBER = 'number'  # 交易的顺序
CARD_NO = 'card_no'  # 卡号后四位
MERCHANT = 'merchant'  # 商户名称
T_AMT = 'amount'  # 交易金额/币种
STT_AMT = 'stt_amount'  # 入账金额/币种(支出为-)
FULL_DESCRIPTION = 'full_description'  # 金额值


def generate_full_date(raw: str) -> str:
    """
    生成完整的日期字符串: 25010101 -> 20250101
    """
    return f"20{raw}"


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
        step = 6
        i = 0
        number = 0
        prev_date = '20200101'

        while True:
            if i >= len(data):
                break

            print(f"i = #{i}")
            # 交易日
            t_date = generate_full_date(data[i].strip())
            if t_date < '20240101':
                print(f"parse error: t_date = '{t_date}'")
                exit(-1)

            # 入账日期
            p_date = generate_full_date(data[i + 1].strip())
            if p_date < '20240101':
                print(f"parse error: p_date = '{p_date}'")
                exit(-1)

            # 若日期发生未改变，则递增；否则状态更新重置为1
            if prev_date == p_date:
                number += 1
            else:
                prev_date = p_date
                number = 1

            # 卡号
            card_number = data[i + 2].strip()

            # 交易描述
            transaction_desc = data[i + 3].strip()

            # 交易金额
            amount = data[i + 4].strip()

            # 入账金额
            stt_amount = data[i + 5].strip()

            # 完整描述
            full_desc = transaction_desc

            result.append({
                T_DATE:           t_date,
                P_DATE:           p_date,
                NUMBER:           str(number),
                CARD_NO:          card_number,
                MERCHANT:         transaction_desc,
                T_AMT:            amount,
                STT_AMT:          stt_amount,
                FULL_DESCRIPTION: full_desc,
            })

            # next
            i = i + step
        pass
        return result
    pass


def output_csv(data, filename):
    """
    将数据输出成 csv 格式

    Args:
      data: 待输出的数据
      filename: 输出文件名
    """

    header = [T_DATE, P_DATE, NUMBER, CARD_NO, MERCHANT, T_AMT, STT_AMT, FULL_DESCRIPTION]
    with open(filename, "w", newline="", encoding='utf-8') as f:
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
