This pattern involves using backtracking to explore all possible orderings (permutations) of elements or to find all possible paths through a constrained space, such as a grid or a decision tree. These problems often require making a choice, exploring the consequences of that choice, and then undoing it (backtracking) to explore other options.

---
### 1. Generate Parentheses
`[MEDIUM]` `#recursion` `#backtracking` `#string-generation`

#### Problem Statement
Given `n` pairs of parentheses, write a function to generate all combinations of well-formed parentheses.

**Example 1:**
- **Input:** n = 3
- **Output:** `["((()))", "(()())", "(())()", "()(())", "()()()"]`

#### Implementation Overview
A combination of parentheses is well-formed if, at no point while reading from left to right, the number of closing parentheses exceeds the number of opening parentheses, and the total counts are equal at the end. This constraint guides the recursion.

1.  **Recursive Function Signature:** `generate(open_count, close_count, current_string)`
2.  **Base Case:** When the length of the `current_string` is `2 * n`, we have a complete and valid combination. Add it to the results.
3.  **Recursive Step:**
    - **Choice 1 (Add an open parenthesis):** If the number of open parentheses used (`open_count`) is less than `n`, we can add a '('. We then recurse with `open_count + 1`.
    - **Choice 2 (Add a close parenthesis):** If the number of close parentheses used (`close_count`) is less than the number of open parentheses used (`open_count`), we can add a ')'. This rule ensures we never have a malformed prefix. We then recurse with `close_count + 1`.

#### Tricks/Gotchas
- The core of the solution is the two simple conditions (`open_count < n` and `close_count < open_count`) that prune the search space, ensuring only valid combinations are ever generated.

---
### 2. Letter Combinations of a Phone number
`[MEDIUM]` `#recursion` `#backtracking` `#hashmap`

#### Problem Statement
Given a string containing digits from 2-9 inclusive, return all possible letter combinations that the number could represent. A mapping of digits to letters (just like on the telephone buttons) is given.

**Example 1:**
- **Input:** digits = "23"
- **Output:** `["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"]`

#### Implementation Overview
This is a permutation problem where we explore the combinations of letters for a sequence of digits.

1.  **Setup:** Create a mapping from digits to their corresponding letters (e.g., '2' -> "abc", '3' -> "def", ...).
2.  **Recursive Function Signature:** `find_combinations(index, current_combination)`
3.  **Base Case:** If `index` reaches the end of the input `digits` string, `current_combination` is a complete and valid result. Add it to the list.
4.  **Recursive Step:**
    - Get the string of letters for the digit at the current `index` (e.g., "abc" for '2').
    - Loop through each character of this letter string.
    - For each character, append it to `current_combination` and make a recursive call for the next index: `find_combinations(index + 1, ...)`.
    - **Backtrack:** After the recursive call returns, remove the character from `current_combination` to prepare for the next iteration of the loop.

#### Tricks/Gotchas
- An empty input string should result in an empty list, which should be handled as an edge case.
- Using a `StringBuilder` or a list of characters for `current_combination` is more efficient than string concatenation in a loop.

---
### 3. Palindrome Partitioning
`[MEDIUM]` `#recursion` `#backtracking` `#dynamic-programming`

#### Problem Statement
Given a string `s`, partition `s` such that every substring of the partition is a palindrome. Return all possible palindrome partitionings of `s`.

**Example 1:**
- **Input:** s = "aab"
- **Output:** `[["a", "a", "b"], ["aa", "b"]]`

#### Implementation Overview
The strategy is to iterate through all possible prefixes of the current string. If a prefix is a palindrome, we add it to our current partition and recursively solve for the rest of the string.

1.  **Recursive Function Signature:** `partition_helper(start_index, current_partition)`
2.  **Base Case:** If `start_index` reaches the end of the string, it means the entire string has been successfully partitioned into palindromes. Add a copy of `current_partition` to the results.
3.  **Recursive Step:**
    - Loop `i` from `start_index` to the end of the string. This `i` defines the end of the current substring we're checking.
    - The substring is `s[start_index...i]`. Check if it is a palindrome.
    - If it is, add the substring to `current_partition` and make a recursive call for the rest of the string: `partition_helper(i + 1, ...)`.
    - **Backtrack:** After the call returns, remove the substring from `current_partition`.

#### Tricks/Gotchas
- A helper function `isPalindrome()` is required.
- **Optimization:** Checking for palindromes repeatedly can be slow. A common optimization is to precompute a 2D DP table `dp[i][j]` that stores whether the substring `s[i...j]` is a palindrome, reducing the check to an O(1) lookup.

---
### 4. Word Search
`[MEDIUM]` `#recursion` `#backtracking` `#matrix` `#dfs`

#### Problem Statement
Given an `m x n` grid of characters `board` and a string `word`, return `true` if `word` exists in the grid. The word can be constructed from letters of sequentially adjacent cells (horizontally or vertically). The same letter cell may not be used more than once.

**Example 1:**
- **Input:** `board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]]`, `word = "ABCCED"`
- **Output:** `true`

#### Implementation Overview
This is a classic Depth First Search (DFS) problem on a 2D grid. We search the entire grid for the first letter of the word. Once found, we launch a recursive DFS from that cell to find the rest of the word.

1.  **Main Function:** Loop through every cell `(r, c)` of the `board`. If `board[r][c]` matches `word[0]`, start a DFS from there. If the DFS returns `true`, the word is found.
2.  **Recursive DFS Signature:** `dfs(row, col, k)` which checks if `word` starting from index `k` can be formed from `board[row][col]`.
3.  **Base Case:** If `k` equals the length of `word`, we have successfully found all characters in order. Return `true`.
4.  **Recursive Step & Constraints:**
    - Check for invalid states: out of bounds, or the character `board[row][col]` does not match `word[k]`. If so, return `false`.
    - **Mark as visited:** To prevent reusing a cell, temporarily modify the board at `(row, col)` (e.g., `board[row][col] = '#'`).
    - Explore the 4 neighbors (up, down, left, right) with a recursive call `dfs(neighbor_r, neighbor_c, k + 1)`. If any of these calls return `true`, it means a path was found.
    - **Backtrack:** Before returning, restore the original character to `board[row][col]`. This is crucial so that the cell can be used in other potential paths originating from a different starting cell.

#### Tricks/Gotchas
- The backtracking step (restoring the board character) is the most important part of the algorithm. Forgetting it will lead to incorrect results.

---
### 5. N-Queens
`[HARD]` `#recursion` `#backtracking`

#### Problem Statement
The N-Queens puzzle is the problem of placing `N` chess queens on an `N x N` chessboard such that no two queens threaten each other. Given an integer `n`, return all distinct solutions to the N-Queens puzzle.

#### Implementation Overview
The core idea is to place one queen in each column, one by one. For each column, we try placing a queen in every row and check if that placement is valid (i.e., it doesn't conflict with previously placed queens).

1.  **Recursive Function Signature:** `solve(col, board)`
2.  **Base Case:** If `col == N`, it means we have successfully placed a queen in every column from 0 to N-1. This is a valid solution, so we format the `board` and add it to our results.
3.  **Recursive Step:** For the current column `col`:
    - Iterate through each row `r` from 0 to N-1.
    - For each cell `(r, col)`, check if it's `isSafe` to place a queen there.
    - If it is safe, place the queen (`board[r][col] = 'Q'`) and make a recursive call for the next column: `solve(col + 1, board)`.
    - **Backtrack:** After the recursive call returns, remove the queen (`board[r][col] = '.'`) to explore other possibilities for the current column.

#### Tricks/Gotchas
- **`isSafe` Check:** A naive `isSafe` function would check the entire row to the left, the upper-left diagonal, and the lower-left diagonal.
- **Optimization:** The `isSafe` check can be optimized from O(N) to O(1) by using hash sets or boolean arrays to keep track of which rows, upper-diagonals, and lower-diagonals are under attack. The diagonals can be identified by constant sums or differences of their coordinates: `row + col` for one diagonal and `row - col` for the other.

---
### 6. Rat in a Maze
`[HARD]` `#recursion` `#backtracking` `#matrix` `#dfs`

#### Problem Statement
Given a square maze `m` of size `N x N` where `m[i][j] = 1` means the block is open and `m[i][j] = 0` means the block is a wall. A rat starts at `(0, 0)` and wants to reach the destination at `(N-1, N-1)`. The rat can move in four directions: Up (U), Down (D), Left (L), and Right (R). Find all possible paths for the rat.

#### Implementation Overview
This is another DFS-on-a-grid problem, very similar to Word Search. We explore all possible paths from the start to the end, backtracking when we hit a wall or a previously visited cell.

1.  **Recursive Function Signature:** `find_paths(row, col, maze, current_path)`
2.  **Base Case:** If the rat is at the destination `(N-1, N-1)`, we have found a valid path. Add `current_path` to the results and return.
3.  **Recursive Step & Constraints:**
    - Check for invalid moves: out of bounds, current cell is a wall (`maze[row][col] == 0`), or the cell has already been visited.
    - **Mark as visited:** To prevent cycles, use a separate `visited` matrix or modify the `maze` itself (e.g., set `maze[row][col] = 0`).
    - Explore all 4 directions (often in a specific lexicographical order like D, L, R, U). For each valid move:
        - Append the direction character ('D', 'L', etc.) to `current_path`.
        - Make a recursive call for the new cell and the updated path.
    - **Backtrack:** Un-mark the current cell as visited so it can be part of other paths.

#### Tricks/Gotchas
- A `visited` matrix is essential for correctness and to prevent infinite loops.
- The starting cell `(0,0)` might be a wall, which is an edge case to handle.

---
### 7. Word Break
`[MEDIUM]` `#recursion` `#backtracking` `#dynamic-programming`

#### Problem Statement
Given a string `s` and a dictionary of strings `wordDict`, return `true` if `s` can be segmented into a space-separated sequence of one or more dictionary words. Note that the same word in the dictionary may be reused multiple times in the segmentation.

**Example 1:**
- **Input:** s = "leetcode", wordDict = ["leet", "code"]
- **Output:** `true`

#### Implementation Overview
This is a partitioning problem where we check if any prefix of the string is a valid word from the dictionary. If it is, we recursively check if the remaining suffix can also be broken down.

1.  **Recursive Function Signature:** `can_break(substring)`
2.  **Base Case:** If the `substring` is empty, it means the entire original string has been successfully segmented. Return `true`.
3.  **Recursive Step:**
    - Iterate `i` from 1 to `len(substring)`.
    - The `prefix` is `substring[0...i]`. Check if this `prefix` exists in the `wordDict`.
    - If it does, make a recursive call on the `suffix`: `can_break(substring[i...])`.
    - If the recursive call returns `true`, it means we have found a valid segmentation path. Return `true` immediately.
4.  If the loop completes without finding any valid segmentation, return `false`.

#### Tricks/Gotchas
- **Performance:** The pure recursive solution has a very high time complexity due to re-computing results for the same substrings. This problem is a classic candidate for **memoization** (a form of dynamic programming) to store the results for substrings that have already been computed.
- Using a `Set` for the `wordDict` provides fast O(1) average time lookups.

---
### 8. M-Coloring Problem
`[HARD]` `#recursion` `#backtracking` `#graph`

#### Problem Statement
Given an undirected graph with `N` vertices and an integer `M`, determine if the graph can be colored with at most `M` colors such that no two adjacent vertices have the same color.

#### Implementation Overview
We attempt to color the graph's vertices one by one, from vertex 0 to N-1. For each vertex, we try to assign it a color from 1 to `M`.

1.  **Recursive Function Signature:** `solve(node_index, colors_array)`
2.  **Base Case:** If `node_index == N`, it means we have successfully assigned a valid color to all vertices. Return `true`.
3.  **Recursive Step:** For the current vertex `node_index`:
    - Loop through each color `c` from 1 to `M`.
    - Check if it is `isSafe` to assign color `c` to `node_index`. This involves checking all of `node_index`'s neighbors to see if any of them are already assigned color `c`.
    - If it is safe, assign the color (`colors_array[node_index] = c`) and recursively call `solve(node_index + 1, ...)`.
    - If the recursive call returns `true`, it means a valid coloring was found. Propagate this `true` return up the call stack.
4.  If the loop finishes and no color from 1 to `M` could be safely assigned, it means the current path of coloring is invalid. Return `false`, which triggers backtracking in the previous call.

#### Tricks/Gotchas
- The graph must be represented in a usable format, typically an adjacency list or adjacency matrix.
- The `isSafe` function is the heart of the constraint satisfaction logic.

---
### 9. Sudoku Solver
`[HARD]` `#recursion` `#backtracking` `#matrix`

#### Problem Statement
Write a program to solve a Sudoku puzzle by filling the empty cells. A sudoku solution must satisfy all of the following rules:
1. Each of the digits 1-9 must occur exactly once in each row.
2. Each of the digits 1-9 must occur exactly once in each column.
3. Each of the digits 1-9 must occur exactly once in each of the nine 3x3 sub-boxes of the grid.

#### Implementation Overview
The strategy is to scan the board to find the next empty cell ('.'). For that empty cell, we try placing each digit from '1' to '9' and see if it's a valid placement according to Sudoku rules.

1.  **Recursive Function Signature:** A simple `solve()` function that operates on a global or referenced board.
2.  **Base Case:** The recursion doesn't have an explicit base case based on a parameter. Instead, the loop to find an empty cell serves as the base case: if the loop completes without finding any empty cells, the board is full and solved. The function can return `true`.
3.  **Recursive Step:**
    - Find the next empty cell `(r, c)`.
    - Loop through digits `d` from '1' to '9'.
    - For each digit, check if it's `isValid` to place `d` at `(r, c)`.
    - If it's valid, place the digit (`board[r][c] = d`) and make a recursive call to `solve()`.
    - If the recursive call returns `true`, it means the rest of the puzzle was solved successfully. Propagate `true` up the call stack.
    - **Backtrack:** If the recursive call returns `false`, it was a dead end. Reset the cell (`board[r][c] = '.'`) and try the next digit in the loop.
4. If the loop for digits 1-9 completes and none lead to a solution, return `false`.

#### Tricks/Gotchas
- The `isValid` check must correctly verify the row, column, and the 3x3 sub-grid for the given digit. Calculating the top-left corner of the 3x3 sub-grid is a common small hurdle: `(r/3)*3`, `(c/3)*3`.

---
### 10. Expression Add Operators
`[HARD]` `#recursion` `#backtracking` `#string-manipulation`

#### Problem Statement
Given a string `num` that contains only digits and an integer `target`, return all possibilities to add binary operators `+`, `-`, or `*` between the digits of `num` so that the resultant expression evaluates to `target`.

**Example 1:**
- **Input:** num = "123", target = 6
- **Output:** `["1*2*3", "1+2+3"]`

#### Implementation Overview
This is a complex backtracking problem where we not only build the expression string but also evaluate it on the fly. The main difficulty is handling multiplication's higher precedence.

1.  **Recursive Function Signature:** `dfs(index, path, current_val, prev_operand)`
    - `index`: The current starting position in the `num` string.
    - `path`: The expression string built so far.
    - `current_val`: The evaluated result of the `path` so far.
    - `prev_operand`: The value of the last operand that was added to the expression. This is the key to handling multiplication.
2.  **Base Case:** If `index` reaches the end of `num`:
    - If `current_val == target`, we have found a valid expression. Add `path` to the results.
3.  **Recursive Step:**
    - Loop `i` from `index` to the end of `num` to generate the current number operand.
    - For each generated number `s`:
        - **If it's the first number in the expression:** Make a single recursive call with this number.
        - **If not the first number:**
            - **'+'**: Recurse with `current_val + s` and `prev_operand = s`.
            - **'-'**: Recurse with `current_val - s` and `prev_operand = -s`.
            - **'*'**: This is the tricky part. The new value is `(current_val - prev_operand) + (prev_operand * s)`. The new `prev_operand` becomes `prev_operand * s`. This logic effectively undoes the previous addition/subtraction of `prev_operand` and applies the multiplication instead.

#### Tricks/Gotchas
- **Multiplication Precedence:** The `prev_operand` trick is the standard way to solve this.
- **Leading Zeros:** Numbers in the expression cannot have leading zeros unless they are the number 0 itself. You must add a check to skip numbers like "05".
- **Overflow:** The intermediate `current_val` can exceed the standard 32-bit integer limit, so use 64-bit integers (longs) for calculations.
