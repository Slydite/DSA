### `[PATTERN] Backtracking for Permutations and Pathfinding`

This pattern extends the core backtracking concept to solve two common classes of problems:
1.  **Permutations**: Generating all possible orderings of a set of elements.
2.  **Pathfinding / Maze Problems**: Finding all valid paths through a constrained space, such as a grid, graph, or decision tree, while adhering to a set of rules.

The core template of "choose, recurse, backtrack" remains the same, but the state and choices become more complex.

---

### 1. Permutations
`[MEDIUM]` `#backtracking` `#permutations`

#### Problem Statement
Given an array `nums` of distinct integers, return all the possible permutations. You can return the answer in any order.

#### Implementation Overview
To generate permutations, we need to ensure that each element is used exactly once in each permutation.
- **Choice**: At each step, which of the *unused* numbers should we place next in our permutation?
- **Constraint**: A number cannot be used if it's already in the current permutation.
- **Goal**: The length of the permutation equals the length of `nums`.

A common way to track used elements is with a boolean `visited` array.

#### Python Code Snippet
```python
def permute(nums: list[int]) -> list[list[int]]:
    result = []
    current_permutation = []
    visited = [False] * len(nums)

    def backtrack():
        # Base Case: A full permutation is found
        if len(current_permutation) == len(nums):
            result.append(list(current_permutation))
            return

        # Explore choices
        for i in range(len(nums)):
            # Constraint: Only use numbers that haven't been visited
            if not visited[i]:
                # 1. Make a choice
                visited[i] = True
                current_permutation.append(nums[i])

                # 2. Recurse
                backtrack()

                # 3. Backtrack
                current_permutation.pop()
                visited[i] = False

    backtrack()
    return result
```
#### Variation: Permutations II (with duplicates)
If the input array contains duplicates, the above approach will generate duplicate permutations. To fix this, first **sort the input `nums`**. Then, add a condition inside the loop: `if i > 0 and nums[i] == nums[i-1] and not visited[i-1]: continue`. This ensures that for a block of identical numbers, we only pick them in one specific order.

---

### 2. Letter Combinations of a Phone Number
`[MEDIUM]` `#backtracking` `#string-generation`

#### Problem Statement
Given a string containing digits from 2-9, return all possible letter combinations that the number could represent.

#### Implementation Overview
This is a variation of a permutation/combination problem where the choices for each position are defined by a mapping.
- **State**: The current index in the input `digits` string and the combination string built so far.
- **Choice**: For the digit at the current index, which letter should we append to our combination?
- **Goal**: The length of our combination string equals the length of the input `digits` string.

#### Python Code Snippet
```python
def letter_combinations(digits: str) -> list[str]:
    if not digits:
        return []

    mapping = {
        '2': "abc", '3': "def", '4': "ghi", '5': "jkl",
        '6': "mno", '7': "pqrs", '8': "tuv", '9': "wxyz"
    }
    result = []

    def backtrack(index, current_combination):
        # Base Case: Reached the end of the digits string
        if index == len(digits):
            result.append("".join(current_combination))
            return

        # Get letters for the current digit
        possible_letters = mapping[digits[index]]

        # Explore choices
        for letter in possible_letters:
            # 1. Choose
            current_combination.append(letter)
            # 2. Recurse
            backtrack(index + 1, current_combination)
            # 3. Backtrack
            current_combination.pop()

    backtrack(0, [])
    return result
```

---

### 3. Word Search
`[MEDIUM]` `#backtracking` `#pathfinding` `#matrix`

#### Problem Statement
Given an `m x n` grid of characters `board` and a string `word`, return `true` if `word` exists in the grid. The word can be constructed from letters of sequentially adjacent cells (horizontally or vertically). The same letter cell may not be used more than once.

#### Implementation Overview
This is a classic pathfinding problem on a grid. We perform a Depth First Search (DFS) from every cell that could be a potential start of the word.
- **State**: The current position `(row, col)` on the board and the current index `k` in the `word` we are trying to match.
- **Choice**: Which of the four adjacent cells (up, down, left, right) should we move to next?
- **Constraint**: The move must be within the grid boundaries, the cell must match `word[k]`, and the cell must not have been visited before in the current path.
- **Goal**: We have successfully matched all characters in the word (`k == len(word)`).

#### Python Code Snippet
```python
def exist(board: list[list[str]], word: str) -> bool:
    rows, cols = len(board), len(board[0])

    def backtrack(r, c, k):
        # Goal: Successfully found the entire word
        if k == len(word):
            return True

        # Constraints: Check for out-of-bounds or mismatch
        if r < 0 or c < 0 or r >= rows or c >= cols or board[r][c] != word[k]:
            return False

        # 1. Make a choice (and mark as visited)
        original_char = board[r][c]
        board[r][c] = '#' # Mark the cell as visited for this path

        # 2. Recurse on neighbors
        found = (backtrack(r + 1, c, k + 1) or
                 backtrack(r - 1, c, k + 1) or
                 backtrack(r, c + 1, k + 1) or
                 backtrack(r, c - 1, k + 1))

        # 3. Backtrack (undo the choice)
        board[r][c] = original_char # Restore the cell

        return found

    # Try starting the search from every cell
    for r in range(rows):
        for c in range(cols):
            if backtrack(r, c, 0):
                return True

    return False
```

---

### 4. N-Queens
`[HARD]` `#backtracking` `#pathfinding`

#### Problem Statement
The N-Queens puzzle is the problem of placing `N` chess queens on an `N x N` chessboard such that no two queens threaten each other. Given `n`, return all distinct solutions.

#### Implementation Overview
We place one queen per column, ensuring each new placement is safe from all previously placed queens.
- **State**: The current column `col` we are trying to place a queen in, and the `board` configuration.
- **Choice**: In which row `r` of the current column `col` should we place a queen?
- **Constraint**: The chosen cell `(r, col)` must not be under attack by any queen in previous columns.
- **Goal**: We have successfully placed a queen in every column (`col == n`).

#### Python Code Snippet (Optimized)
This version uses sets for an O(1) safety check.
```python
def solve_n_queens(n: int) -> list[list[str]]:
    result = []
    board = [['.' for _ in range(n)] for _ in range(n)]

    # Sets to track attacked columns and diagonals
    attacked_cols = set()
    attacked_pos_diagonals = set() # (r + c) is constant
    attacked_neg_diagonals = set() # (r - c) is constant

    def backtrack(r):
        # Goal: All queens have been placed (one in each row)
        if r == n:
            # Format the board for the result
            copy = ["".join(row) for row in board]
            result.append(copy)
            return

        # Explore choices for the current row `r`
        for c in range(n):
            # Constraints
            if c in attacked_cols or (r + c) in attacked_pos_diagonals or (r - c) in attacked_neg_diagonals:
                continue

            # 1. Make a choice
            board[r][c] = 'Q'
            attacked_cols.add(c)
            attacked_pos_diagonals.add(r + c)
            attacked_neg_diagonals.add(r - c)

            # 2. Recurse
            backtrack(r + 1)

            # 3. Backtrack
            board[r][c] = '.'
            attacked_cols.remove(c)
            attacked_pos_diagonals.remove(r + c)
            attacked_neg_diagonals.remove(r - c)

    backtrack(0)
    return result
```

---

### 5. Sudoku Solver
`[HARD]` `#backtracking` `#pathfinding` `#matrix`

#### Problem Statement
Write a program to solve a Sudoku puzzle by filling the empty cells ('.').

#### Implementation Overview
We find the next empty cell and try placing digits from 1 to 9. If a digit is valid according to Sudoku rules, we place it and recurse. If the recursive call fails, we backtrack.
- **State**: The entire `board`. The search for the next empty cell is part of the function logic.
- **Choice**: For the next empty cell `(r, c)`, which digit from '1' to '9' should we place?
- **Constraint**: The chosen digit must not already exist in the same row, column, or 3x3 sub-grid.
- **Goal**: There are no more empty cells on the board.

#### Python Code Snippet
```python
def solve_sudoku(board: list[list[str]]) -> None:
    """
    Solves the Sudoku puzzle in-place.
    """
    def is_valid(r, c, digit):
        for i in range(9):
            # Check row and column
            if board[r][i] == digit or board[i][c] == digit:
                return False
            # Check 3x3 sub-grid
            box_r, box_c = 3 * (r // 3), 3 * (c // 3)
            if board[box_r + i // 3][box_c + i % 3] == digit:
                return False
        return True

    def backtrack():
        # Find the next empty cell
        for r in range(9):
            for c in range(9):
                if board[r][c] == '.':
                    # Try placing digits 1-9
                    for digit in "123456789":
                        if is_valid(r, c, digit):
                            # 1. Choose
                            board[r][c] = digit

                            # 2. Recurse
                            if backtrack():
                                return True # Solution found

                            # 3. Backtrack
                            board[r][c] = '.'

                    return False # No valid digit found for this cell

        return True # Goal: No empty cells left, puzzle solved

    backtrack()
```
