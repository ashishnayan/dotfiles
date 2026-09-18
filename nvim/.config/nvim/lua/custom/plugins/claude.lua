-- ============================================================================
-- Claude Code keymaps (all under <leader>a)  — defined here and in sidekick.lua
-- ============================================================================
--   Terminal / sessions (sidekick.lua)
--     <leader>ac        Toggle Claude Code terminal
--     <leader>ar        Start Claude with --resume  (pick a past session)
--     <leader>aC        Start Claude with --continue (last session)
--     <leader>af        Focus AI terminal (also <C-.> in n/i/t/x modes)
--     <leader>at        Select AI tool / attach to external session (claude, opencode, codex...)
--
--   Prompts / context sending (sidekick.lua)
--     <leader>ap        Prompt picker with context (explain, fix, tests, optimize...)  [n, x]
--     <leader>av        Send visual selection as text                                 [x]
--     <leader>ax        Send current buffer diagnostics
--     <leader>ag        Ask Claude to review git changes
--
--   IDE protocol: @-mentions + diffs (this file)
--     <leader>as        Share visual selection as @file#L1-10 (no text pasted)        [v]
--     <leader>as        In a file explorer (oil, neo-tree...): add file to context
--     <leader>ab        Add current buffer to Claude context
--     <leader>aa        Accept Claude's diff
--     <leader>ad        Deny Claude's diff
--     <leader>aS        Show IDE server status
--
--   Inside the Claude terminal: <C-.> or <leader>af jumps back to the editor,
--   `q` (normal mode) hides the terminal window.
-- ============================================================================

-- coder/claudecode.nvim: implements the same WebSocket/MCP IDE protocol as the
-- official VS Code extension. Runs with the "none" terminal provider so it never
-- opens windows itself; sidekick.nvim (sidekick.lua) manages the terminal and
-- launches `claude` with CLAUDE_CODE_SSE_PORT so it connects to this server.
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      auto_start = true,
      track_selection = true,
      terminal = { provider = "none" },
      diff_opts = {
        layout = "vertical",
        open_in_new_tab = true,
        keep_terminal_focus = false,
      },
    },
    cmd = { "ClaudeCode", "ClaudeCodeAdd", "ClaudeCodeSend", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny", "ClaudeCodeStatus" },
    keys = {
      -- Selection sharing over the IDE socket (shows as @file#L1-10 in Claude, no text pasted)
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Share selection with Claude (@-mention)" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to Claude context" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file to Claude context",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff review (Claude's edits open as native diffs)
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny Claude diff" },
      { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>",     desc = "Claude IDE server status" },
    },
  },
}
