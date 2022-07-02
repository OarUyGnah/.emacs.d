;;在文件最开头添加地个 文件作用域的变量设置，设置变量的绑定方式
;; -*- lexical-binding: t -*-





;;镜像源
(require 'package)
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			 ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
;;(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)
;;防止反复调用 package-refresh-contents 会影响加载速度
(when (not package-archive-contents)
  (package-refresh-contents))


;; 更改显示字体大小 16pt
;; http://stackoverflow.com/questions/294664/how-to-set-the-font-size-in-emacs
(set-face-attribute 'default nil :height 170)

(setq tab-always-indent 'complete)
;(icomplete-mode t)

;;让鼠标滚动更好用                滚轮一次3行
(setq mouse-wheel-scroll-amount '(3((shift). 1) ((meta)) ((control)  . nil)))
;;(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; 关闭工具栏，tool-bar-mode 即为一个 Minor Mode
(tool-bar-mode -1) ;;-1 close 1 open

;; 关闭文件滑动控件
(scroll-bar-mode -1)

;; 显示行号
(global-linum-mode 1)

;; 更改光标的样式（不能生效，解决方案见5day）
;;setq更改为setq-default
(setq-default cursor-type '(bar . 3)) ;;光标长度3
;;显示对应的括号
(show-paren-mode t)




;; 快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(defun switch-buffer()
  (switch-to-buffer))

(defun eshell-cd-to-current-openfile-location()
  (interactive)
  (eshell))

;; 这一行代码，将函数 open-init-file 绑定到 <f2> 键上
(global-set-key (kbd "<f2>") 'open-init-file)
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)
(global-set-key (kbd "C-c q") 'quit-window)
(global-set-key (kbd "C-c s") 'eshell)

;;打开eshell在当前文件的目录下(待完成...)
;;(global-set-key (kbd "C-c s") 'eshell-cd-to-current-openfile-location)


; 开启全局 Company 补全
(global-company-mode 1)
(setq company-minimum-prefix-length 1);;最小补全，即出现一个字母就开始
(setq company-idle-delay 0);;快速补全
;; Company mode 默认选择上一条和下一条候选项命令 M-n M-p
;;通过以下define-key可以使用C-n和C-p使用，同时M-n M-p也可以使用，但不会影响上下行的移动
;;不是company-mode-map,否则C-n和C-p无法执行上下行移动
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

;;modeline上显示我的所有的按键和执行的命令
(package-install 'keycast)
(keycast-mode t)
;;minibuffer============================================
;;增强minibuffer补全：
(package-install 'vertico)
(vertico-mode t)
(package-install 'orderless)
(setq completion-styles '(orderless))
;;增强minubuffer的annotation
(package-install 'marginalia)
(marginalia-mode t)

(package-install 'embark)
(global-set-key (kbd "C-;") 'embark-act)
;;可以C-x C-h 进行功能搜索
(setq prefix-help-command 'embark-prefix-help-command)

(package-install 'consult)
;;replace swiper 增强关键字搜索，快速查找到关键字在的行
(global-set-key (kbd "C-s") 'consult-line)
;;consult-imenu
(global-set-key (kbd "M-s M-s") 'consult-imenu)

;;minibuffer============================================

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/awesome-tab"))

(require 'awesome-tab)

(awesome-tab-mode t)
(defun awesome-tab-buffer-groups ()
"`awesome-tab-buffer-groups' control buffers' group rules.
Group awesome-tab with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
All buffer name start with * will group to \"Emacs\".
Other buffer group by `awesome-tab-get-group-name' with project name."
(list
(cond
    ((or (string-equal "*" (substring (buffer-name) 0 1))
	(memq major-mode '(magit-process-mode
			    magit-status-mode
			    magit-diff-mode
			    magit-log-mode
			    magit-file-mode
			    magit-blob-mode
			    magit-blame-mode)))
    "Emacs")
    ((derived-mode-p 'eshell-mode)
    "EShell")
    ((derived-mode-p 'dired-mode)
    "Dired")
    ((memq major-mode '(org-mode org-agenda-mode diary-mode))
    "OrgMode")
    ((derived-mode-p 'eaf-mode)
    "EAF")
    (t
    (awesome-tab-get-group-name (current-buffer))))))

;;不再生成备份文件~
(setq make-backup-files nil)

;;更快捷的在图形界面的菜单中打开最近编辑过的文件
;;M-x 输入recentf-open-files查看最近打开过的文件
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 17)
;;绑定C-x b 使其不仅能显示buffer还可显示最近打开的文件
(global-set-key (kbd "C-x b") 'consult-buffer)

;;选中一段文字输入后直接将旧文本替换
(delete-selection-mode t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(consult embark marginalia orderless vertico keycast ggtags org-modern company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


