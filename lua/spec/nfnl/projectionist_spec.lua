-- [nfnl] fnl/spec/nfnl/projectionist_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_["describe"]
local it = _local_1_["it"]
local assert = require("luassert.assert")
local sut = require("user.projectionist")
local function _2_()
  local function _3_()
    return assert.equals(1, core.first({1, 2, 3, 4, 5}))
  end
  return it("gets the first value", _3_)
end
return describe("get-clojure-path", _2_)
