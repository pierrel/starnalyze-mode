(defun erase-other-buffer (buffer)
  "Erases all text in other buffer 'buffer'"
  (let ((working (current-buffer)))
    (set-buffer buffer)
    (erase-buffer)
    (set-buffer working)))

(defun do-lc ()
  "runs the do_LC program on the current file and opens the output in ghostview"
  (interactive)
  (let ((ghostview-out (get-buffer-create "ghostview-out"))
	(do-lc-out (get-buffer-create "do-lc-out"))
	(do-lc-output-filename "/tmp/V_both.par"))
    (erase-other-buffer ghostview-out)
    (save-buffer)
    (call-process
     "do_LC"
     nil do-lc-out nil
     (buffer-file-name)
     do-lc-output-filename)
    (start-process "ghostview" ghostview-out "ghostview" do-lc-output-filename)))

(define-minor-mode starnalyze-mode
  "Toggle Starnalyze mode.
Provides the do-lc function, which runs and displays
the results of do_LC on the file being edited in the
current buffer"
  :init-value t
  :lighter " Starnalyze"
  :keymap '(("\C-\M-d" . do-lc)))

(provide 'starnalyze-mode)