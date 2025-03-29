#!/usr/bin/awk -f

# 保存所有行到数组
{
    file_lines[NR] = $0
}

END {
    # 收集有效行及其排序键
    valid_count = 0
    for (i = 1; i <= NR; i++) {
        line = file_lines[i]
        # 跳过注释和空行
        if (line ~ /^[[:space:]]*#/ || line ~ /^[[:space:]]*$/) continue
        # 分割字段
        split(line, parts, /[[:space:]]+/)
        if (length(parts) >= 2) {
            valid_count++
            valid_lines[valid_count] = line     # 保存完整行
            keys[valid_count] = parts[2]        # 提取排序键（第一个域名）
        }
    }

    # 使用冒泡排序对索引数组进行排序
    for (i = 1; i <= valid_count; i++) idx[i] = i
    for (i = 1; i <= valid_count; i++) {
        for (j = i+1; j <= valid_count; j++) {
            if (keys[idx[j]] < keys[idx[i]]) {
                temp = idx[i]
                idx[i] = idx[j]
                idx[j] = temp
            }
        }
    }

    # 重建排序后的有效行数组
    for (i = 1; i <= valid_count; i++) {
        sorted_valid[i] = valid_lines[idx[i]]
    }

    # 输出结果（保留原有行结构）
    valid_ptr = 1
    for (i = 1; i <= NR; i++) {
        line = file_lines[i]
        # 处理非有效行直接输出
        if (line ~ /^[[:space:]]*#/ || line ~ /^[[:space:]]*$/) {
            print line
            continue
        }
        # 处理有效行
        split(line, parts, /[[:space:]]+/)
        if (length(parts) >= 2) {
            if (valid_ptr <= valid_count) {
                print sorted_valid[valid_ptr++]
            } else {
                print line  # 处理意外情况
            }
        } else {
            print line      # 输出不符合格式的行
        }
    }
}
