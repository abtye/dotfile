#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <glib.h>  // 需要安装GLib库

#define MAX_LINE_LENGTH 4096

GHashTable* fonts_table;

// 去除字符串首尾空白字符
char* trim_whitespace(char* str) {
    while (isspace((unsigned char)*str)) str++;
    
    if (*str == 0) return str;
    
    char* end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end)) end--;
    
    end[1] = '\0';
    return str;
}

// 处理Style行
void process_style_line(char* line) {
    char* font_field = strchr(line, ',');
    if (!font_field) return;
    
    font_field++;  // 跳过第一个逗号
    char* end = strchr(font_field, ',');
    if (!end) return;
    
    *end = '\0';  // 终止字体名字段
    char* font_name = trim_whitespace(font_field);
    
    if (*font_name) {
        g_hash_table_add(fonts_table, g_strdup(font_name));
    }
}

// 处理Dialogue行中的\fn标签
void process_dialogue_line(char* line) {
    char* fn_tag = line;
    while ((fn_tag = strstr(fn_tag, "\\fn")) != NULL) {
        fn_tag += 3;  // 跳过\fn
        
        char* end = fn_tag;
        while (*end && *end != '\\' && *end != '}') end++;
        
        char font_name[256];
        size_t len = end - fn_tag;
        if (len >= sizeof(font_name)) len = sizeof(font_name) - 1;
        
        strncpy(font_name, fn_tag, len);
        font_name[len] = '\0';
        
        char* trimmed = trim_whitespace(font_name);
        if (*trimmed) {
            g_hash_table_add(fonts_table, g_strdup(trimmed));
        }
        
        fn_tag = end;
    }
}

void process_file(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "警告: 无法打开文件 '%s'\n", filename);
        return;
    }
    
    char line[MAX_LINE_LENGTH];
    int is_ass_file = 0;
    
    while (fgets(line, sizeof(line), file)) {
        // 检查ASS文件签名
        if (!is_ass_file) {
            if (strstr(line, "[Script Info]") || strstr(line, "[V4+ Styles]")) {
                is_ass_file = 1;
            } else if (strstr(line, "[Events]") || strstr(line, "[Graphics]")) {
                is_ass_file = 1;
            }
        }
        
        // 处理Style行
        if (strncmp(line, "Style:", 6) == 0) {
            process_style_line(line + 6);
        }
        // 处理Dialogue行
        else if (strncmp(line, "Dialogue:", 9) == 0) {
            process_dialogue_line(line + 9);
        }
    }
    
    if (!is_ass_file) {
        fprintf(stderr, "警告: '%s' 似乎不是有效的ASS文件\n", filename);
    }
    
    fclose(file);
}

// 打印字体列表的回调函数
void print_font(gpointer key, gpointer value, gpointer user_data) {
    printf("%s\n", (char*)key);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "用法: %s <ass文件> [<ass文件> ...]\n", argv[0]);
        fprintf(stderr, "示例: %s subtitle.ass 或 %s *.ass\n", argv[0], argv[0]);
        return 1;
    }
    
    // 初始化哈希表(使用字符串集合)
    fonts_table = g_hash_table_new_full(g_str_hash, g_str_equal, free, NULL);
    
    for (int i = 1; i < argc; i++) {
        printf("正在分析: %s\n", argv[i]);
        process_file(argv[i]);
    }
    
    if (g_hash_table_size(fonts_table) > 0) {
        printf("\n找到的字体:\n");
        g_hash_table_foreach(fonts_table, print_font, NULL);
    } else {
        printf("没有找到字体信息\n");
    }
    
    g_hash_table_destroy(fonts_table);
    return 0;
}
