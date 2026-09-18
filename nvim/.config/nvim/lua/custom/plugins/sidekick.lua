-- sidekick.nvim owns the AI CLI terminal (Claude Code, opencode, codex, ...),
-- prompt templates with editor context, and tool switching.
-- coder/claudecode.nvim (see claude.lua) runs headless ("none" provider) and only
-- provides the IDE protocol: native diff accept/deny + @-mention selection sharing.
-- The helper below wires the two together by passing claudecode's WebSocket port
-- into the Claude CLI's environment so it auto-connects to this Neovim instance.

---Open/toggle a Claude Code session attached to this Neovim's IDE server.
---@param opts? { args?: string[], focus?: boolean, action?: "toggle"|"show" }
local function claude(opts)
  opts = opts or {}
  local env = {}
  local ok, cc = pcall(require, "claudecode")
  if ok then
    if not (cc.state and cc.state.port) and cc.start then
      pcall(cc.start)
    end
    if cc.state and cc.state.port then
      env.ENABLE_IDE_INTEGRATION = "true"
      env.CLAUDE_CODE_SSE_PORT = tostring(cc.state.port)
    end
  end
  local tools = require("sidekick.config").cli.tools
  tools.claude = tools.claude or {}
  tools.claude.env = env
  tools.claude.cmd = vim.list_extend({ "claude" }, opts.args or {})
  -- Only consider sessions owned by this Neovim; claude processes running elsewhere
  -- (other tmux windows/projects) are ignored here. Use <leader>at to attach to those.
  local State = require("sidekick.cli.state")
  local own = State.get({ name = "claude", external = false })
  if #own == 0 then
    State.attach({ tool = require("sidekick.config").get_tool("claude"), installed = true }, {
      show = true,
      focus = opts.focus ~= false,
    })
  else
    require("sidekick.cli")[opts.action or "toggle"]({
      name = "claude",
      focus = opts.focus ~= false,
      filter = { external = false },
    })
  end
end

return {
  {
    "folke/sidekick.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Next Edit Suggestions need the Copilot LSP + subscription; off for now.
      nes = { enabled = false },
      cli = {
        win = { layout = "right", split = { width = 80 } },
        -- Set `mux.enabled = true` to keep sessions alive in tmux across nvim restarts.
        mux = { backend = "tmux", enabled = false },
      },
    },
    config = function(_, opts)
      require("sidekick").setup(opts)
      -- After claudecode.nvim pushes an @-mention over the IDE socket, jump to the terminal.
      vim.api.nvim_create_autocmd("User", {
        pattern = "ClaudeCodeSendComplete",
        callback = function()
          require("sidekick.cli").focus({ name = "claude" })
        end,
      })
    end,
    keys = {
      { "<leader>a",  nil, desc = "AI/Claude Code" },
      { "<leader>ac", function() claude() end, desc = "Toggle Claude Code" },
      { "<leader>ar", function() claude({ args = { "--resume" }, action = "show" }) end, desc = "Claude: resume session" },
      { "<leader>aC", function() claude({ args = { "--continue" }, action = "show" }) end, desc = "Claude: continue last" },
      { "<leader>af", function() require("sidekick.cli").focus() end, mode = { "n", "t", "i", "x" }, desc = "Focus AI terminal" },
      { "<c-.>",      function() require("sidekick.cli").focus() end, mode = { "n", "t", "i", "x" }, desc = "Focus AI terminal" },
      { "<leader>at", function() require("sidekick.cli").select() end, desc = "Select AI tool (claude/opencode/codex...)" },
      { "<leader>ap", function() require("sidekick.cli").prompt() end, mode = { "n", "x" }, desc = "Send prompt with context" },
      { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, mode = "x", desc = "Send selection text" },
      { "<leader>ax", function() require("sidekick.cli").send({ msg = "{diagnostics}" }) end, desc = "Send buffer diagnostics" },
      { "<leader>ag", function() require("sidekick.cli").send({ prompt = "changes" }) end, desc = "Review my git changes" },
    },
  },
}
