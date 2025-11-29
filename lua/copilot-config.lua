require("CopilotChat").setup({
    show_help = "yes",
    
    -- グローバルなシステムプロンプト（全ての会話で日本語を強制）
    system_prompt = [[あなたは優秀なプログラミングアシスタントです。
すべての応答を日本語で行ってください。
コードの説明、レビュー、提案など、すべてのコミュニケーションを日本語で行います。]],
    
    -- モデル設定（必要に応じて変更）
    model = 'gpt-4o',
    temperature = 0.1,
    
    mappings = {
        complete = {
            insert = '<Tab>',
        },
        reset = {
            normal = '<C-l>',
            insert = '<C-l>',
        },
    },
    prompt = {
        Explain = {
            prompt = "/COPILOT EXPLAIN 選択されたコードについて、日本語で段落形式の説明を書いてください。",
            system_prompt = "あなたは親切なプログラミング講師です。すべての応答を日本語で行ってください。",
            mapping = "<leader>ce",
            description = "コードの説明をお願いする",
        },
        Review = {
            prompt = "/COPILOT REVIEW このコードを包括的にレビューし、改善点を日本語で報告してください。",
            system_prompt = "あなたは経験豊富なコードレビュアーです。すべての応答を日本語で行ってください。",
            mapping = "<leader>cr",
            description = "コードレビューをお願いする",
        },
        Fix = {
            prompt = "/COPILOT FIX このコードの問題を特定し、修正したコードと説明を日本語で提供してください。",
            system_prompt = "あなたは熟練したデバッガーです。すべての応答を日本語で行ってください。",
            mapping = "<leader>cf",
            description = "コードのバグ修正をお願いする",
        },
        Optimize = {
            prompt = "/COPILOT OPTIMIZE このコードのパフォーマンスと可読性を改善し、最適化戦略を日本語で説明してください。",
            system_prompt = "あなたはパフォーマンス最適化の専門家です。すべての応答を日本語で行ってください。",
            mapping = "<leader>co",
            description = "コードの最適化をお願いする",
        },
        Docs = {
            prompt = "/COPILOT DOCS 選択されたコードに適切なドキュメントコメントを日本語で追加してください。",
            system_prompt = "あなたは技術文書作成の専門家です。すべての応答を日本語で行ってください。",
            mapping = "<leader>cd",
            description = "コードのドキュメント追加をお願いする",
        },
        Tests = {
            prompt = "/COPILOT TESTS 選択されたコードのテストケースを生成し、日本語で説明してください。",
            system_prompt = "あなたはテスト駆動開発の専門家です。すべての応答を日本語で行ってください。",
            mapping = "<leader>ct",
            description = "コードのテストケース作成をお願いする",
        },
        Commit = {
            prompt = "/COPILOT COMMIT この変更に適したコミットメッセージを作成してください",
            mapping = "<leader>cC",
            description = "コミットメッセージ作成をお願いする",
            selction = require("CopilotChat.select").gitdiff,
        },
        CommitStaged = {
            prompt = "/COPILOT COMMIT STAGED このステージされた変更に適したコミットメッセージを作成してください",
            mapping = "<leader>cS",
            description = "ステージされた変更のコミットメッセージ作成をお願いする",
            selction = function(source)
                return require("CopilotChat.select").gitdiff(source, true)
            end,
        },
    },
})
