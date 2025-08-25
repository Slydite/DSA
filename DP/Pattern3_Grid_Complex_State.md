# Pattern 3: DP on Grids - Complex State & Choices

This pattern covers more advanced grid-based DP problems. The complexity arises from variations in movement, state representation, or objectives. These problems often require a more nuanced DP state than just `(row, col)` or involve pathing with flexible start/end points.

---

### 1. Ninja's Training
`[MEDIUM]` `#grid-dp` `#complex-state`

#### Problem Statement
A ninja has to train for `N` days. For each day, he can choose one of three activities and earn merit points for it. He cannot perform the same activity on two consecutive days. Given the points for each activity on each day, find the maximum merit points the ninja can earn.

*Example:* `points = [[10, 40, 70], [20, 50, 80], [30, 60, 90]]`. **Output:** `210` (70 + 80 + 60)

#### Implementation Overview
The state must not only include the day but also the activity performed on that day to enforce the "no consecutive same activity" rule.
-   **DP State:** `dp[day][last_activity]` = Maximum points earned up to `day`, ending with `last_activity`.
-   **Recurrence Relation:** To calculate `dp[day][current_act]`, the ninja must have come from `day-1` having done a *different* activity.
    `dp[day][act] = points[day][act] + max(dp[day-1][other_act])` for all `other_act != act`.
-   **Base Cases:** For day 0, `dp[0][act] = points[0][act]`.
-   **Space Optimization:** Can be optimized to O(1) space since each day only depends on the previous day's results.

#### Python Code Snippet (Space Optimized)
```python
def ninja_training(n: int, points: list[list[int]]) -> int:
    # dp[j] will store the max points on the previous day ending with activity j
    dp = [0] * 4 # Using 4 to make indexing 0,1,2 easier

    # Base case for day 0
    dp[0] = max(points[0][1], points[0][2])
    dp[1] = max(points[0][0], points[0][2])
    dp[2] = max(points[0][0], points[0][1])
    dp[3] = max(points[0][0], points[0][1], points[0][2]) # Not really used, but for completeness

    if n == 1:
        return dp[3]

    for day in range(1, n):
        temp = [0] * 4
        for last in range(4):
            max_points = 0
            for task in range(3):
                if task != last:
                    activity_points = points[day][task] + dp[task]
                    max_points = max(max_points, activity_points)
            temp[last] = max_points
        dp = temp

    return dp[3] # Max points on the last day, assuming any previous activity
```

---

### 2. Minimum/Maximum Falling Path Sum
`[MEDIUM]` `#grid-dp` `#flexible-path`

#### Problem Statement
Given a `n x n` square grid, find the minimum (or maximum) sum of a "falling path". A falling path starts at any element in the first row and chooses one element from each row. From a cell `(row, col)`, it can move to `(row + 1, col - 1)`, `(row + 1, col)`, or `(row + 1, col + 1)`.

*Example:* `matrix = [[2,1,3],[6,5,4],[7,8,9]]`. **Output (min sum):** `13` (Path 1->4->8).

#### Implementation Overview
This problem is best solved using a bottom-up approach, where `dp[i][j]` stores the min/max path sum ending at cell `(i, j)`.
-   **Recurrence Relation:** The value at `dp[i][j]` is `grid[i][j] + min(dp[i-1][j-1], dp[i-1][j], dp[i-1][j+1])`.
-   **Base Cases:** The first row of the DP table is the same as the first row of the grid.
-   **Final Answer:** The answer is the minimum or maximum value in the *last row* of the `dp` table.
-   **Space Optimization:** Can be optimized to O(N) space by only storing the previous row's DP values.

#### Python Code Snippet (Space Optimized Min Sum)
```python
def min_falling_path_sum(matrix: list[list[int]]) -> int:
    n = len(matrix)
    prev_row = list(matrix[0]) # Start with the first row

    for i in range(1, n):
        current_row = [0] * n
        for j in range(n):
            # Get values from previous row, handle boundaries
            up = prev_row[j]
            up_left = prev_row[j-1] if j > 0 else float('inf')
            up_right = prev_row[j+1] if j < n - 1 else float('inf')

            current_row[j] = matrix[i][j] + min(up, up_left, up_right)
        prev_row = current_row

    return min(prev_row)
```

---

### 3. Cherry Pickup II (3D DP)
`[HARD]` `#3d-dp` `#grid-dp` `#dual-path`

#### Problem Statement
You are given a `rows x cols` grid representing a field of cherries where `grid[i][j]` is the number of cherries in that cell. Two robots, Robot 1 starting at `(0, 0)` and Robot 2 starting at `(0, cols-1)`, must both reach the last row. From a cell `(row, col)`, a robot can move to `(row + 1, col - 1)`, `(row + 1, col)`, or `(row + 1, col + 1)`. If both robots land on the same cell, they only collect the cherries once. Find the maximum number of cherries they can collect together.

#### Implementation Overview
Since both robots move down one row at a time, their `row` index is always the same. This is the key to the state.
-   **DP State:** `dp[i][j1][j2]` = maximum cherries collected at row `i`, with Robot 1 at column `j1` and Robot 2 at column `j2`.
-   **Recurrence Relation (Bottom-Up):** We build the solution from the last row up to the first.
    - `dp[i][j1][j2]` is calculated based on the max value achievable from `dp[i+1]`.
    - From `(i, j1)` and `(i, j2)`, the robots can move to 9 possible next states `(i+1, next_j1, next_j2)`.
    - `dp[i][j1][j2] = current_cherries + max(dp[i+1][next_j1][next_j2])` over all 9 next states.
-   **Space Optimization:** A full `R * C * C` table is large. Since row `i` only depends on `i+1`, space can be optimized to `O(C*C)` by using a `front` and `current` DP table.

#### Python Code Snippet (Space Optimized Tabulation)
```python
def cherry_pickup_ii(grid: list[list[int]]) -> int:
    rows, cols = len(grid), len(grid[0])

    # DP table for the next row
    front = [[0] * cols for _ in range(cols)]

    # Base case: last row
    for j1 in range(cols):
        for j2 in range(cols):
            if j1 == j2:
                front[j1][j2] = grid[rows-1][j1]
            else:
                front[j1][j2] = grid[rows-1][j1] + grid[rows-1][j2]

    # Iterate from second-to-last row up to the top
    for i in range(rows - 2, -1, -1):
        curr = [[0] * cols for _ in range(cols)]
        for j1 in range(cols):
            for j2 in range(cols):
                max_future = 0
                # Explore all 9 possible moves
                for dj1 in [-1, 0, 1]:
                    for dj2 in [-1, 0, 1]:
                        next_j1, next_j2 = j1 + dj1, j2 + dj2
                        if 0 <= next_j1 < cols and 0 <= next_j2 < cols:
                            max_future = max(max_future, front[next_j1][next_j2])

                cherries = grid[i][j1]
                if j1 != j2:
                    cherries += grid[i][j2]

                curr[j1][j2] = cherries + max_future
        front = curr

    return front[0][cols-1]
```
