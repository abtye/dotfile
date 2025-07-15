import tkinter as tk
from tkinter import filedialog, font, BooleanVar, messagebox, ttk
import os
import logging
from typing import List, Dict, Optional
import subprocess
from pathlib import Path
from dataclasses import dataclass
from concurrent.futures import ThreadPoolExecutor
import threading

# 常量定义
WINDOW_TITLE = "KGM 音频转换器"
WINDOW_SIZE = "500x400"
INITIAL_DIR = "/home/lin/kgm/kgms"
CONFIG_FILE = "notKeepSourceFile.txt"
DECODER_PATH = "./kgm-decoder"


@dataclass
class ConversionResult:
    success: bool
    file_path: str
    error_message: Optional[str] = None


class KGMConverter:
    def __init__(self):
        self.root = tk.Tk()
        self.file_paths: List[str] = []
        self.is_keep_source_file = BooleanVar(value=True)
        self.setup_ui()
        self.load_config()

    def setup_ui(self):
        """设置UI界面"""
        self.root.geometry(WINDOW_SIZE)
        self.root.title(WINDOW_TITLE)

        # 创建主框架
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.pack(fill=tk.BOTH, expand=True)

        # 文件选择区域
        self.label_number_of_files = ttk.Label(main_frame, text="请选择要转换的文件")
        self.label_number_of_files.pack(pady=5)

        # 使用Treeview替代Listbox，提供更好的显示效果
        self.file_tree = ttk.Treeview(main_frame, columns=("路径",), show="headings", height=6)
        self.file_tree.heading("路径", text="文件路径")
        self.file_tree.pack(fill=tk.BOTH, expand=True, pady=5)

        # 添加滚动条
        scrollbar = ttk.Scrollbar(main_frame, orient=tk.VERTICAL, command=self.file_tree.yview)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.file_tree.configure(yscrollcommand=scrollbar.set)

        # 按钮区域
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill=tk.X, pady=10)

        self.choose_button = ttk.Button(
            button_frame,
            text="选择文件（支持多选）",
            command=self.choose_files
        )
        self.choose_button.pack(side=tk.LEFT, padx=5)

        self.convert_button = ttk.Button(
            button_frame,
            text="开始转换",
            command=self.start_conversion
        )
        self.convert_button.pack(side=tk.LEFT, padx=5)

        # 进度条
        self.progress_var = tk.DoubleVar()
        self.progress_bar = ttk.Progressbar(
            main_frame,
            variable=self.progress_var,
            maximum=100
        )
        self.progress_bar.pack(fill=tk.X, pady=5)

        # 选项区域
        self.keep_source_checkbox = ttk.Checkbutton(
            main_frame,
            text="保留源文件",
            variable=self.is_keep_source_file
        )
        self.keep_source_checkbox.pack(pady=5)

        # 状态标签
        self.status_label = ttk.Label(main_frame, text="就绪")
        self.status_label.pack(pady=5)

    def choose_files(self):
        """选择文件处理"""
        new_files = filedialog.askopenfilenames(
            initialdir=INITIAL_DIR,
            title="选择 KGM 文件",
            filetypes=[("KGM文件", "*.kgm")]
        )

        if not new_files:
            return

        self.file_paths = list(new_files)
        self.update_file_list()

    def update_file_list(self):
        """更新文件列表显示"""
        self.file_tree.delete(*self.file_tree.get_children())
        for path in self.file_paths:
            self.file_tree.insert("", "end", values=(path,))
        self.label_number_of_files.configure(text=f"已选择 {len(self.file_paths)} 个文件")

    def convert_single_file(self, file_path: str) -> ConversionResult:
        """转换单个文件"""
        try:
            output_path = Path(file_path).with_suffix('.mp3')
            if output_path.exists():
                output_path.unlink()

            cmd = [DECODER_PATH]
            if self.is_keep_source_file.get():
                cmd.append("-k")
            cmd.append(file_path)

            result = subprocess.run(cmd, capture_output=True, text=True)

            if result.returncode != 0:
                return ConversionResult(False, file_path, result.stderr)
            return ConversionResult(True, file_path)

        except Exception as e:
            return ConversionResult(False, file_path, str(e))

    def start_conversion(self):
        """开始转换流程"""
        if not self.file_paths:
            messagebox.showwarning("警告", "请先选择要转换的文件！")
            return

        self.convert_button.configure(state="disabled")
        self.choose_button.configure(state="disabled")
        self.progress_var.set(0)

        def conversion_thread():
            total_files = len(self.file_paths)
            successful = 0
            failed = 0

            with ThreadPoolExecutor(max_workers=4) as executor:
                for idx, result in enumerate(executor.map(self.convert_single_file, self.file_paths), 1):
                    if result.success:
                        successful += 1
                    else:
                        failed += 1
                        logging.error(f"转换失败: {result.file_path}, 错误: {result.error_message}")

                    progress = (idx / total_files) * 100
                    self.progress_var.set(progress)
                    self.status_label.configure(text=f"正在转换... ({idx}/{total_files})")

            self.status_label.configure(text=f"转换完成！成功: {successful}, 失败: {failed}")
            self.convert_button.configure(state="normal")
            self.choose_button.configure(state="normal")

            if failed > 0:
                messagebox.showwarning("转换完成", f"转换完成，但有 {failed} 个文件失败，请查看日志了解详情。")
            else:
                messagebox.showinfo("转换完成", "所有文件转换成功！")

        threading.Thread(target=conversion_thread, daemon=True).start()

    def load_config(self):
        """加载配置"""
        self.is_keep_source_file.set(not os.path.exists(CONFIG_FILE))

    def save_config(self):
        """保存配置"""
        if self.is_keep_source_file.get():
            if os.path.exists(CONFIG_FILE):
                os.remove(CONFIG_FILE)
        else:
            Path(CONFIG_FILE).touch()

    def run(self):
        """运行应用"""
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)
        self.root.mainloop()

    def on_closing(self):
        """关闭窗口处理"""
        self.save_config()
        self.root.destroy()


if __name__ == "__main__":
    # 配置日志
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        filename='converter.log'
    )

    app = KGMConverter()
    app.run()
