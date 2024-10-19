#!/bin/bash
# 适用于：2019-12-28 10.31.42.jpg

# 检查参数个数
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 directory"
  exit 1
fi

# 检查参数是否是一个目录
if [ ! -d "$1" ]; then
  echo "Error: $1 is not a directory"
  exit 1
fi

# 遍历目录下的所有文件
for file in "$1"/*; do
  # 检查是否是文件
  if [ -f "$file" ]; then
    # 提取文件名
    filename=$(basename -- "$file")

    # 提取日期时间部分（第一种格式）
    datetime=$(echo "$filename" | sed -E 's/.*([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}\.[0-9]{2}\.[0-9]{2}).*/\1/')

    # 检查提取到的日期时间部分是否有效（第一种格式）
    if [[ "$datetime" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}\.[0-9]{2}\.[0-9]{2}$ ]]; then
      # 按照下划线和横杠分割日期和时间
      year=$(echo "$datetime" | cut -d'-' -f1)
      month=$(echo "$datetime" | cut -d'-' -f2)
      day=$(echo "$datetime" | cut -d'-' -f3 | cut -d' '  -f1)
      hour=$(echo "$datetime" | cut -d' ' -f2 | cut -d'.' -f1)
      minute=$(echo "$datetime" | cut -d'.' -f2)
      second=$(echo "$datetime" | cut -d'.' -f3)

    # 提取日期时间部分（第二种格式）
    elif [[ "$filename" =~ -([0-9]{4}_[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}) ]]; then
      datetime="${BASH_REMATCH[1]}"

      # 按照下划线和横杠分割日期和时间
      year=$(echo "$datetime" | cut -d'_' -f1)
      month=$(echo "$datetime" | cut -d'_' -f2)
      day=$(echo "$datetime" | cut -d'_' -f3 | cut -d'-' -f1)
      hour=$(echo "$datetime" | cut -d'-' -f2)
      minute=$(echo "$datetime" | cut -d'-' -f3)
      second=$(echo "$datetime" | cut -d'-' -f4)

    else
      echo "Skipping file: $file (invalid date format)"
      continue
    fi

    # 打印解析出的日期和时间
    echo "Processing file: $file"
    echo "Year: $year, Month: $month, Day: $day, Hour: $hour, Minute: $minute, Second: $second"

    # 使用touch命令设置文件的创建时间
    touch -t "${year}${month}${day}${hour}${minute}.${second}" "$file"
  fi
done
