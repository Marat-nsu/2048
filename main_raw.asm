initialize_game:
  jsr add_new_tile
  jsr add_new_tile
  # Initialize score and game state

move_left:
  for each row (0-3):
    st current_row, [row_num]
    jsr process_row_left
  if grid_changed:
    jsr add_new_tile
    jsr check_game_over
  ret

move_right:
  # Similar to move_left but processes rows in reverse
  jsr process_row_right
  ret

move_up:
  for each column (0-3):
    st current_col, [col_num]
    jsr process_col_up
  # Handle new tile and game over check
  ret

move_down:
  # Similar to move_up but processes columns bottom-to-top
  jsr process_col_down
  ret

process_row_left:
  # 1. Load row cells from memory
  # 2. Slide non-zero tiles left
  # 3. Merge adjacent equals, update score
  # 4. Slide again to fill gaps
  # 5. Store back to memory
  # 6. Set grid_changed flag if modifications occurred
  ret

process_row_right:
  # Mirror of process_row_left with right-direction logic
  ret

process_col_up:
  # 1. Load column cells (strided memory access)
  # 2. Slide non-zero tiles upward
  # 3. Merge adjacent equals
  # 4. Slide again
  # 5. Store back to column
  ret

process_col_down:
  # Mirror of process_col_up with downward logic
  ret

add_new_tile:
  # 1. Count empty cells
  # 2. If none, return
  # 3. Generate random position
  # 4. Get random value (2 or 4)
  # 5. Place in selected empty cell
  ret

check_game_over:
  # 1. Check for any empty cells
  # 2. Check all possible adjacent merges
  # 3. Set game_over flag if no moves remain
  ret

# Helper functions
slide_row_left:    # Compact zeros between tiles
merge_row_left:    # Combine adjacent equal values
transpose_grid:    # Could be used for vertical moves
find_empty_cells:  # Returns count/list of empty positions
update_score:      # Add merged values to score