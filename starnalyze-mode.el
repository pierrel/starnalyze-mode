(defun erase-other-buffer (buffer)
  "Erases all text in other buffer 'buffer'"
  (let ((working (current-buffer)))
    (set-buffer buffer)
    (erase-buffer)
    (set-buffer working)))

(defun do-lc (line-file)
  "runs the do_LC program on the current file and opens the output in ghostview"
  (interactive "MLine File: (Defaults to V_both.par)")
  (let ((ghostview-out (get-buffer-create "ghostview-out"))
	(do-lc-out (get-buffer-create "do-lc-out"))
	(do-lc-line-filename (if (string= line-file "")
				 "V_both.par"
			       line-file)))
    (erase-other-buffer ghostview-out)
    (save-buffer)
    (message (concat "current directory is: " (shell-command-to-string "pwd")))
    (message (concat "Executing shell do_LC command: " 
		    "do_LC" " " 
		    (buffer-name) " " 
		    do-lc-line-filename))
    (shell-command (concat
		    "do_LC" " " 
		    (buffer-name) " " 
		    do-lc-line-filename))
    (message (concat "executing ghostview command: "
		     "gv " (replace-regexp-in-string ".par" ".ps" do-lc-line-filename) " &"))
    (shell-command (concat "gv --orientation=landscape " (replace-regexp-in-string ".par" ".ps" do-lc-line-filename) " &"))))

(define-minor-mode starnalyze-mode
  "Toggle Starnalyze mode.
Provides the do-lc function, which runs and displays
the results of do_LC on the file being edited in the
current buffer"
  :init-value t
  :lighter " Starnalyze"
  :keymap '(("\M-s" . do-lc)))

(provide 'starnalyze-mode)
(global-set-key "\M-s" 'do-lc)