#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/types.h"
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/stat.h"  // 包含 struct stat 定义和 T_DIR 等类型宏
#include "user.h"
#include "/home/liuzhh268/Operating_System_Homework/xv6/xv6-labs-2024/kernel/fs.h"    // 包含 struct dirent 定义和 DIRSIZ

// 函数：格式化文件名，去除路径前缀，只留下文件名部分
// 例如：输入 "a/b/c"，返回指向 "c" 的指针
char* fmtname(char *path) {
    static char buf[DIRSIZ+1]; // 静态缓冲区存储文件名
    char *p;

    // 从路径末尾向前查找第一个 '/'
    for(p=path+strlen(path); p >= path && *p != '/'; p--)
        ;
    p++; // p 指向最后一个 '/' 之后或路径开头

    // 如果文件名太长，则直接返回 p （指向原始路径中的文件名部分）
    if(strlen(p) >= DIRSIZ)
        return p;
    // 否则，将文件名复制到静态缓冲区 buf 中
    memmove(buf, p, strlen(p));
    buf[strlen(p)] = 0; // 添加 null 终止符
    return buf; // 返回指向 buf 的指针
}

// 函数：递归查找
// path: 当前要搜索的目录路径
// filename: 要查找的目标文件名
void find(char *path, char *filename) {
    char buf[512], *p; // 缓冲区用于构建子路径
    int fd;             // 文件描述符
    struct dirent de;   // 目录项结构体
    struct stat st;     // 文件状态结构体

    // 尝试打开当前路径对应的目录
    if((fd = open(path, 0)) < 0){
        fprintf(2, "find: cannot open %s\n", path);
        return; // 打开失败，直接返回
    }

    // 获取当前路径的文件状态
    if(fstat(fd, &st) < 0){
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return; // 获取状态失败，关闭文件描述符后返回
    }

    // 检查当前路径是否确实是一个目录
    if (st.type != T_DIR) {
         fprintf(2, "find: %s is not a directory\n", path);
         close(fd);
         return; // 不是目录，关闭文件描述符后返回
    }

    // 确保路径缓冲区足够大
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
        fprintf(2, "find: path too long\n");
        close(fd);
        return; // 路径可能过长，关闭文件描述符后返回
    }
    strcpy(buf, path); // 将当前路径复制到缓冲区
    p = buf+strlen(buf); // p 指向路径末尾
    *p++ = '/'; // 在路径末尾添加 '/'，并将 p 后移

    // 读取目录项
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
        // 跳过无效的目录项 (inum 为 0)
        if(de.inum == 0)
            continue;

        // 跳过 "." 和 ".." 目录项，防止无限递归
        if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
            continue;

        // 构建当前目录项的完整路径
        memmove(p, de.name, DIRSIZ); // 将目录项名称复制到路径末尾
        p[DIRSIZ] = 0; // 确保字符串结束 (虽然 de.name 可能不满 DIRSIZ)
                       // 更好的做法是: strncpy(p, de.name, DIRSIZ); p[DIRSIZ] = 0;
                       // 或者: uint len = strlen(de.name); memmove(p, de.name, len); p[len] = 0;


        // 获取这个目录项的文件状态
        if(stat(buf, &st) < 0){
            fprintf(2, "find: cannot stat %s\n", buf);
            continue; // 获取状态失败，继续下一个目录项
        }

        // 根据文件类型进行处理
        switch(st.type){
        case T_FILE: // 如果是文件
            // 比较文件名是否与目标文件名匹配
            if (strcmp(de.name, filename) == 0) {
                // 匹配则打印完整路径
                printf("%s\n", buf);
            }
            break;

        case T_DIR: // 如果是目录
            // 递归调用 find，搜索子目录
            find(buf, filename);
            break;
        }
    }

    // 关闭当前目录的文件描述符
    close(fd);
}

// 主函数
int main(int argc, char *argv[]) {
    // 检查命令行参数数量是否正确 (程序名 + 路径 + 文件名)
    if(argc != 3){
        fprintf(2, "用法: find <目录路径> <文件名>\n");
        exit(1); // 参数错误，退出
    }

    // 调用递归查找函数
    find(argv[1], argv[2]);

    // 程序正常结束
    exit(0);
}