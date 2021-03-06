;;; init.el - -- GNU Emacs configuration file

;; Copyright (C) 2018 by DM

;;; Commentary:

;; This Configuration file is mainly written for macOS user.
;; Comments include Japanese.

;;; Code:

;; GNU Emacs 24 以降のみに適用
(when (>= emacs-major-version 24)

  ;; GC発動のメモリ閾値を80MBに変更
  (setq gc-cons-threshold (* gc-cons-threshold 100))

  ;; package.elを指定
  (require 'package)

  ;;melpa stableを追加
  (add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)
  ;; (add-to-list 'package-archives (cons "melpa-stable" "https://stable.melpa.org/packages/") t)

  ;;バージョンが27以下であれば、パッケージをイニシャライズ
  (when (< emacs-major-version 27)
    (package-initialize)
    )

  ;; インストールするパッケージ
  (defvar install-package-list
    '(
      ;; for auto-complete
      auto-complete fuzzy popup

      ;; csv mode
      csv-mode

      ;; buffer utils
      popwin elscreen

      ;; flycheck
      flycheck

      ;; python
      jedi py-autopep8 blacken django-mode

      ;; php
      php-mode ac-php

      ;; helm
      helm helm-gtags

      ;; quickrun
      quickrun

      ;; Javascript
      js-auto-format-mode

      ;; web
      web-mode

      ;; Swift
      swift-mode flycheck-swift

      ;; Go
      go-mode

      ;; multi-term
      multi-term

      ;; madhat2r
      madhat2r-theme

      ;; markdown-mode
      markdown-mode

      ;; yasnippet
      yasnippet django-snippets

      ;; Powershell
      powershell

      ;; Dockerfile
      dockerfile-mode

      ;; YAML
      yaml-mode

      ;; Highlight-indentation
      highlight-indentation

      ;; apache-mode
      apache-mode

      ;; groovy-mode
      groovy-mode
      ))

  (defvar install-package-list-ver25
    '(
      ;; git (ver25以上のみインストール)
      magit git-gutter
      ))


  ;; パッケージ情報更新フラグ設定
  (defvar package-refresh-flag t)

  ;; インストールされていないパッケージをインストールする
  (dolist (package install-package-list)

    (unless (package-installed-p package)
      ;; 初回のみパッケージ情報の更新
      (when '(package-refresh-flag)
	(package-refresh-contents)
	(setq package-refresh-flag nil)
	)

      (package-install package)))

  ;; インストールされていないパッケージをインストールする(バージョン25以上)
  (when (> emacs-major-version 25)
    (dolist (package install-package-list-ver25)

      (unless (package-installed-p package)
	;; 初回のみパッケージ情報の更新
	(when '(package-refresh-flag)
	  (package-refresh-contents)
	  (setq package-refresh-flag nil)
	  )

	(package-install package))))

  ;; package-desc-versをpackage--ac-desc-versionに変換(一部パッケージのエラー防止)
  (fset 'package-desc-vers 'package--ac-desc-version)

  )

;; Global setting  ++++++++++++++++++++++++++++++++++++++++++++++++++++++

;; バッファ再読み込み
(defun revert-buffer-no-confirm (&optional force-reverting)
  (interactive "P")
  (if (or force-reverting (not (buffer-modified-p)))
      (revert-buffer :ignore-auto :noconfirm)
    (error "The buffer has been modified")))

;;; スタートアップメッセージを非表示
(setq inhibit-startup-screen t)

;; バックアップファイルを作成しない
(setq make-backup-files nil)

;; 日本語対応
'(set-language-environment 'Japanese)
;; 優先文字コードをUTF-8に指定
'(prefer-coding-system 'utf-8)

;; カラム番号も表示
(column-number-mode t)

;; ベルを無効化
(setq ring-bell-function 'ignore)
;; ビジュアルベルを有効化
(setq visible-bell t)

;; "C-o" でウィンドウを切り替える。
(define-key global-map (kbd "C-o") 'other-window)

;; "M-n" で5行下に移動する
(define-key global-map (kbd "M-n") (kbd "C-u 5 C-n"))

;; "M-p" で5行上に移動する
(define-key global-map (kbd "M-p") (kbd "C-u 5 C-p"))

;; "C-c r" で全置換
(define-key global-map (kbd "C-c r") 'replace-string)

;; "C-c w" で whitespace-mode
(define-key global-map (kbd "C-c w") 'whitespace-mode)

;; "C-x r" でバッファ再読み込み
(define-key global-map (kbd "C-x r") 'revert-buffer-no-confirm)

;; paren-mode：対応する括弧を強調して表示する
;; 表示までの秒数。初期値は0.125
(setq show-paren-delay 0.02)
;; 有効化
(show-paren-mode t)
;; parenのスタイル: mixedは括弧内も強調表示
(setq show-paren-style 'mixed)

;; 環境変数設定
(add-to-list 'exec-path "/usr/local/bin")

;; 保存時に行末のスペースを削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; load-path に ~/.emacs.d/lisp を追加
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; PATH の設定
(let ((shellpaths (split-string (shell-command-to-string "env | grep '^PATH=' | sed 's/PATH=//; s/:/ /g'"))))
  (dolist (path shellpaths)
    (add-to-list 'exec-path path)))

;; Eshell ++++++++++++++++++++++++++++++++++++++++++++++++++++++

;; alias を設定
(defvar eshell-command-aliases-list
  (append
   (list
    (list "emacs" "find-file $1")
    )
   )
  )


;; Emacsのバージョンが24以上の場合に有効化
(when (> emacs-major-version 24)

  ;; GUI Emacs ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (when (or (eq window-system 'ns) (eq window-system 'mac))

    ;; Macのみ有効
    (when (eq system-type 'darwin)

      ;; MacのEmacsでファイル名を正しく扱うための設定
      (require 'ucs-normalize)
      (setq file-name-coding-system 'utf-8-hfs)
      (setq locale-coding-system 'utf-8-hfs)

      ;; Mac でファイルを開いたときに、新たなフレームを作らない
      (setq ns-pop-up-frames nil)

      ;; C-yでmacOSのクリップボードの内容を貼り付け
      ;; (defun copy-from-osx ()
      ;; 	(shell-command-to-string "pbpaste"))
      ;; (setq interprogram-paste-function 'copy-from-osx)

      ;; ;; EmacsのバッファをmacOSのクリップボードにコピー
      ;; (defun paste-to-osx (text &optional push)
      ;; 	(let ((process-connection-type nil))
      ;; 	  (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      ;; 	    (process-send-string proc text)
      ;; 	    (process-send-eof proc))))
      ;; (setq interprogram-cut-function 'paste-to-osx)

      (add-to-list 'default-frame-alist '(ns-appearance . dark))

      ;; サーバーモードで起動している Emacs がない場合はサーバを立ち上げる
      (when '(not '(server-running-p))
	(server-start)
	)

      )
    ;; ウィンドウ左に列数を表示
    (global-linum-mode t)

    ;; Themeをmadhat2rに設定
    (load-theme 'madhat2r t)
    ;; (load-theme 'manoj-dark t)
    ;; (load-theme 'dark-laptop t)

    ;; タイトルバーにファイルのフルパスを表示
    (setq frame-title-format "%f")
    (tool-bar-mode -1)

    ;; フレームの最大化
    (set-frame-parameter nil 'fullscreen 'maximized)

    ;;フレームの位置を指定
    ;; (setq initial-frame-alist
    ;;		(append (list '(width . 171)
    ;;			      '(height . 53)
    ;;			      '(top . 5)
    ;;			      '(left . 46)
    ;;			      )
    ;;			default-frame-alist))

    ;; Paren-mode
    ;; フェイスを変更する
    ;; (set-face-attribute 'show-paren-match-face nil
    ;; 			:background nil :foreground nil
    ;; 			:underline "#a9a9a9")

    ;; ediff
    ;; ediffコントロールパネルを別フレームにしない
    (setq ediff-window-setup-function 'ediff-setup-windows-plain)

    ;; C-x wでバッファを入れ替える関数
    (defun swap-screen()
      "Swap two screen,leaving cursor at current window."
      (interactive)
      (let ((thiswin (selected-window))
	    (nextbuf (window-buffer (next-window))))
	(set-window-buffer (next-window) (window-buffer))
	(set-window-buffer thiswin nextbuf)))

    ;; C-x wでバッファを入れ替える
    (define-key global-map (kbd "C-x w") 'swap-screen)

    ;; Emacs終了時に本当に終了してよいか確認する
    (setq confirm-kill-emacs 'y-or-n-p)


    )

  ;; php-mode ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  (when (package-installed-p 'php-mode)


    (autoload 'php-mode "php-mode" t nil)

    ;; 日本語ドキュメントを利用するための設定
    (with-eval-after-load "php-mode"
      '(setq php-site-url "https://secure.php.net/")
      '(setq php-manual-url 'ja)
      )

    (add-hook 'php-mode-hook '(lambda ()
				(auto-complete-mode t)
				;; (require 'ac-php)
				;; (setq ac-sources  '(ac-source-php ) )
				(yas-global-mode 1)
				(setq indent-tabs-mode t)
				;; (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
				;; (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back   ) ;go back
				))

    )



  ;; python-mode ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  ;; (defvar python-check-command "flake8")
  ;; Python-mode の場合、保存の際に py-autopep8 を実行する
  ;; 事前に autopep8 をインストールしておくこと
  ;; $ pip3 install autopep8
  (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
  (add-hook 'python-mode-hook 'flycheck-mode)
  (add-hook 'python-mode-hook 'highlight-indentation-mode)
  (add-hook 'python-mode-hook 'highlight-indentation-current-column-mode)
  (add-hook 'python-mode-hook 'blacken-mode)
  (custom-set-variables
   '(flycheck-python-flake8-executable "python3")
   '(flycheck-python-pycompile-executable "python3")
   '(flycheck-python-pylint-executable "python3"))

  ;; jedi ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  ;; jediを利用する場合は事前に下記のコマンドでvirtualenvをインストールしておくこと
  ;; $ brew install python3
  ;; $ pip3 install virtualenv

  ;; 初回実行時に M-x jedi:install-server を実行すること
  ;; エラーが発生する場合、以下コマンドを実行し、pyton-enviromnments ディレクトリを削除する
  ;; ~/.emacs.d/.python-environments/ を削除する
  (when (package-installed-p 'jedi)
    (add-hook 'python-mode-hook 'jedi:setup)
    (setq jedi:complete-on-dot t)
    )


  ;; auto-complete ++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (when (package-installed-p 'auto-complete)
    (when (require 'auto-complete-config nil t)
      (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
      (ac-config-default)
      (setq ac-use-menu-map t)
      (setq ac-ignore-case nil)
      )
    )

  ;; web-mode ++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (when (package-installed-p 'web-mode)
    (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.ctp\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  ;;; web-modeのインデント設定用フック
    ;; (defun web-mode-hook ()
    ;;   "Hooks for Web mode."
    ;;   (setq web-mode-markup-indent-offset 2) ; HTMLのインデイント
    ;;   (setq web-mode-css-indent-offset 2) ; CSSのインデント
    ;;   (setq web-mode-code-indent-offset 2) ; JS, PHP, Rubyなどのインデント
    ;;   (setq web-mode-comment-style 2) ; web-mode内のコメントのインデント
    ;;   (setq web-mode-style-padding 1) ; <style>内のインデント開始レベル
    ;;   (setq web-mode-script-padding 1) ; <script>内のインデント開始レベル
    ;;   )
    ;; (add-hook 'web-mode-hook  'web-mode-hook)
    (add-hook 'web-mode-hook
              '(lambda ()
		 (setq web-mode-enable-auto-indentation nil)))
    )

  ;; Flycheck ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  (when (package-installed-p 'flycheck)
    ;; Flycheck-modeを常時有効化
    (add-hook 'after-init-hook #'global-flycheck-mode)

    )

  ;; Javascript ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  (when (package-installed-p 'js-auto-format-mode)
    ;; js-auto-format-modeを常時有効化
    (add-hook 'js-mode-hook #'js-auto-format-mode)
    )

  ;; YAML-mode ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  (when (package-installed-p 'yaml-mode)

    ;; highlight-indentation
    (add-hook 'yaml-mode-hook 'highlight-indentation-mode)
    (add-hook 'yaml-mode-hook 'highlight-indentation-current-column-mode)

    )
  ;; quickrun ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  (when (package-installed-p 'quickrun)
    ;; "C-x q"でquickrunを起動
    (define-key global-map (kbd "C-x q") 'quickrun)
    )

  ;; Helm +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (when (package-installed-p 'helm)

    (require 'helm-config)
    (helm-mode 1)

    ;; C-x bをhelm-miniに割り当て
    (global-set-key (kbd "C-x b") 'helm-mini)
    (global-set-key (kbd "C-x C-b") 'helm-mini)
    ;; C-x C-fをhelm-find-filesに割り当て
    (global-set-key (kbd "C-x C-f") 'helm-find-files)
    ;; C-x eをhelm-recentfに割り当て
    (global-set-key (kbd "C-x e") 'helm-recentf)

    ;; タブとhel-execute-persistent-actionを入れ替える
    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
    )

  ;; multi-term ++++++++++++++++++++++++++++++++++++++++++++++++++++++

  (when (package-installed-p 'multi-term)
    ;; ログインシェルをbashに設定
    ;; (setq multi-term-program "/bin/bash")

    ;; C-x tでmulti-termを起動
    (define-key global-map (kbd "C-x t") 'multi-term)
    (define-key global-map (kbd "C-x p") 'multi-term-prev)

    ;; multi-term 上で用いるemacsコマンド
    (custom-set-variables
     '(term-bind-key-alist
       (quote
	(("C-c C-c" . term-interrupt-subjob)
	 ("C-c C-e" . term-send-esc)
	 ("C-s" . isearch-forward)
	 ("C-m" . term-send-return)
	 ("C-y" . term-paste)
	 ("M-f" . term-send-forward-word)
	 ("M-b" . term-send-backward-word)
	 ("M-o" . term-send-backspace)
	 ("M-p" . term-send-up)
	 ("M-n" . term-send-down)
	 ("M-M" . term-send-forward-kill-word)
	 ("M-N" . term-send-backward-kill-word)
	 ("M-r" . term-send-reverse-search-history)
	 ("M-," . term-send-raw)
	 ("M-." . comint-dynamic-complete)
	 )
	)
       )
     )


    )

  ;; gtags +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (when (package-installed-p 'helm-gtags)
    ;; gtagsを利用する場合は事前に下記のコマンドでgtagsをインストールしておくこと
    ;; $ brew install global --with-exuberant-ctags --with-pygments

    ;; (custom-set-variables
    ;;  ;; gtagsのキーバインドを有効化
    ;;  '(helm-gtags-suggested-key-mapping t)
    ;;  ;; ファイル保存時に自動的にタグをアップデートする
    ;;  '(helm-gtags-auto-update t)
    ;;  )

    ;; helm-gtags キーバインド
    (global-set-key (kbd "M-t") 'helm-gtags-find-tag)
    (global-set-key (kbd "M-r") 'helm-gtags-find-rtag)
    (global-set-key (kbd "M-s") 'helm-gtags-find-symbol)
    (global-set-key (kbd "C-t") 'helm-gtags-pop-stack))

  ;; magit +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (when (package-installed-p 'magit)
    (global-set-key (kbd "C-x g") 'magit-status)
    )

  ;; whitespace-mode +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (setq whitespace-style '(face           ; faceで可視化
			   trailing       ; 行末
			   tabs           ; タブ
			   spaces         ; スペース
			   empty          ; 先頭/末尾の空行
			   space-x`mark     ; 表示のマッピング
			   tab-mark
			   ))
  (setq whitespace-display-mappings
	'((space-mark ?\u3000 [?\u25a1])
	  (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])
	  ))
  ;; スペースは全角のみを可視化
  ;; (setq whitespace-space-regexp "\\(\u3000+\\)")
  (eval-after-load "whitespace"
    '(progn
       (set-face-attribute 'whitespace-trailing nil
			   :background "Yellow50"
			   :underline nil)
       (set-face-attribute 'whitespace-tab nil
			   :background "gray30"
			   :underline nil)
       (set-face-attribute 'whitespace-space nil
			   :background "gray20"
			   :foreground "white20"
			   :underline nil)
       ))

  ;; yasnippet +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ;; スニペット名をidoで選択する
  (setq yas-prompt-functions '(yas-ido-prompt))
  ;; snippetの格納場所を指定
  (setq yas-snippet-dirs
	'("~/.emacs.d/snippets"
	  "~/.emacs.d/my_snippets" ))
  ;; Yasnippet mode の有効化
  (yas-global-mode 1)

  ;; Highlight Indentation +++++++++++++++++++++++++++++++++++++++++++++++++
  (when (package-installed-p 'highlight-indentation)

    (require 'highlight-indentation)
    ;; Highlight Indentation
    (set-face-background 'highlight-indentation-face "#202020")
    (set-face-background 'highlight-indentation-current-column-face "#373d3f")

  )
  ;; recentf +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (setq recentf-max-saved-items 2000)
  ;; (setq recentf-auto-cleanup 10)
  (setq recentf-save-file "~/.emacs.d/.recentf")
  (setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1)

  ;; tramp +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (defun tramp-set-auto-save ()
    (auto-save-mode -1))

  ;; JSON +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (defun runjq (beg end)
    (interactive "r")
    (shell-command-on-region beg end "/usr/local/bin/jq ." nil t))

  ;; cisco-router-mode  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (require 'cisco-router-mode)

  ;; visual-basic-mode  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  (require 'visual-basic-mode)


  )

 ;;; Markdown Mode
(add-hook 'markdown-mode-hook
          '(lambda ()
             ;; "M-n" で5行下に移動する
             (define-key markdown-mode-map (kbd "M-n") (kbd "C-u 5 C-n"))

             ;; "M-p" で5行上に移動する
             (define-key markdown-mode-map (kbd "M-p") (kbd "C-u 5 C-p"))

             ))

;;; init.el ends here
