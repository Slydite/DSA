# Pattern 2: DP on Grids - Pathfinding

This pattern covers fundamental Dynamic Programming problems on 2D grids. The core idea is to treat the grid itself as the DP table (or use a separate one of the same dimensions). Each cell `dp[i][j]` stores the solution to a subproblem ending at that cell, typically by combining solutions from adjacent cells (usually top and left).

---

### 1. Grid Unique Paths (DP8)
`[MEDIUM]` `#grid-dp` `#pathfinding`

#### Problem Statement
You are on a `m x n` grid. You are initially at the top-left corner `(0, 0)` and want to reach the bottom-right corner `(m-1, n-1)`. You can only move either down or right at any point in time. Find the total number of unique paths.

#### Implementation Overview
-   **Recurrence Relation:** Let `dp[i][j]` be the number of unique paths to reach cell `(i, j)`. To reach `(i, j)`, you must have come from either `(i-1, j)` (from above) or `(i, j-1)` (from the left). Therefore, the total number of ways is the sum of the ways to reach those cells: `dp[i][j] = dp[i-1][j] + dp[i][j-1]`.
-   **Base Cases:** The entire first row and first column can only be reached in one way (by moving only right or only down). So, `dp[i][0] = 1` for all `i`, and `dp[0][j] = 1` for all `j`.
-   **Tabulation:** Create a `m x n` DP grid and fill it row by row, column by column, using the recurrence. The answer is `dp[m-1][n-1]`.
-   **Space Optimization:** Since `dp[i][j]` only depends on the previous row and the current row's previous column, we can optimize space from O(m*n) to O(n) by using only two rows or even just one row.

---

### 2. Grid Unique Paths 2 (DP 9)
`[MEDIUM]` `#grid-dp` `#pathfinding` `#obstacles`

#### Problem Statement
This is a follow-up to the previous problem. Now, there are obstacles in the grid. An obstacle is marked as `1` and an empty space is marked as `0`. You cannot move through an obstacle. Find the number of unique paths.

#### Implementation Overview
The logic is the same, but we must account for obstacles.
-   **Recurrence Relation:**
    -   If `grid[i][j] == 1` (is an obstacle), then `dp[i][j] = 0`.
    -   Otherwise, `dp[i][j] = dp[i-1][j] + dp[i][j-1]`.
-   **Base Cases:** The base cases are more complex. `dp[0][0]` is 1 if it's not an obstacle, else 0. For the first row/column, `dp[i][0]` is 1 only if all cells from `(0,0)` to `(i,0)` are clear. The moment an obstacle is hit, all subsequent cells in that row/column become unreachable (0 paths).

#### Tricks/Gotchas
-   Pay close attention to the base case `(0, 0)`. If the starting cell itself is an obstacle, no paths are possible.
-   The obstacle check must be performed before applying the recurrence relation.

---

### 3. Minimum Path Sum in Grid (DP 10)
`[MEDIUM]` `#grid-dp` `#pathfinding` `#min-cost`

#### Problem Statement
Given a `m x n` grid filled with non-negative numbers, find a path from the top-left to the bottom-right which minimizes the sum of all numbers along its path. You can only move either down or right.

#### Implementation Overview
Instead of counting paths, we are now finding a minimum cost.
-   **Recurrence Relation:** Let `dp[i][j]` be the minimum path sum to reach cell `(i, j)`. To reach `(i, j)`, you must have come from `(i-1, j)` or `(i, j-1)`. We should choose the path that has the minimum sum so far.
    `dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])`.
-   **Base Cases:**
    -   `dp[0][0] = grid[0][0]`.
    -   First row: `dp[0][j] = grid[0][j] + dp[0][j-1]`.
    -   First column: `dp[i][0] = grid[i][0] + dp[i-1][0]`.
-   **Tabulation:** This can be solved by modifying the grid in-place to save space, effectively using the input grid as our DP table.

---

### 4. Minimum Path Sum in Triangular Grid (DP 11)
`[MEDIUM]` `#grid-dp` `#pathfinding` `#triangle`

#### Problem Statement
Given a triangle array, find the minimum path sum from the top to the bottom. For each step, you may move to an adjacent number on the row below. Specifically, from index `j` on row `i`, you can move to index `j` or `j+1` on row `i+1`.

#### Implementation Overview
This is a variation of the minimum path sum problem on a differently shaped grid. Working bottom-up is often the most intuitive approach here.
-   **Recurrence Relation (Bottom-Up):** Let `dp[i][j]` be the minimum path sum starting from cell `(i, j)` to the bottom. The recurrence would be `dp[i][j] = grid[i][j] + min(dp[i+1][j], dp[i+1][j+1])`.
-   **Base Cases (Bottom-Up):** The last row of the DP table is the same as the last row of the triangle: `dp[n-1][j] = grid[n-1][j]`.
-   **Tabulation (Bottom-Up):** Start by initializing the DP table's last row. Then, iterate from the second-to-last row up to the top row (`i` from `n-2` down to `0`), filling the table. The answer will be at `dp[0][0]`.
-   **Space Optimization:** Since we only ever need the next row to compute the current row, we can optimize space to O(n) where `n` is the number of rows. We can use a 1D `dp` array representing the "next row" and update it in place as we move up the triangle.
