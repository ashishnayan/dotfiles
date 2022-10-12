vim.g.startify_session_dir = '~/.config/nvim/session'
vim.g.startify_padding_left = 4
vim.g.startify_lists = {
  { type= 'files',     header= {'   Files'}            },
  { type= 'dir',       header= {'   Current Directory '.. vim.fn['getcwd']()} },
  { type= 'sessions',  header= {'   Sessions'}       },
  { type= 'bookmarks', header= {'   Bookmarks'}      },
}

vim.g.startify_session_autoload = 1
vim.g.startify_session_delete_buffers = 1
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_enable_special = 0
vim.g.tartify_session_persistence = 1
vim.g.startify_bookmarks = {
  { nc = [[~/.config/nvim]] },
  { il = [[~/.config/nvim/init.lua]] },
  { z = [[~/.zshrc]] },
}
-- vim.g.startify_custom_header = {
--   [[        /$$$$$$                 /$$     /$$                          ]],
--   [[       /$$$__  $$$              | $$    | $$                          ]],
--   [[      /$$_/  \_  $$   /$$$$$$  /$$$$$$  | $$$$$$$  /$$   /$$  /$$$$$$ ]],
--   [[     /$$/ /$$$$$  $$ /$$__  $$|_  $$_/  | $$__  $$| $$  | $$ /$$__  $$]],
--   [[    | $$ /$$  $$| $$| $$  \__/  | $$    | $$  \ $$| $$  | $$| $$  \__/]],
--   [[    | $$| $$\ $$| $$| $$        | $$ /$$| $$  | $$| $$  | $$| $$      ]],
--   [[    | $$|  $$$$$$$$/| $$        |  $$$$/| $$  | $$|  $$$$$$/| $$      ]],
--   [[    |  $$\________/ |__/         \___/  |__/  |__/ \______/ |__/      ]],
--   [[     \  $$$   /$$$                                                    ]],
--   [[      \_  $$$$$$_/                                                    ]],
--   [[        \______/                                                      ]],
-- }

-- vim.g.startify_custom_header = {
-- [[                        ]],
-- [[         )   (      )    ]],
-- [[  (     /((  )\    (     ]],
-- [[  )\ ) (_))\((_)   )\  ' ]],
-- [[ _(_/( _)((_)(_) _((_))  ]],
-- [[| ' \))\ V / | || '  \() ]],
-- [[|_||_|  \_/  |_||_|_|_|  ]],
-- [[                         ]],
-- }


vim.g.startify_custom_header = {
[[                       .            .      ]],
[[                     .,;'           :,.    ]],
[[                   .,;;;,,.         ccc;.  ]],
[[                 .;c::::,,,'        ccccc: ]],
[[                 .::cc::,,,,,.      cccccc.]],
[[                 .cccccc;;;;;;'     llllll.]],
[[                 .cccccc.,;;;;;;.   llllll.]],
[[                 .cccccc  ';;;;;;'  oooooo.]],
[[                 'lllllc   .;;;;;;;.oooooo']],
[[                 'lllllc     ,::::::looooo']],
[[                 'llllll      .:::::lloddd']],
[[                 .looool       .;::coooodo.]],
[[                   .cool         'ccoooc.  ]],
[[                     .co          .:o:.    ]],
[[                       .           .'      ]],
}
