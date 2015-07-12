
;;; j-font-lock.el --- font-lock extension for j-mode

;; Copyright (C) 2012 Zachary Elliott
;;
;; Authors: Zachary Elliott <ZacharyElliott1@gmail.com>
;; URL: http://github.com/zellio/j-mode
;; Version: 1.1.1
;; Keywords: J, Langauges

;; This file is not part of GNU Emacs.

;;; Commentary:

;; `j-mode` font-lock provides four new faces for management of the coloring
;; various parts of speech. Those faces are `j-verb-face` `j-adverb-face`
;; `j-conjunction-face` `j-other-face`. They can be modified like any of the
;; standard built in faces to help meet your need.
;;
;; (custom-set-face
;;  '(j-verb-face ((t (:foreground "Red"))))
;;  '(j-adverb-face ((t (:foreground "Green"))))
;;  '(j-conjunction-face ((t (:foreground "Blue"))))
;;  '(j-other-face ((t (:foreground "Black")))))

;;; License:

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 3 of the License, or (at your option) any later
;; version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along with
;; GNU Emacs; see the file COPYING.  If not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
;; USA.

;;; Code:


;; (defconst j-font-lock-version "1.1.1"
;;   "`j-font-lock' version")

(defgroup j-font-lock nil
  "font-lock extension for j-mode"
  :group 'j
  :prefix "j-font-lock-")


(defgroup j-faces nil
  "Faces for j-font-lock"
  :group 'j
  :group 'j-font-lock)

(defvar j-verb-face
  (defface j-verb-face
    `((t (:foreground "Red")))
  "Font Lock mode face used to higlight vrebs"
  :group 'j-faces))

(defvar j-adverb-face
  (defface j-adverb-face
    `((t (:foreground "Green")))
  "Font Lock mode face used to higlight adverbs"
  :group 'j-faces))

(defvar j-conjunction-face
  (defface j-conjunction-face
    `((t (:foreground "Blue")))
  "Font Lock mode face used to higlight conjunctions"
  :group 'j-faces))

(defvar j-other-face
  (defface j-other-face
    `((t (:foreground "Black")))
  "Font Lock mode face used to higlight others"
  :group 'j-faces))

(makunbound 'j-font-lock-syntax-table)
(defvar j-font-lock-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\% "_"   table)
    (modify-syntax-entry ?\$ "_"   table)
    (modify-syntax-entry ?\{ "_"   table)
    (modify-syntax-entry ?\} "_"   table)
    (modify-syntax-entry ?\[ "_"   table)
    (modify-syntax-entry ?\] "_"   table)
    (modify-syntax-entry ?\" "_"   table)
    (modify-syntax-entry ?\\ "_"   table)
    (modify-syntax-entry ?\. "_"   table)
    (modify-syntax-entry ?\: "_"   table)
    (modify-syntax-entry ?\( "()"  table)
    (modify-syntax-entry ?\) ")("  table)
    (modify-syntax-entry ?\' "$"   table)
    (modify-syntax-entry ?\N "w 1" table)
    (modify-syntax-entry ?\B "w 2" table)
    (modify-syntax-entry ?\n ">"   table)
    (modify-syntax-entry ?\r ">"   table)
    table)
  "Syntax table for j-mode")

(defvar j-font-lock-constants '())

(defvar j-font-lock-control-structures
  '("assert."  "break."  "continue."  "while."  "whilst."  "for."  "do."  "end."
    "if."  "else."  "elseif."  "return."  "select."  "case."  "fcase."  "throw."
    "try."  "catch."  "catchd."  "catcht."  "end."
    ;; "for_[a-zA-Z]+\\."  "goto_[a-zA-Z]+\\."  "label_[a-zA-Z]+\\."
    ))

(defvar j-font-lock-foreign-conjunctions
  '("0!:" "1!:" "2!:" "3!:" "4!:" "5!:" "6!:" "7!:" "8!:" "9!:" "11!:" "13!:"
    "15!:" "18!:" "128!:" ))

(defvar j-font-lock-len-3-verbs
  '("_9:" "p.." "{::"))
(defvar j-font-lock-len-2-verbs
  '("x:" "u:" "s:" "r." "q:" "p:" "p." "o." "L." "j." "I." "i:" "i." "E." "e."
    "C." "A." "?." "\":" "\"." "}:" "}." "{:" "{." "[:" "/:" "\\:" "#:" "#." ";:" ",:"
    ",." "|:" "|." "~:" "~." "$:" "$." "^." "%:" "%." "-:" "-." "*:" "*."  "+:"
    "+." "_:" ">:" ">." "<:" "<."))
(defvar j-font-lock-len-1-verbs
  '("?" "{" "]" "[" ":" "!" "#" ";" "," "|" "$" "^" "%" "-" "*" "+" ">" "<" "="))
(defvar j-font-lock-verbs
  (append j-font-lock-len-3-verbs j-font-lock-len-2-verbs j-font-lock-len-1-verbs))

(defvar j-font-lock-len-2-adverbs
  '("t:" "t." "M." "f." "b." "/."))
(defvar j-font-lock-len-1-adverbs
  '("}" "." "\\" "/" "~"))
(defvar j-font-lock-adverbs
  (append j-font-lock-len-2-adverbs j-font-lock-len-1-adverbs))

(defvar j-font-lock-len-3-others
  '("NB."))
(defvar j-font-lock-len-2-others
  '("=." "=:" "_." "a." "a:"))
(defvar j-font-lock-len-1-others
  '("_" ))
(defvar j-font-lock-others
  (append j-font-lock-len-3-others j-font-lock-len-2-others j-font-lock-len-1-others))

(defvar j-font-lock-len-3-conjunctions
  '("&.:"))
(defvar j-font-lock-len-2-conjunctions
  '("T." "S:" "L:" "H." "D:" "D." "d." "&:" "&." "@:" "@." "`:" "!:" "!." ";."
    "::" ":." ".:" ".." "^:"))
(defvar j-font-lock-len-1-conjunctions
  '("&" "@" "`" "\"" ":" "."))
(defvar j-font-lock-conjunctions
  (append j-font-lock-len-3-conjunctions
          j-font-lock-len-2-conjunctions
          j-font-lock-len-1-conjunctions))

(makunbound 'j-prettify-symbols-alist)
(defvar j-prettify-symbols-alist
  '(("NB." . ?⍝)
    ("_" . ?∞)
    ("__" . "∞̅")
    ("_." . "∞̇")
    ("=:" . ?⇷)
    ("=." . ?←)
    ("<:" . ?≤)
    ("<." . ?⌊)
    (">:" . ?≥)
    (">." . ?⌈)
    ("+:" . "∨̃")
    ("+." . ?∨)
    ("*:" . "∧̃")
    ("*." . ?∧)
    ("*" . ?×)
    ("-:" . ?≡)
    ("-." . ?∼)
    ("%:" . ?√)
    ("%." . ?⌹)
    ("%" . ?÷)
    ("^:" . ?⍣)
    ("^." . ?⍟)
    ("^" . ?⋆)
    ("$:" . ?∇)
    ("$." . "⍴̲")
    ("$" . ?⍴)
    ("~:" . ?≠)
    ("~." . ?∪)
    ("~" . ?⍨)
    ("|:" . ?⍉)
    ("|." . ?⌽)
    (".." . "⋅̈")
    (".:" . "⋅̲")
    (" . " . ?.)
    (",:" . ",̈")
    (",." . ?⍪)
    (";:" . ";̈")
    (";." . ";̇")
    ("#:" . ?⊤)
    ("#." . ?⊥)
    ("!:" . ?⌶)
    ("!." . ?⍠)
    ("/:" . ?⍋)
    ("/." . ?⌸)
    ("\\:" . ?⍒)
    ("\\." . ?⍀)
    ("[:" . ?⦙)
    ("[" . ?⊣)
    ("]" . ?⊢)
    ("{:" . ?⍏)
    ("{." . ?↑)
    ("{" . ?⌷)
    ("}:" . ?⍖)
    ("}." . ?↓)
    ("}" . ?→)
    ("\":" . ?⍕)
    ("\"." . ?⍎)
    ("\"" . ?⍤)
    ("`:" . ?⊠)
    ("`" . "∘̑")
    ("@:" . ?⍛)
    ("@." . ?▫)
    ("@" . ?∘)
    ("&.:" . "⍢̲")
    ;;("&.>" . ?¨)
    ("&." . ?⍢)
    ("&:" . "∙̲")
    ("&" . ?∙)
    ("?." . ?¿)
    ("a." . "ä")
    ("a:" . "a̲")
    ("A." . "Ä")
    ("e:" . "∊̲")
    ("e." . ?∊)
    ("i:" . ?⍸)
    ("i." . ?⍳)
    ("I." . ?Ι)
    ("o." . ?○)
    ("p:" . "p̲")
    ("x:" . "x̲")
    ("q:" . "q̲")
    ("0:" . "0̲")
    ("1:" . "1̲")
    ("2:" . "2̲")
    ("3:" . "3̲")
    ("4:" . "4̲")
    ("5:" . "5̲")
    ("6:" . "6̲")
    ("7:" . "7̲")
    ("8:" . "8̲")
    ("9:" . "9̲")
    ("_:" . "∞̲")))

(defun j-prettify-symbols--compose-symbol (alist)
  (let* ((start (match-beginning 0))
         (end (match-end 0))
         (match (match-string 0))
         (cbs (or (char-before start) ?\s))
         (cas (or (char-after start) ?\s)))
    (if (or (and (= ?w (char-syntax cas)) (= ?w (char-syntax cbs))
                 (not (eq 'Nd (get-char-code-property cbs 'general-category))))
            (eq 'font-lock-string-face (get-char-property start 'face)))
        (remove-text-properties start end '(composition))
      (if (not (get-char-property start 'composition))
          (compose-region start end (cdr (assoc match alist))))))
  nil)

(defun j-compose-replace (n x)
  (let ((start (match-beginning n))
        (end (match-end n)))
    (compose-region start end x)
    nil))

(makunbound 'j-font-lock-keywords)
(defvar j-font-lock-keywords
  `(("\\(?:^\\|[^:][([:space:]]*\\)\\('\\(?:[^']\\|''\\)*'\\)"
     (1 font-lock-string-face))

    ("\\([_a-zA-Z0-9]+\\)\s*\\(=[.:]\\)"
     (1 font-lock-variable-name-face)
     (2 j-other-face))

    (,(regexp-opt j-font-lock-foreign-conjunctions) . font-lock-warning-face)
    (,(concat (regexp-opt j-font-lock-control-structures)
              "\\|\\(?:\\(?:for\\|goto\\|label\\)_[a-zA-Z]+\\.\\)")
     . font-lock-keyword-face)
    (,(regexp-opt j-font-lock-constants) . font-lock-constant-face)
    (,(regexp-opt j-font-lock-len-3-verbs) . j-verb-face)
    (,(regexp-opt j-font-lock-len-3-conjunctions) . j-conjunction-face)
    ;;(,(regexp-opt j-font-lock-len-3-others) . )
    (,(regexp-opt j-font-lock-len-2-verbs) . j-verb-face)
    (,(regexp-opt j-font-lock-len-2-adverbs) . j-adverb-face)
    (,(regexp-opt j-font-lock-len-2-conjunctions) . j-conjunction-face)
    ;;(,(regexp-opt j-font-lock-len-2-others) . )
    (,(regexp-opt j-font-lock-len-1-verbs) . j-verb-face)
    (,(regexp-opt j-font-lock-len-1-adverbs) . j-adverb-face)
    (,(regexp-opt j-font-lock-len-1-conjunctions) . j-conjunction-face)
    ;;(,(regexp-opt j-font-lock-len-1-other) . )

    ("[[:digit:]]+\\s-+:\\s-*'.*\\('\\)" (1 (j-compose-replace 1 ?})))
    ("[[:digit:]]+\\s-+:\\s-*\\(?:0\\|'\\)" (0 (j-compose-replace 0 ?{)))
    ("^\\()\\)\\s-*$" (1 (j-compose-replace 1 ?})))
    ("\\(&\\.>\\)\\(?:[^:]\\|$\\)" (1 (j-compose-replace 1 ?¨)))
    ("\\(&\\.:>\\)\\(?:[^:]\\|$\\)" (1 (j-compose-replace 1 "¨̲")))
    (,(regexp-opt (mapcar 'car j-prettify-symbols-alist) t)
     (0 (j-prettify-symbols--compose-symbol ',j-prettify-symbols-alist)))
    ("\\(_\\)[[:digit:]]" (1 (j-compose-replace 1 ?¯)))
    ("\\<\\(x\\)\\>\\(?:$\\|[^:]\\)" (1 (j-compose-replace 1 ?⍺)))
    ("\\<\\(y\\)\\>\\(?:$\\|[^:]\\)" (1 (j-compose-replace 1 ?⍵)))
    ("\\<\\([um]\\)\\>\\(?:$\\|[^:]\\)"
     (1 (j-compose-replace 1 '(?⍺ (Br . Bl) ?⍺))))
    ("\\<\\([vn]\\)\\>\\(?:$\\|[^:]\\)"
     (1 (j-compose-replace 1 '(?⍵ (Br . Bl) ?⍵))))
    )
  "J Mode font lock keys words")

(defun j-font-lock-syntactic-face-function (state)
  "Function for detection of string vs. Comment Note: J comments
are three chars longs, there is no easy / evident way to handle
this in emacs and it poses problems"
  (if (nth 3 state) font-lock-string-face
    (let* ((start-pos (nth 8 state)))
      (and (<= (+ start-pos 3) (point-max))
           (eq (char-after start-pos) ?N)
           (string= (buffer-substring-no-properties
                     start-pos (+ start-pos 3)) "NB.")
           font-lock-comment-face))))

(provide 'j-font-lock)
