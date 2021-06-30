;;; Package --- summary
;;; Commentary:
;;; Code:

(use-package elfeed :ensure t)

(defun my/quality-to-ytdl--format (quality)
  "Helper fuction for my/elfeed-search-yt-to-mpv.
Returns the correct ytdl-format string associated with QUALITY."
  (let* ( (qua-fmt '(("144p" . "bestvideo[height<=144]+bestaudio/best[height<=144]")
                     ("240p" . "bestvideo[height<=240]+bestaudio/best[height<=240]")
                     ("360p" . "bestvideo[height<=360]+bestaudio/best[height<=360]")
                     ("480p" . "bestvideo[height<=480]+bestaudio/best[height<=480]")
                     ("720p" . "bestvideo[height<=720]+bestaudio/best[height<=720]")
                     ("1080p". "bestvideo[height<=1080]+bestaudio/best[height<=1080]")
                     ("1440p". "bestvideo[height<=1440]+bestaudio/best[height<=1440]")
                     ("2160p". "bestvideo[height<=2160]+bestaudio/best[height<=2160]"))))
    (cdr (assoc quality qua-fmt))))

(defun my/ytdl-get-quality-list (video-link)
  "Parse youtube-dl available quality settings for VIDEO-LINK.
Returns a list of the available quality settings.

NOTE: very efficient, not really elegant."
  (let* ((output (shell-command-to-string (concat "/usr/bin/youtube-dl --list-formats " video-link)))
         (quals '("144p" "240p" "360p" "480p" "720p" "1080p" "1440p" "2160p"))
         (rl '()))
    (with-temp-buffer
      (insert output)
      (goto-char (point-min))
      (dolist (q quals)
        (re-search-forward q nil t)
        (when (stringp (match-string 0 nil))
          (push (match-string 0) rl))))
    rl))

(defun my/yt-to--mpv (quality video-link)
  "Helper fuction for my/elfeed-search-yt-to-mpv.
QUALITY is a string of the type \"ytdl-format=<ytdl-format>\".
VIDEO-LINK is the link of the video to watch."
  (start-process "mpv-yt" nil "mpv" quality video-link)
  (message "[MPV] Loading youtube video to mpv..."))

(defun my/elfeed-search-yt-to-mpv ()
  "Send selected elfeed-search link to mpv/youtube-dl.
Prompt the user for preferred video quality in advance.
NOTE: audio is fixed to best."
  (interactive)
  (let ((entry (elfeed-search-selected :single)))
    (message "[MPV] Fetching available resolutions...")
    (my/yt-to--mpv
     (concat "--ytdl-format="
             (my/quality-to-ytdl--format
              (completing-read
               "Select video quality: "
               (my/ytdl-get-quality-list (elfeed-entry-link entry))
               nil t "")))
     (elfeed-entry-link entry))))


(defun my/create-elfeed-tags-table ()
  "Create hash-table from elfeed feeds, organized by tag (title in xml form)."
  (let* ((tag-feeds-hash (make-hash-table :test 'equal)))
    (dolist (e elfeed-feeds)
      (let* ((url (car e))
             (tag (car (cdr e))))
        (if (not (listp (gethash tag tag-feeds-hash)))
            (puthash tag (list url) tag-feeds-hash)
          (push url (gethash tag tag-feeds-hash)))))
    tag-feeds-hash))

(defun my/write-elfeed-to-opml (filename)
  "Copy elfeed's feeds in FILENAME using OPML format specs.
Exclude feeds tied to local services."
  (with-temp-file filename
    (insert "<?xml version=\"1.0\" encoding=\"utf-8\"?><opml version=\"2.0\"><body>")
    (let* ((table (my/create-elfeed-tags-table)))
      (dolist (k (hash-table-keys table))
        (insert (concat "<outline title=\"" (symbol-name k) "\">"))
        (let* ((l (gethash k table)))
          (dolist (e l)
            (when (not (numberp (string-match-p "^\\(http[[:lower:]]?://localhost:[[:digit:]]*\\)" e)))
              (insert (concat "<outline xmlUrl=\"" e "\"/>")))))
        (insert "</outline>")))
    (insert "</body></opml>")))

(defun my/elfeed-opml-sync (filename)
  "Interactive function to enable custom opml FILENAME sync."
  (interactive "fOutput file:")
  (my/write-elfeed-to-opml filename))

(defalias 'my/elfeed-syn-syncthing
  (my/elfeed-opml-sync (concat my/user-home "Sync" my/path-separator "opml-feed.xml"))
  "Quickly sync elfeed to syncthing folder opml-feeds.")

;; Add custom tag|color tuples
(push '(star diary-anniversary) elfeed-search-face-alist)
(push '(interesting font-lock-string-face) elfeed-search-face-alist)
(push '(unwatched default) elfeed-search-face-alist)

;; Mark all new youtube videos with alternative unread tag 'unwatched'
(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "youtube\\.com"
                              :add 'unwatched
                              :remove 'unread))

(defalias 'my/elfeed-search-toggle-star
  (elfeed-expose #'elfeed-search-toggle-all 'star))
(defalias 'my/elfeed-show-tag-star
  (elfeed-expose #'elfeed-show-tag 'star))
(defalias 'my/elfeed-search-toggle-interesting
  (elfeed-expose #'elfeed-search-toggle-all 'interesting))
(defalias 'my/elfeed-show-tag-interesting
  (elfeed-expose #'elfeed-show-tag 'interesting))
(defalias 'my/elfeed-search-toggle-unwatched
  (elfeed-expose #'elfeed-search-toggle-all 'unwatched))

(with-eval-after-load 'elfeed-search
  (define-key elfeed-show-mode-map (kbd "SPC")
    'elfeed-show-next))

(with-eval-after-load 'elfeed-show
  (define-key elfeed-show-mode-map (kbd "S-SPC")
    'elfeed-show-prev))

(with-eval-after-load 'elfeed-search
  (define-key elfeed-search-mode-map (kbd "m")
    'my/elfeed-search-toggle-star))

(with-eval-after-load 'elfeed-show
  (define-key elfeed-show-mode-map (kbd "m")
    'my/elfeed-show-tag-star))

(with-eval-after-load 'elfeed-search
  (define-key elfeed-search-mode-map (kbd "j")
    'my/elfeed-search-toggle-interesting))

(with-eval-after-load 'elfeed-show
  (define-key elfeed-show-mode-map (kbd "j")
    'my/elfeed-show-tag-interesting))

(with-eval-after-load 'elfeed-search
  (define-key elfeed-search-mode-map (kbd "v")
    'my/elfeed-search-toggle-unwatched))

(with-eval-after-load 'elfeed-search
  (define-key elfeed-search-mode-map (kbd "V")
    'my/elfeed-search-yt-to-mpv))

(add-hook 'kill-emacs-hook #'my/elfeed-syn-syncthing)

(provide 'init-drd-newsfeed)
;;; init-drd-newsfeed.el ends here
