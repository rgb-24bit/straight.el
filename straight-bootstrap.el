;;; straight-bootstrap.el --- bootsrap straight -*- lexical-binding: t; -*-

;;; Code:

;; This assures the byte-compiler that we know what we are doing when
;; we reference functions and variables from straight.el below. It
;; does not actually do anything at runtime, since the `straight'
;; feature has already been provided by loading straight.elc above.
(require 'straight)

;; In case this is a reinit, and straight.el was already loaded, we
;; have to explicitly clear the caches.
(straight--reset-caches)

;; We start by registering the default recipe repositories. This is
;; done first so that any dependencies of straight.el can be looked up
;; correctly.

;; This is kind of aggressive but we really don't have a good
;; mechanism at present for customizing the default recipe
;; repositories anyway. So don't even try to cater to that use case.
(setq straight-recipe-repositories nil)

(straight-use-recipes '(org-elpa :local-repo nil))

(straight-use-recipes '(melpa :type git :host github
                              :repo "melpa/melpa"
                              :build nil))

(if straight-recipes-gnu-elpa-use-mirror
    (straight-use-recipes
     '(gnu-elpa-mirror :type git :host github
                       :repo "emacs-straight/gnu-elpa-mirror"
                       :build nil))
  (straight-use-recipes `(gnu-elpa :type git
                                   :repo ,straight-recipes-gnu-elpa-url
                                   :local-repo "elpa"
                                   :build nil)))

(straight-use-recipes '(el-get :type git :host github
                               :repo "dimitri/el-get"
                               :build nil))

(if straight-recipes-emacsmirror-use-mirror
    (straight-use-recipes
     '(emacsmirror-mirror :type git :host github
                          :repo "emacs-straight/emacsmirror-mirror"
                          :build nil))
  (straight-use-recipes '(emacsmirror :type git :host github
                                      :repo "emacsmirror/epkgs"
                                      :nonrecursive t
                                      :build nil)))

(if (straight--modifications 'check-on-save)
    (straight-live-modifications-mode +1)
  (straight-live-modifications-mode -1))

(when (straight--modifications 'watch-files)
  (straight-watcher-start))

(if straight-use-symlinks
    (straight-symlink-emulation-mode -1)
  (straight-symlink-emulation-mode +1))

(if straight-enable-package-integration
    (straight-package-neutering-mode +1)
  (straight-package-neutering-mode -1))

(if straight-enable-use-package-integration
    (straight-use-package-mode +1)
  (straight-use-package-mode -1))

(provide 'straight-bootstrap)
;;; straight-bootstrap.el ends here
