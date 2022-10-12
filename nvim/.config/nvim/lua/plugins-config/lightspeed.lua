require'lightspeed'.setup {
  exit_after_idle_msecs = { labeled = nil, unlabeled = 1000 },

  -- s/x
  -- grey_out_search_area = true,
  -- highlight_unique_chars = true,
  match_only_the_start_of_same_char_seqs = true,
  -- jump_on_partial_input_safety_timeout = 400,
  substitute_chars = { ['\r'] = '¬' },
  -- Leaving the appropriate list empty effectively disables
  -- "smart" mode, and forces auto-jump to be on or off.
  -- safe_labels = { ... },
  -- labels = { ... },
  -- Target keys
	labels = {'d', 'k', 'f', 'j', 's', 'l', 'a', ';', ',', 'c', 'm', 'e', 'i', 'w', 'o', 'g', 'h', 'v', 'n', 'r', 'u', 't', 'x', ',', 'q', 'p', '[', ']', 'z', '.', '/', 'y', 'b'},

  special_keys = {
    next_match_group = '<space>',
    prev_match_group = '<tab>'
  },
  -- x_mode_prefix_key = '<c-x>',

  -- f/t
  limit_ft_matches = 4,
  repeat_ft_with_target_char = false,
}
