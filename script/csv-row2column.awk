BEGIN {
    FS = ","  # 设置字段分隔符为逗号
}
{
    # 读取每一行数据到二维数组
    for (i = 1; i <= NF; i++) {
        data[NR][i] = $i
    }
    # 更新最大列数
    max_col = (NF > max_col) ? NF : max_col
}
END {
    # 按列遍历并输出结果
    for (col = 1; col <= max_col; col++) {
        output = ""
        for (row = 1; row <= NR; row++) {
            # 拼接字段并用逗号分隔
            output = (row == 1) ? data[row][col] : output "," data[row][col]
        }
        print output
    }
}
