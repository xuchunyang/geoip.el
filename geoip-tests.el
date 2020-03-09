;;; geoip-tests.el --- Tests                         -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Xu Chunyang

;; Author: Xu Chunyang <xuchunyang56@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; geoip.el tests

;;; Code:

(require 'geoip)
(require 'ert)

(ert-deftest geoip-1 ()
  (with-current-buffer (geoip-new-buffer "GeoIP2-Anonymous-IP-Test.mmdb")
    ;; https://github.com/maxmind/MaxMind-DB/blob/master/source-data/GeoIP2-Anonymous-IP-Test.json#L9
    (should (equal (geoip-lookup (current-buffer) "1.124.213.1")
                   '(("is_anonymous" . t)
                     ("is_anonymous_vpn" . t)
                     ("is_tor_exit_node" . t))))
    (should (equal (geoip-lookup (current-buffer) "71.160.223.0")
                   '(("is_anonymous" . t)
                     ("is_hosting_provider" . t))))
    (kill-buffer (current-buffer))))

(ert-deftest geoip-2 ()
  (with-current-buffer (geoip-new-buffer "GeoIP2-Country-Test.mmdb")
    (should (equal
             (assoc-default "iso_code" (assoc-default "country" (geoip-lookup (current-buffer) "50.114.0.0")))
             "US"))
    (kill-buffer (current-buffer))))

(provide 'geoip-tests)
;;; geoip-tests.el ends here
