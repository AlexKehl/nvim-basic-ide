# Clojure: Java interop completion and go-to-definition

How `.method` completion and `gd` on Java members work for Clojure buffers, and
the four places that had to be patched to make them behave like IntelliJ.
Everything goes through Conjure's nREPL connection and cider-nrepl (orchard for
`info`, compliment for `complete`). Nothing here depends on clojure-lsp.

## The problem

Out of the box:

- Typing `.` after `(Base64/getDecoder)` listed methods of every imported class.
- `gd` on `StringBuilder/.append` went through clojure-lsp, which only knows the
  class and lands on line 1 of `StringBuilder.java`.
- `gd` on a bare `.append` printed "Multiple candidates found" and stopped.
- Opening a JDK `.java` buffer auto-started `java-language-server` without a
  project root, which crashed and tripped a Neovim LSP client error.

Server side, both operations only infer the receiver class of `(.method <form>)`
when the form is a type-hinted symbol, a var with a `:tag`, or a literal.
Constructor calls `(Foo.)`, static calls `(Foo/bar)` and chains are not handled.

## What was changed

### 1. `gd` goes through Conjure when a REPL is connected

`fnl/user/lsp/handlers.fnl`, `lsp-keymaps`: `gd` is set in the LSP `on_attach`
(it would override a FileType mapping). For `clojure` buffers with a live nREPL
it calls `conjure-def-word`; otherwise it is the Telescope LSP jump as before.

### 2. `conjure-def-word` sends context and handles candidates

Same file. Instead of Conjure's `def-word` it sends the cider `info` op itself:

- `context`: the root form with `__prefix__` spliced over the word under the
  cursor (`completion-context`). cider-nrepl's `info` op uses it to infer the
  receiver class via compliment.
- Reply has `class` and `member`: jump with `<class>/<word>` so Conjure's
  `def-str` resolves it unambiguously (Conjure's own request sends no context).
- Reply has `candidates`: `vim.ui.select` over the classes, then jump.
- Otherwise fall back to Conjure's default behaviour.

Note: cider-nrepl puts the info keys at the top level of the reply, not under
`info`.

### 3. Conjure sends completion context

`lua/user/conjure.lua`:

```lua
vim.g["conjure#client#clojure#nrepl#completion#with_context"] = true
```

Off by default; without it compliment only sees the bare prefix.

### 4. `java-language-server` only starts inside a Java project

`fnl/user/lsp/handlers.fnl`, bottom: `vim.lsp.config :java_language_server` with
a `root_dir` that only calls back when a Gradle or Maven marker is found.
mason-lspconfig auto-enables every installed server, so JDK source buffers
(`zipfile://…src.zip` or `~/.cache/clojure-lsp/jdk/…`) used to start it rootless.

## REPL-side patches (not in this repo)

Two compliment limitations are worked around in the project's `dev/user.clj`
(e.g. `stayinn-backend/dev/user.clj`), applied with `alter-var-root` at REPL
start. They look up the inlined compliment namespaces by name pattern, so a
cider-nrepl version bump does not break them.

1. **Receiver class inference** — wraps `compliment.utils/invocation-form->class`
   to also resolve `(Foo. …)`, `(Foo/static …)` and nested `(.method <form> …)`
   chains by reflection on the return type. This serves both completion and
   `gd`, because cider-nrepl's `info` op uses the same function.
2. **Conjure context format** — Conjure splices `__prefix__` *after* the typed
   text (`.de__prefix__`), compliment expects it *instead of* the symbol
   (`__prefix__`). Wraps `compliment.core/completions` to strip the prefix.
   Only completion needs this; `gd` builds its context correctly in nvim.

Both are upstream bugs: Conjure's `extract-completion-context` should subtract
the prefix length, and compliment could infer from constructor/static forms.

## Checking it works

With the backend REPL connected, in a Clojure buffer:

- `.` after `(Base64/getDecoder)` → `.decode`, `.wrap`, Object methods only.
- `gd` on `.append` in `(.append (StringBuilder.))` → `StringBuilder.java`,
  the `append` line, no picker.
- `gd` on `.append` with an untyped local receiver → picker with
  StringBuffer / StringBuilder / Appendable.

Orchard needs `lib/src.zip` in the JDK to open real source; brew openjdk and
Temurin ship it.

Server-side check without the editor, in the REPL:

```clojure
(require 'cider.nrepl.middleware.info)
(-> (cider.nrepl.middleware.info/info
     {:ns "user" :sym ".decode" :context "(__prefix__ (Base64/getDecoder))"})
    (select-keys [:class :member :line]))
;; => {:class java.util.Base64$Decoder, :member decode, :line 568}
```
