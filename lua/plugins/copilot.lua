-- ========================================
-- Copilot & CopilotChat設定
-- ========================================

return {
  -- Copilot.lua: LuaネイティブなCopilot inline suggestion
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = "<M-w>",
            accept_line = "<M-e>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-e>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        filetypes = {
          yaml = true,
          markdown = true,
          help = false,
          gitcommit = true,
          gitrebase = false,
          ["."] = false,
        },
      })
    end,
  },

  -- Copilot-cmp統合
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- CopilotChat: AIチャット統合
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatCommit",
      "CopilotChatCommitStaged",
    },
    keys = {
      -- ビジュアルモードでの操作
      { "<leader>ae", "<cmd>CopilotChatExplain<CR>", mode = "x", desc = "コードの説明" },
      { "<leader>ar", "<cmd>CopilotChatReview<CR>", mode = "x", desc = "コードレビュー" },
      { "<leader>af", "<cmd>CopilotChatFix<CR>", mode = "x", desc = "バグ修正" },
      { "<leader>ao", "<cmd>CopilotChatOptimize<CR>", mode = "x", desc = "最適化" },
      { "<leader>ad", "<cmd>CopilotChatDocs<CR>", mode = "x", desc = "ドキュメント追加" },
      { "<leader>at", "<cmd>CopilotChatTests<CR>", mode = "x", desc = "テストケース作成" },
      
      -- ノーマルモードでの操作
      { "<leader>aa", "<cmd>CopilotChatToggle<CR>", mode = "n", desc = "チャット切替" },
      { "<leader>aC", "<cmd>CopilotChatCommit<CR>", mode = "n", desc = "コミットメッセージ作成" },
      { "<leader>aS", "<cmd>CopilotChatCommitStaged<CR>", mode = "n", desc = "ステージ済みコミットメッセージ" },
    },
    config = function()
      require("CopilotChat").setup({
        show_help = "yes",
        
        -- 日本語で応答するシステムプロンプト
        system_prompt = [[あなたは優秀なプログラミングアシスタントです。
すべての応答を日本語で行ってください。
コードの説明、レビュー、提案など、すべてのコミュニケーションを日本語で行います。]],
        
        -- モデル設定
        model = "gpt-4o",
        temperature = 0.1,
        
        mappings = {
          complete = {
            insert = "<Tab>",
          },
          reset = {
            normal = "<C-l>",
            insert = "<C-l>",
          },
        },
        
        -- カスタムプロンプト
        prompts = {
          Explain = {
            prompt = "/COPILOT EXPLAIN 選択されたコードについて、日本語で段落形式の説明を書いてください。",
            system_prompt = "あなたは親切なプログラミング講師です。すべての応答を日本語で行ってください。",
            mapping = "<leader>ae",
            description = "コードの説明をお願いする",
          },
          Review = {
            prompt = "/COPILOT REVIEW このコードを包括的にレビューし、改善点を日本語で報告してください。",
            system_prompt = "あなたは経験豊富なコードレビュアーです。すべての応答を日本語で行ってください。",
            mapping = "<leader>ar",
            description = "コードレビューをお願いする",
          },
          Fix = {
            prompt = "/COPILOT FIX このコードの問題を特定し、修正したコードと説明を日本語で提供してください。",
            system_prompt = "あなたは熟練したデバッガーです。すべての応答を日本語で行ってください。",
            mapping = "<leader>af",
            description = "コードのバグ修正をお願いする",
          },
          Optimize = {
            prompt = "/COPILOT OPTIMIZE このコードのパフォーマンスと可読性を改善し、最適化戦略を日本語で説明してください。",
            system_prompt = "あなたはパフォーマンス最適化の専門家です。すべての応答を日本語で行ってください。",
            mapping = "<leader>ao",
            description = "コードの最適化をお願いする",
          },
          Docs = {
            prompt = "/COPILOT DOCS 選択されたコードに適切なドキュメントコメントを日本語で追加してください。",
            system_prompt = "あなたは技術文書作成の専門家です。すべての応答を日本語で行ってください。",
            mapping = "<leader>ad",
            description = "コードのドキュメント追加をお願いする",
          },
          Tests = {
            prompt = "/COPILOT TESTS 選択されたコードのテストケースを生成し、日本語で説明してください。",
            system_prompt = "あなたはテスト駆動開発の専門家です。すべての応答を日本語で行ってください。",
            mapping = "<leader>at",
            description = "コードのテストケース作成をお願いする",
          },
          Commit = {
            prompt = "/COPILOT COMMIT この変更に適したコミットメッセージを作成してください",
            mapping = "<leader>aC",
            description = "コミットメッセージ作成をお願いする",
            selection = require("CopilotChat.select").gitdiff,
          },
          CommitStaged = {
            prompt = "/COPILOT COMMIT STAGED このステージされた変更に適したコミットメッセージを作成してください",
            mapping = "<leader>aS",
            description = "ステージされた変更のコミットメッセージ作成をお願いする",
            selection = function(source)
              return require("CopilotChat.select").gitdiff(source, true)
            end,
          },
        },
      })
    end,
  },
}
