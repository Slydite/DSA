# Pattern 3: DP on Squares

This is a mini-pattern that deals with problems on a 2D grid where the goal is to find or count square or rectangular submatrices with a specific property (e.g., all ones). The DP state `dp[i][j]` typically stores information about a shape ending at cell `(i, j)`.

---

### 1. Count Square Submatrices with All Ones
`[MEDIUM]` `#dp-on-squares` `#grid-dp`

#### Problem Statement
Given a `m x n` matrix of ones and zeros, return how many square submatrices have all ones.

#### Recurrence Relation
Let `dp[i][j]` be the side length of the largest square of all ones whose **bottom-right corner** is at `(i, j)`.
- If `matrix[i][j] == 0`, no square can end here, so `dp[i][j] = 0`.
- If `matrix[i][j] == 1`, the size of the square ending here is limited by the squares ending at its top, left, and top-left neighbors.
- **`dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])`**
- **Counting Insight:** A `dp[i][j]` value of `k` means there is a `k x k` square, a `(k-1) x (k-1)` square, ..., and a `1 x 1` square all ending at this corner. Therefore, the total number of squares is the sum of all values in the `dp` table.

---
#### a) Memoization (Top-Down)
This approach is less intuitive for this problem. We define `solve(i, j)` which computes `dp[i][j]` and adds it to a total.

```python
def count_squares_memo(matrix: list[list[int]]) -> int:
    m, n = len(matrix), len(matrix[0])
    dp = [[-1] * n for _ in range(m)]

    def solve(r, c):
        if r < 0 or c < 0 or matrix[r][c] == 0:
            return 0
        if dp[r][c] != -1:
            return dp[r][c]

        # Recursively find the size of squares ending at neighbors
        top = solve(r - 1, c)
        left = solve(r, c - 1)
        diag = solve(r - 1, c - 1)

        dp[r][c] = 1 + min(top, left, diag)
        return dp[r][c]

    total_squares = 0
    for i in range(m):
        for j in range(n):
            total_squares += solve(i, j)

    return total_squares
```
- **Time Complexity:** O(m * n). Each state `dp[i][j]` is computed once.
- **Space Complexity:** O(m * n) for DP table + O(m+n) for recursion stack.

---
#### b) Tabulation (Bottom-Up)
This is the most natural approach. We build the `dp` table and sum its values.

```python
def count_squares_tab(matrix: list[list[int]]) -> int:
    m, n = len(matrix), len(matrix[0])
    dp = [[0] * n for _ in range(m)]
    total_squares = 0

    for i in range(m):
        for j in range(n):
            if matrix[i][j] == 1:
                if i == 0 or j == 0:
                    dp[i][j] = 1
                else:
                    dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])
                total_squares += dp[i][j]

    return total_squares
```
- **Time Complexity:** O(m * n).
- **Space Complexity:** O(m * n).
- **Note:** This can be space-optimized to O(n) or even O(1) by modifying the input matrix in-place, as the original values at `(i-1,j)`, etc., are no longer needed after `dp[i][j]` is computed.

---

### 2. Maximal Rectangle
`[HARD]` `#dp-on-squares` `#grid-dp` `#histogram` `#stack`

#### Problem Statement
Given a `m x n` binary matrix filled with 0s and 1s, find the largest rectangle containing only 1s and return its area.

#### Implementation Overview
This is a famous problem that is solved by reducing it to a series of "Largest Rectangle in Histogram" problems. The DP aspect is in how we build the histogram for each row.

1.  **DP State (Implicit):** We process the matrix row by row. For each row `i`, we create a `heights` array where `heights[j]` represents the number of consecutive `1`s above `matrix[i][j]` (including the cell itself).
2.  **DP Transition:**
    - `for row in matrix:`
    - `for j in range(n):`
    - `heights[j] = heights[j] + 1 if row[j] == '1' else 0`
3.  **Subproblem:** After computing the `heights` array for a row, it represents a histogram. We then solve the "Largest Rectangle in Histogram" problem for this histogram. This subproblem is typically solved in O(n) using a monotonic stack.
4.  **Combine:** The final answer is the maximum area found across all rows.

#### Python Code Snippet
```python
def maximal_rectangle(matrix: list[list[str]]) -> int:
    if not matrix or not matrix[0]:
        return 0

    m, n = len(matrix), len(matrix[0])
    # DP state: heights[j] = consecutive 1s above current cell in column j
    heights = [0] * n
    max_area = 0

    def largest_rectangle_in_histogram(h: list[int]) -> int:
        stack = [-1] # Sentinel value
        max_h_area = 0
        for i, height in enumerate(h):
            while stack[-1] != -1 and h[stack[-1]] >= height:
                h_pop = h[stack.pop()]
                w = i - stack[-1] - 1
                max_h_area = max(max_h_area, h_pop * w)
            stack.append(i)

        while stack[-1] != -1:
            h_pop = h[stack.pop()]
            w = len(h) - stack[-1] - 1
            max_h_area = max(max_h_area, h_pop * w)
        return max_h_area

    # Iterate through each row, treating it as the base of a histogram
    for i in range(m):
        # Build the histogram heights for the current row
        for j in range(n):
            heights[j] = heights[j] + 1 if matrix[i][j] == '1' else 0

        # Calculate max area for this histogram and update overall max
        max_area = max(max_area, largest_rectangle_in_histogram(heights))

    return max_area
```
- **Time Complexity:** O(m * n). We iterate through each cell once to build the histogram, and the histogram calculation for each row is O(n).
- **Space Complexity:** O(n) to store the `heights` array and the stack for the subproblem.
