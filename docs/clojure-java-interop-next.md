# Clojure Java interop: next DX steps

Follow-ups to [clojure-java-interop.md](clojure-java-interop.md), ranked by
payoff over effort. Context: Conjure + cider-nrepl 0.58 (orchard + inlined
compliment), blink.cmp with `blink.compat` for the Conjure source, clojure-lsp
for static features, Clojure 1.12, JDK with `lib/src.zip`. `gd` and `.method`
completion already infer the receiver class from constructor calls, static
calls and chained calls (see the REPL-side patches in the project's
`dev/user.clj`).

## 1. `K` on Java members

**Gap.** `K` is `vim.lsp.buf.hover`, and clojure-lsp has no hover for Java
members. Conjure's `doc-word` sends the `info` op without `context`, so a bare
`.decode` is ambiguous or empty, exactly the problem `gd` had.

**Plan.** Same shape as `conjure-def-word` in `lua/user/lsp/handlers.lua`:
send `info` with `completion-context`, then show `class`, `arglists-str` and
`javadoc` from the reply (Conjure's `java-info->lines` in
`conjure/client/clojure/nrepl/action.fnl` is the format to copy). Map `K` for
Clojure buffers when a REPL is connected, LSP hover otherwise.

**Effort.** Small. This is the closest thing to IntelliJ's parameter popup.

## 2. Infer the class of `let`-bound locals

**Gap.** `(let [d (Base64/getDecoder)] (.dec|` still lists members of every
imported class. compliment's `try-get-object-class` only reads a `:tag` off
local bindings (`bindings-from-context`); it does not look at the init form.

**Plan.** Extend the `dev/user.clj` patch: when the receiver is a symbol with
no tag, find its binding in the context (compliment already parses `let`
style bindings) and run the init form through `invocation-form->class+`.
Serves completion and `gd`, since cider-nrepl's `info` uses the same function.

**Effort.** Moderate. Most real receivers are locals, so this is the biggest
remaining coverage win.

## 3. Overload-aware return types

**Gap.** `method-return-type` in `dev/user.clj` takes the first method with a
matching name. Chains through overloads that differ in return type can resolve
to the wrong class.

**Plan.** Prefer the overload whose parameter count matches the argument count
in the call form; fall back to the first match.

**Effort.** Small. Only matters once chains are common.

## 4. Upstream the two workarounds

**Gap.** Two patches in `dev/user.clj` paper over upstream bugs:

- Conjure splices `__prefix__` after the typed text (`.de__prefix__`) in
  `extract-completion-context`; compliment expects it in place of the symbol.
  One-line Fennel fix: subtract the prefix length before splicing.
- compliment's `invocation-form->class` only resolves vars with a `:tag`;
  constructor and static-call forms could be inferred by reflection.

**Plan.** File both, with the REPL repro from the main doc. Remove the
patches once the fixes land.

**Effort.** Small to file. No DX gain today, but stops the workarounds rotting.

## 5. Inspect Java objects, not only signatures

**Gap.** `user/list-methods` prints names only. Nothing shows a live object's
fields and nested values.

**Plan.** Clojure 1.12 `clojure.datafy` on a class or object gives members
with flags and types, which can replace `list-methods` with no new dependency.
For live object trees, Portal (`tap>` to a browser or nvim pane) is the real
step up and the only new dependency on this list.

**Effort.** Small for datafy, moderate for Portal.

## 6. Source jars for third-party Java

**Gap.** `gd` into the JDK works because of `src.zip`. Libraries such as
Jackson or HikariCP need a sources jar.

**Plan.** Both info requests already send `download-sources-jar 1`, so
cider-nrepl should fetch sources on demand. Verify once with `gd` on a
non-JDK class (e.g. `HikariDataSource/.getConnection`) before trusting it.

**Effort.** Check only; code changes only if the download does not happen.

## Suggested order

1 then 2. 3 and 6 as they come up. 4 whenever there is a quiet moment.
