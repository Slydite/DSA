# Pattern 3: DP on Grids - Complex State & Choices

This pattern covers more advanced grid-based DP problems. The complexity arises from variations in movement, state representation, or objectives. These problems often require a more nuanced DP state than just `(row, col)` or involve pathing with flexible start/end points.

---

### 1. Ninja's Training (DP 7)
`[MEDIUM]` `#grid-dp` `#complex-state`

#### Problem Statement
A ninja has to train for `N` days. For each day, he can choose one of three activities and earn merit points for it. He cannot perform the same activity on two consecutive days. Given the points for each activity on each day, find the maximum merit points the ninja can earn.

#### Implementation Overview
The state must not only include the day but also the activity performed on that day to enforce the "no consecutive same activity" rule.
-   **DP State:** `dp[day][last_activity]` = Maximum points earned up to `day`, ending with `last_activity`.
-   **Recurrence Relation:** To calculate `dp[day][current_activity]`, the ninja must have come from `day-1` having done a *different* activity.
    `dp[day][act] = points[day][act] + max(dp[day-1][other_act])` for all `other_act != act`.
-   **Base Cases:** For day 0, `dp[0][act] = points[0][act]`.
-   **Tabulation:** Create a `N x 4` DP table (3 activities + 1 for 'none'). Iterate from day 1 to N-1. For each day, iterate through the three possible activities. For each activity, calculate the max points by looking at the results from the previous day where a different activity was chosen. The final answer is the maximum value in the last row of the `dp` table.
-   **Space Optimization:** Can be optimized to O(1) space since each day only depends on the previous day.

---

### 2. Minimum/Maximum Falling Path Sum (DP-12)
`[MEDIUM]` `#grid-dp` `#flexible-path`

#### Problem Statement
Given a `n x n` square grid, find the minimum (or maximum) sum of a "falling path". A falling path starts at any element in the first row and chooses one element from each row. From a cell `(row, col)`, it can move to `(row + 1, col - 1)`, `(row + 1, col)`, or `(row + 1, col + 1)`.

#### Implementation Overview
This problem is best solved using a bottom-up approach, where `dp[i][j]` stores the min/max path sum ending at cell `(i, j)`.
-   **Recurrence Relation:** The value at `dp[i][j]` is the grid's value at `(i, j)` plus the minimum/maximum of the three cells in the row above that can reach it.
    `dp[i][j] = grid[i][j] + min(dp[i-1][j-1], dp[i-1][j], dp[i-1][j+1])`.
-   **Base Cases:** The first row of the DP table is the same as the first row of the grid: `dp[0][j] = grid[0][j]`.
-   **Tabulation:** Iterate from the second row (`i=1`) to the end. For each cell `(i, j)`, apply the recurrence. Be careful with boundary conditions (when `j=0` or `j=n-1`).
-   **Final Answer:** The answer is the minimum or maximum value in the *last row* of the `dp` table, as the path can end at any cell in that row.
-   **Space Optimization:** Can be optimized to O(N) space by only storing the previous row's DP values.

---

### 3. 3-D DP: Ninja and his friends (DP-13)
`[HARD]` `#3d-dp` `#grid-dp` `#dual-path`

#### Problem Statement
You are given a `R x C` grid where each cell has some number of chocolates. Two friends, Alice and Bob, are collecting chocolates. Alice starts at `(0, 0)` and Bob starts at `(0, C-1)`. They both must move from row `i` to `i+1`. From `(i, j)`, they can move to `(i+1, j-1)`, `(i+1, j)`, or `(i+1, j+1)`. If they land on the same cell, they only collect the chocolates once. Find the maximum number of chocolates they can collect together by the time they reach the last row.

#### Implementation Overview
Since both friends move down one row at a time, their `row` index is always the same. This is the key insight to reduce the state space.
-   **DP State:** We need to know the row and the column of both friends. So, a 3D DP state is required: `dp[i][j1][j2]`, representing the maximum chocolates collected at row `i`, with Alice at column `j1` and Bob at column `j2`.
-   **Recurrence Relation (Top-Down/Memoization):**
    A recursive function `solve(i, j1, j2)` would be:
    1.  **Base Case:** If `i == R-1` (last row), return the chocolates at `grid[i][j1]` and `grid[i][j2]` (making sure not to double-count if `j1 == j2`).
    2.  **Recursive Step:**
        -   Calculate current chocolates: `grid[i][j1] + (j1 != j2) * grid[i][j2]`.
        -   Explore all 9 possible next states (3 moves for Alice, 3 for Bob).
        -   `max_future_chocolates = max(solve(i+1, next_j1, next_j2))` over all 9 combinations.
        -   Return `current_chocolates + max_future_chocolates`.
-   **Tabulation (Bottom-Up):** This is complex but possible. Iterate `i` from `R-2` up to `0`. For each `i`, iterate through all possible pairs of `(j1, j2)` and compute `dp[i][j1][j2]` based on the values in `dp[i+1]`.
-   **Space Optimization:** A full 3D table `R * C * C` can be large. Since row `i` only depends on `i+1`, space can be optimized to `O(C*C)` by using only two layers of the DP table at a time.
