# Neovim Configuration - Claude Context

This is a personal Neovim configuration that is in the process of being migrated from Lua to Fennel.

## Project Overview

This is a customized Neovim IDE configuration that prioritizes:
- Modern plugin ecosystem (lazy.nvim for plugin management)
- LSP integration for intelligent code editing
- Fennel as the primary configuration language (migration in progress)
- Support for multiple programming languages (Clojure, TypeScript, JavaScript, etc.)

## Architecture

### File Structure

```
.
├── init.lua                    # Entry point, requires all user modules
├── fnl/                        # Fennel source files (preferred)
│   └── user/
│       ├── autocommands.fnl    # Auto commands in Fennel
│       ├── keymaps.fnl         # Key mappings in Fennel
│       ├── projectionist.fnl   # Projectionist config
│       ├── treesitter.fnl      # Treesitter config
│       └── lsp/                # LSP configurations
│           ├── flsproject.fnl  # FLS LSP configuration
│           └── handlers.fnl    # LSP handlers
└── lua/                        # Lua files (being migrated to Fennel)
    └── user/
        ├── autocommands.lua    # Compiled from Fennel
        ├── keymaps.lua         # Compiled from Fennel
        ├── plugins.lua         # Plugin declarations
        ├── options.lua         # Vim options
        ├── colorscheme.lua     # Colorscheme setup
        ├── blink.lua           # Blink completion config
        ├── cmp.lua             # nvim-cmp config
        ├── conjure.lua         # Clojure REPL integration
        ├── dadbod.lua          # Database integration
        ├── debugprint.lua      # Debug printing utilities
        ├── formatter.lua       # Code formatting
        ├── gitsigns.lua        # Git integration
        ├── lilypond.lua        # LilyPond music notation
        ├── lualine.lua         # Status line
        ├── oil.lua             # File explorer
        ├── telescope.lua       # Fuzzy finder
        ├── treesitter.lua      # Syntax highlighting
        └── lsp/                # LSP configurations
            ├── handlers.lua    # Compiled from Fennel
            ├── flsproject.lua  # Compiled from Fennel
            └── mason-lspconfig.lua
```

### Compilation Process

The configuration uses [nfnl](https://github.com/Olical/nfnl) to compile Fennel files to Lua:
- Fennel source files live in `fnl/`
- Compiled Lua files are output to `lua/`
- `.nfnl.fnl` at the root configures the compilation
- The compilation happens automatically when Fennel files are saved

## Migration Status

### Already Migrated to Fennel
- `fnl/user/autocommands.fnl` → `lua/user/autocommands.lua`
- `fnl/user/keymaps.fnl` → `lua/user/keymaps.lua`
- `fnl/user/projectionist.fnl` → `lua/user/projectionist.lua`
- `fnl/user/treesitter.fnl` → `lua/user/treesitter.lua`
- `fnl/user/lsp/handlers.fnl` → `lua/user/lsp/handlers.lua`
- `fnl/user/lsp/flsproject.fnl` → `lua/user/lsp/flsproject.lua`

### Still in Lua (To Be Migrated)
- `lua/user/plugins.lua` - Plugin declarations
- `lua/user/options.lua` - Vim options
- `lua/user/colorscheme.lua` - Colorscheme setup
- `lua/user/blink.lua` - Blink completion
- `lua/user/cmp.lua` - nvim-cmp completion
- `lua/user/conjure.lua` - Clojure REPL
- `lua/user/dadbod.lua` - Database tools
- `lua/user/debugprint.lua` - Debug printing
- `lua/user/formatter.lua` - Code formatting
- `lua/user/gitsigns.lua` - Git signs
- `lua/user/lilypond.lua` - LilyPond support
- `lua/user/lualine.lua` - Status line
- `lua/user/oil.lua` - File explorer
- `lua/user/telescope.lua` - Fuzzy finder
- `lua/user/comment.lua` - Comment utilities
- `lua/user/expandregion.lua` - Text object expansion
- `lua/user/luasnip/` - Snippet configs
- `lua/user/lsp/mason-lspconfig.lua` - LSP installer config
- `init.lua` - Main entry point

## Key Technologies

### Core
- **Neovim**: Modern vim-based editor
- **Fennel**: Lisp that compiles to Lua
- **nfnl**: Fennel compiler for Neovim
- **lazy.nvim**: Modern plugin manager

### Major Plugins
- **Telescope**: Fuzzy finder
- **Treesitter**: Advanced syntax highlighting
- **LSP**: Language Server Protocol integration
- **Mason**: LSP/DAP/Linter installer
- **Blink/nvim-cmp**: Completion engines
- **Conjure**: Clojure/Lisp REPL integration
- **Gitsigns**: Git integration
- **Oil.nvim**: File explorer
- **LuaSnip**: Snippet engine
- **Lualine**: Status line
- **vim-sexp**: S-expression editing for Lisps

### Language Support
- Clojure (via Conjure and clojure-lsp)
- TypeScript/JavaScript
- Lua
- Fennel
- LilyPond (music notation)
- SQL (via vim-dadbod)

## Development Guidelines

### When Migrating Files to Fennel

1. Create the Fennel file in the appropriate `fnl/` directory
2. Port the Lua code to Fennel syntax
3. Save the file - nfnl will automatically compile to `lua/`
4. Test the compiled output
5. Keep both files tracked in git (Fennel source + compiled Lua)

### When Adding New Features

1. **Prefer Fennel**: Write new configuration files in Fennel, not Lua
2. **File Location**: Place Fennel source in `fnl/user/`, compiled output goes to `lua/user/`
3. **Require Statements**: Update `init.lua` to require the new module if needed
4. **Testing**: Test thoroughly as Fennel compilation errors may not be obvious

### When Modifying Existing Features

1. **Check for Fennel Source**: Always check if a `fnl/` version exists before editing Lua
2. **Edit Fennel, Not Lua**: If Fennel source exists, edit that file (Lua is generated)
3. **Lua-Only Files**: If only Lua exists, you can either:
   - Edit the Lua directly (quick fixes)
   - Migrate to Fennel first, then make changes (preferred for substantial changes)

## Special Configurations

### Custom Key Mappings
- Leader key is likely `,` or space (check `keymaps.fnl`)
- File-type specific marks: `<leader>gj` for JS/TS, `<leader>gc` for Clojure, etc.
- Terminal mode escape: `<leader><Esc>` to exit terminal mode

### VimScript Sections
The `init.lua` contains VimScript blocks for:
- Visual selection search/replace functions
- Jump list management for `{` and `}` motions
- File-type specific automatic mark setting
- Copilot configuration
- Mergetool layout

These may need to be migrated to Fennel or kept as-is.

### LSP Configuration
- FLS Project LSP is configured (`fnl/user/lsp/flsproject.fnl`)
- Custom handlers in `fnl/user/lsp/handlers.fnl`
- Mason manages LSP installations

## Common Tasks

### Installing New Plugins
1. Edit `lua/user/plugins.lua` (not yet migrated to Fennel)
2. Add plugin spec using lazy.nvim syntax
3. Restart Neovim or run `:Lazy sync`

### Adding New LSP Server
1. Install via Mason: `:Mason` or `:MasonInstall <server>`
2. Configure in `lua/user/lsp/mason-lspconfig.lua` or create new config file
3. Consider migrating configuration to Fennel

### Adding Keymaps
1. Edit `fnl/user/keymaps.fnl` (already migrated)
2. Use Fennel syntax: `(vim.keymap.set "n" "<leader>x" "<cmd>Something<cr>" {:desc "Description"})`
3. Save and the Lua will auto-compile

### Adding Autocommands
1. Edit `fnl/user/autocommands.fnl` (already migrated)
2. Use Fennel syntax for autocmds
3. Save and the Lua will auto-compile

## Working with Claude

### Prefer Existing Patterns
When making changes, follow the existing patterns in the codebase:
- Use the same Fennel idioms found in migrated files
- Follow the module structure (one feature per file)
- Keep configurations modular and focused

### File References
When referencing code, use the pattern: `file_path:line_number`
Example: "The LSP handlers are defined in `fnl/user/lsp/handlers.fnl:15`"

### Migration Strategy
When asked to migrate a file:
1. Read the Lua source file
2. Create equivalent Fennel file in `fnl/` directory
3. Test compilation
4. Verify functionality
5. Update this document if needed

## Notes

- This config is based on the nvim-basic-ide template but heavily customized
- Current branch is `cmp` (possibly working on completion config)
- Uses nfnl for Fennel compilation (not Aniseed or Hotpot)
- Some plugins may be pinned to specific versions (check `lazy-lock.json`)
