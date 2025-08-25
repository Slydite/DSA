# Pattern 2: DP on Grids - Pathfinding

This pattern covers fundamental Dynamic Programming problems on 2D grids. The core idea is to treat the grid itself as the DP table (or use a separate one of the same dimensions). Each cell `dp[i][j]` stores the solution to a subproblem ending at that cell, typically by combining solutions from adjacent cells (usually top and left).

---

### 1. Grid Unique Paths
`[MEDIUM]` `#grid-dp` `#pathfinding`

#### Problem Statement
You are on a `m x n` grid. You are initially at the top-left corner `(0, 0)` and want to reach the bottom-right corner `(m-1, n-1)`. You can only move either down or right at any point in time. Find the total number of unique paths.

*Example:* `m = 3`, `n = 7`. **Output:** `28`

#### Implementation Overview
-   **Recurrence Relation:** Let `dp[i][j]` be the number of unique paths to reach cell `(i, j)`. To reach `(i, j)`, you must have come from either `(i-1, j)` (from above) or `(i, j-1)` (from the left). Therefore, `dp[i][j] = dp[i-1][j] + dp[i][j-1]`.
-   **Base Cases:** The entire first row and first column can only be reached in one way. So, `dp[i][0] = 1` and `dp[0][j] = 1`.
-   **Space Optimization:** Since `dp[i][j]` only depends on the previous row and the current row, we can optimize space from O(m*n) to O(n) by using a single array `prev_row` to store the results of the previous row's computation.

#### Python Code Snippet (Space Optimized)
```python
def unique_paths(m: int, n: int) -> int:
    # dp[j] will store the number of ways to reach cell (i, j)
    # We initialize it to the base case for the first row
    prev_row = [1] * n

    for i in range(1, m):
        current_row = [1] * n # The first element of every row is always 1
        for j in range(1, n):
            # current_row[j] corresponds to dp[i][j]
            # prev_row[j] corresponds to dp[i-1][j]
            # current_row[j-1] corresponds to dp[i][j-1]
            current_row[j] = prev_row[j] + current_row[j-1]
        prev_row = current_row

    return prev_row[n-1]
```
*Note: This problem also has a more efficient O(min(m,n)) time combinatorial solution: `(m+n-2) choose (m-1)`.*

---

### 2. Grid Unique Paths II (With Obstacles)
`[MEDIUM]` `#grid-dp` `#pathfinding` `#obstacles`

#### Problem Statement
This is a follow-up to the previous problem. Now, there are obstacles in the grid. An obstacle is marked as `1` and an empty space is marked as `0`. You cannot move through an obstacle. Find the number of unique paths.

*Example:* `obstacleGrid = [[0,0,0],[0,1,0],[0,0,0]]`. **Output:** `2`.

#### Implementation Overview
The logic is the same, but we must account for obstacles.
-   **Recurrence Relation:**
    -   If `grid[i][j] == 1` (is an obstacle), then `dp[i][j] = 0`.
    -   Otherwise, `dp[i][j] = dp[i-1][j] + dp[i][j-1]`.
-   **Base Cases:** `dp[0][0]` is 1 if it's not an obstacle, else 0. For the first row/column, `dp[i][0]` is 1 only if all cells from `(0,0)` to `(i,0)` are clear. The moment an obstacle is hit, all subsequent cells in that row/column become unreachable.

#### Python Code Snippet (Space Optimized)
```python
def unique_paths_with_obstacles(obstacleGrid: list[list[int]]) -> int:
    m, n = len(obstacleGrid), len(obstacleGrid[0])

    # If starting point is an obstacle, no paths are possible
    if obstacleGrid[0][0] == 1:
        return 0

    prev_row = [0] * n
    prev_row[0] = 1 # Base case for the starting cell

    for i in range(m):
        current_row = [0] * n
        for j in range(n):
            if obstacleGrid[i][j] == 1:
                current_row[j] = 0
                continue

            if i == 0 and j == 0:
                current_row[j] = 1
            elif i == 0:
                current_row[j] = current_row[j-1]
            elif j == 0:
                current_row[j] = prev_row[j]
            else:
                current_row[j] = prev_row[j] + current_row[j-1]
        prev_row = current_row

    return prev_row[n-1]
```

---

### 3. Minimum Path Sum in Grid
`[MEDIUM]` `#grid-dp` `#pathfinding` `#min-cost`

#### Problem Statement
Given a `m x n` grid filled with non-negative numbers, find a path from the top-left to the bottom-right which minimizes the sum of all numbers along its path. You can only move either down or right.

*Example:* `grid = [[1,3,1],[1,5,1],[4,2,1]]`. **Output:** `7` (Path 1->3->1->1->1).

#### Implementation Overview
-   **Recurrence Relation:** Let `dp[i][j]` be the minimum path sum to reach cell `(i, j)`.
    `dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])`.
-   **Base Cases:**
    -   `dp[0][0] = grid[0][0]`.
    -   First row: `dp[0][j] = grid[0][j] + dp[0][j-1]`.
    -   First column: `dp[i][0] = grid[i][0] + dp[i-1][0]`.
-   **Space Optimization:** This can be solved with O(n) space by only storing the previous row's results.

#### Python Code Snippet (Space Optimized)
```python
def min_path_sum(grid: list[list[int]]) -> int:
    m, n = len(grid), len(grid[0])
    prev_row = [0] * n

    for i in range(m):
        current_row = [0] * n
        for j in range(n):
            if i == 0 and j == 0:
                current_row[j] = grid[i][j]
            else:
                up = prev_row[j] if i > 0 else float('inf')
                left = current_row[j-1] if j > 0 else float('inf')
                current_row[j] = grid[i][j] + min(up, left)
        prev_row = current_row

    return prev_row[n-1]
```

---

### 4. Minimum Path Sum in Triangular Grid
`[MEDIUM]` `#grid-dp` `#pathfinding` `#triangle`

#### Problem Statement
Given a triangle array, find the minimum path sum from the top to the bottom. For each step, you may move to an adjacent number on the row below. Specifically, from index `j` on row `i`, you can move to index `j` or `j+1` on row `i+1`.

*Example:* `triangle = [[2],[3,4],[6,5,7],[4,1,8,3]]`. **Output:** `11` (Path 2->3->5->1).

#### Implementation Overview
Working bottom-up is the most intuitive approach here.
-   **Recurrence Relation (Bottom-Up):** Let `dp[i][j]` be the minimum path sum starting from cell `(i, j)` to the bottom. The recurrence would be `dp[i][j] = grid[i][j] + min(dp[i+1][j], dp[i+1][j+1])`.
-   **Base Cases (Bottom-Up):** The last row of the DP table is the same as the last row of the triangle.
-   **Space Optimization:** We only need the "next" row to compute the "current" row. We can use a 1D `dp` array of size `n` (number of rows) initialized with the last row of the triangle, and then iterate upwards, updating it in place.

#### Python Code Snippet (Space Optimized)
```python
def minimum_total_triangle(triangle: list[list[int]]) -> int:
    n = len(triangle)
    # dp array initialized with the last row of the triangle
    dp = list(triangle[n-1])

    # Iterate from the second-to-last row up to the top
    for i in range(n - 2, -1, -1):
        for j in range(i + 1):
            # Update dp[j] with the minimum path sum starting from (i, j)
            dp[j] = triangle[i][j] + min(dp[j], dp[j+1])

    # The final answer is the minimum path sum from the top element (0,0)
    return dp[0]
```
