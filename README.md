# geoip.el
[![Melpa](https://melpa.org/packages/geoip-badge.svg)](https://melpa.org/#/geoip)

## Introduction

An Emacs Lisp library for reading the MaxMind DB file
<https://maxmind.github.io/MaxMind-DB/>.  It lets you look up information about
where an IP address is located.

## Usage

To use this package, you need to
[download](https://dev.maxmind.com/geoip/geoip2/geolite2/) one of MaxMind’s V2
databases. This packge has been tested against their free "GeoLite2" databases,
but should work with their other DBs as well.

Once you have downloaded one of the databases, you can read the database with
`geoip-new-buffer`. That will return an Emacs buffer that you can use to perform
lookups using `geoip-lookup`. For example,

``` emacs-lisp
(setq my-geoip-buffer
      (geoip-new-buffer
       "/Users/xcy/Downloads/GeoLite2-Country_20200225/GeoLite2-Country.mmdb"))
;; => #<buffer  *geoip: /Users/xcy/Downloads/GeoLite2-Country_20200225/GeoLite2-Country.mmdb*>

(geoip-lookup my-geoip-buffer "114.114.114.114")
;; =>
((continent
  (code . "AS")
  (geoname_id . 6255147)
  (names
   (de . "Asien")
   (en . "Asia")
   (es . "Asia")
   (fr . "Asie")
   (ja . "アジア")
   (pt-BR . "Ásia")
   (ru . "Азия")
   (zh-CN . "亚洲")))
 (country
  (geoname_id . 1814991)
  (iso_code . "CN")
  (names
   (de . "China")
   (en . "China")
   (es . "China")
   (fr . "Chine")
   (ja . "中国")
   (pt-BR . "China")
   (ru . "Китай")
   (zh-CN . "中国")))
 (registered_country
  (geoname_id . 1814991)
  (iso_code . "CN")
  (names
   (de . "China")
   (en . "China")
   (es . "China")
   (fr . "Chine")
   (ja . "中国")
   (pt-BR . "China")
   (ru . "Китай")
   (zh-CN . "中国"))))
```

## API

### `(geoip-new-buffer PATH)`

Create and return a geoip buffer. `PATH` is a MaxMind DB file.

### `(geoip-lookup GEOIP-BUFFER IP)`

Lookup IP with GEOIP-BUFFER.
