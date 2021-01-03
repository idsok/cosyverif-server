package = "CosyVerif-Server"
version = "master-1"

source = {
   url = "git://github.com/cosyverif/server",
}

description = {
  summary     = "CosyVerif Server",
  detailed    = [[
  ]],
  homepage    = "http://www.cosyverif.org/",
  license     = "MIT/X11",
  maintainer  = "Alban Linard <alban.linard@lsv.ens-cachan.fr>",
}

dependencies = {
  "lua >= 5.1",
}

build = {
  type    = "builtin",
  modules = {
  },
}
