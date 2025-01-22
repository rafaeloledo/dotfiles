 (setq user-full-name "Rafael O. Ledo"
       user-mail-address "rafaeloliveiraledo@gmail.com")
(setq
 doom-font (font-spec :family "Hack Nerd Font" :size 18 :weight 'semi-light)
 doom-variable-pitch-font (font-spec :family "Hack Nerd Font" :size 16)
 doom-symbol-font (font-spec :family "Hack Nerd Font" :size 18)
 doom-serif-font (font-spec :family "Hack Nerd Font" :size 18))

(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)

(after! company
  (setq company-idle-delay nil))
(after! corfu
  (setq corfu-auto nil))
(setq doom-modeline-modal nil)
(setq evil-split-window-below t
      evil-vsplit-window-right t)
(setq evil-ex-substitute-global t)

(after! lsp-mode
  (setq lsp-enable-symbol-highlighting nil
        ;; If an LSP server isn't present when I start a prog-mode buffer, you
        ;; don't need to tell me. I know. On some machines I don't care to have
        ;; a whole development environment for some ecosystems.
        lsp-enable-suggest-server-download nil))
(after! lsp-ui
  (setq lsp-ui-sideline-enable nil  ; no more useful than flycheck
        lsp-ui-doc-enable nil))     ; redundant with K


(setq org-directory "~/sync/anotacoes/"
      org-roam-directory org-directory
      org-roam-db-location (file-name-concat org-directory ".org-roam.db")
      org-roam-dailies-directory "journal/"
      org-archive-location (file-name-concat org-directory ".archive/%s::")
      org-agenda-files (list org-directory))
