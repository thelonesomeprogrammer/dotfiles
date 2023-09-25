local snip = require('snips.mksnip').mksnip
local luasnip = require 'luasnip'


local snips = {
  {"require",[[local {} = require('{}')]],{"var","file"}},
  {"local",[[local {} = {}]],{"var","val"}},
}
return snip(snips)

