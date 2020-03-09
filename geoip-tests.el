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

(ert-deftest geoip-ipv6-to-bytes ()
  (equal (geoip-ipv6-to-bytes "::")
         (make-string 16 0))
  (equal (geoip-ipv6-to-bytes "::1")
         (concat (make-string 15 0) (unibyte-string 1)))
  (equal (geoip-ipv6-to-bytes "2001:db8:85a3::8a2e:370:7334")
         (unibyte-string
          #x20 #x01 #x0d #xb8
          #x85 #xa3 #x00 #x00
          #x00 #x00 #x8a #x2e
          #x03 #x70 #x73 #x34)))

(ert-deftest geoip-parse-ip ()
  (should (equal (geoip-parse-ip "127.0.0.1" 4) (unibyte-string 127 0 0 1)))
  (should (equal (substring (geoip-parse-ip "127.0.0.1" 6) 12) (unibyte-string 127 0 0 1)))
  (should (equal (geoip-parse-ip "::" 6) (make-string 16 0)))
  (should-error (geoip-parse-ip "::" 4) :type 'user-error))

(ert-deftest geoip-Anonymous-IP-Test ()
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

(ert-deftest geoip-Country-Test ()
  (with-current-buffer (geoip-new-buffer "GeoIP2-Country-Test.mmdb")
    (should (geoip-lookup (current-buffer) "50.114.0.0"))
    (should (geoip-lookup (current-buffer) "2001:218::"))
    (kill-buffer (current-buffer))))

(provide 'geoip-tests)
;;; geoip-tests.el ends here
