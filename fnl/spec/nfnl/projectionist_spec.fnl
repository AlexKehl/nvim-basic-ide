(local {: describe : it} (require :plenary.busted))
(local assert (require :luassert.assert))
(local sut (require :user.projectionist))

(describe :get-clojure-path
          (fn []
            (it "gets the first value"
                (fn []
                  (assert.equals 1 (core.first [1 2 3 4 5]))))))
