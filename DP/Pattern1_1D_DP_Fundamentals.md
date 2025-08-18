# Pattern 1: 1D DP Fundamentals

This pattern introduces the core concepts of Dynamic Programming (DP) and applies them to problems that can be solved using a one-dimensional DP array. These problems are foundational for understanding how to identify DP patterns and formulate recurrence relations. The main ideas covered are memoization, tabulation, and space optimization.

---

### 1. Dynamic Programming Introduction
`[FUNDAMENTAL]` `[EASY]` `#concept` `#memoization` `#tabulation`

#### Concept Overview
**Dynamic Programming** is an algorithmic technique for solving optimization problems by breaking them down into simpler subproblems and utilizing the fact that the optimal solution to the overall problem depends upon the optimal solution to its subproblems.

DP is applicable when a problem has two key attributes:
1.  **Optimal Substructure:** An optimal solution to the problem can be constructed from optimal solutions to its subproblems.
2.  **Overlapping Subproblems:** The problem can be broken down into subproblems that are reused several times. DP solves each subproblem only once and stores the result for future use.

**Two Main DP Techniques:**
1.  **Memoization (Top-Down):** This approach involves writing a standard recursive function and storing the results of each subproblem in a cache (e.g., a hash map or an array, often called `dp`). Before computing a subproblem, the function checks if the result is already in the cache. If so, it returns the cached value; otherwise, it computes the result, stores it, and then returns it.
2.  **Tabulation (Bottom-Up):** This approach involves solving the problem "bottom-up" by filling a DP table. It starts by solving the smallest possible subproblems and iteratively builds up to the solution for the original problem. This is typically done with a loop and avoids deep recursion.

---

### 2. Climbing Stairs
`[EASY]` `#1D-DP` `#fibonacci`

#### Problem Statement
You are climbing a staircase. It takes `n` steps to reach the top. Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

#### Implementation Overview
This is a classic DP problem that is identical to the Fibonacci sequence.
-   **Recurrence Relation:** Let `dp[i]` be the number of ways to reach step `i`. To reach step `i`, you could have come from step `i-1` (by taking one step) or from step `i-2` (by taking two steps). Therefore, `dp[i] = dp[i-1] + dp[i-2]`.
-   **Base Cases:** `dp[0] = 1`, `dp[1] = 1`.
-   **Tabulation:** Create a DP array of size `n+1` and fill it from `i=2` to `n`.
-   **Space Optimization:** Since `dp[i]` only depends on the two previous values, we can optimize space from O(n) to O(1) by only storing the last two values (`prev1`, `prev2`).

---

### 3. Frog Jump (DP-3)
`[EASY]` `#1D-DP`

#### Problem Statement
A frog is trying to get from the 1st to the Nth stone. The heights of the stones are given in an array. The frog can jump from stone `i` to `i+1` or `i+2`. The energy cost of a jump is the absolute difference in height between the stones. Find the minimum total energy required to reach the Nth stone.

#### Implementation Overview
-   **Recurrence Relation:** Let `dp[i]` be the minimum energy to reach stone `i`. To reach stone `i`, the frog must have jumped from `i-1` or `i-2`.
    -   Cost from `i-1`: `dp[i-1] + abs(height[i] - height[i-1])`
    -   Cost from `i-2`: `dp[i-2] + abs(height[i] - height[i-2])`
    So, `dp[i] = min(cost_from_i-1, cost_from_i-2)`.
-   **Base Case:** `dp[0] = 0`.
-   **Tabulation:** Fill a DP array of size `n` from `i=1` to `n-1`.
-   **Space Optimization:** Similar to Climbing Stairs, this can be space-optimized to O(1).

---

### 4. Frog Jump with k distances (DP-4)
`[MEDIUM]` `#1D-DP`

#### Problem Statement
This is a generalization of the previous problem. The frog can now jump from stone `i` to any stone `i+j` where `1 <= j <= k`. Find the minimum energy to reach the Nth stone.

#### Implementation Overview
-   **Recurrence Relation:** The recurrence is now more general. `dp[i]` is the minimum energy to reach stone `i`. To get here, the frog could have jumped from any of the `k` previous stones.
    `dp[i] = min(dp[i-j] + abs(height[i] - height[i-j]))` for `j` from 1 to `k`.
-   **Base Case:** `dp[0] = 0`.
-   **Tabulation:** This requires a nested loop. The outer loop iterates `i` from 1 to `n-1`, and the inner loop iterates `j` from 1 to `k` to check all possible previous stones. The time complexity is O(N*K).
-   **Space Optimization:** Space can be optimized to O(K) as we only need the last `k` DP states to compute the next one.

---

### 5. Maximum sum of non-adjacent elements (DP 5)
`[MEDIUM]` `#1D-DP` `#house-robber`

#### Problem Statement
Given an array of positive integers, find the maximum sum of a subsequence with the constraint that no two numbers in the subsequence should be adjacent in the array.

#### Implementation Overview
This is the canonical "House Robber" problem.
-   **Recurrence Relation:** Let `dp[i]` be the maximum sum considering elements up to index `i`. At index `i`, we have two choices:
    1.  **Take `nums[i]`:** If we take the current element, we cannot take the previous one (`i-1`). So the sum would be `nums[i] + dp[i-2]`.
    2.  **Skip `nums[i]`:** If we skip the current element, the maximum sum is simply the maximum sum up to the previous element, which is `dp[i-1]`.
    Therefore, `dp[i] = max(nums[i] + dp[i-2], dp[i-1])`.
-   **Base Cases:** `dp[0] = nums[0]`. `dp[1] = max(nums[0], nums[1])`.
-   **Space Optimization:** This can be space-optimized to O(1) by only storing the previous two results.

---

### 6. House Robber (DP 6)
`[MEDIUM]` `#1D-DP` `#house-robber` `#circular`

#### Problem Statement
This is a variation of the previous problem where the houses are arranged in a circle. This means the first and the last houses are now considered adjacent.

#### Implementation Overview
The circular arrangement means if we rob the first house, we cannot rob the last one, and vice-versa. This constraint can be handled by breaking the problem into two separate subproblems:
1.  **Rob houses from 0 to n-2:** Solve the standard House Robber problem on the subarray that excludes the last house.
2.  **Rob houses from 1 to n-1:** Solve the standard House Robber problem on the subarray that excludes the first house.

The final answer is the maximum of the results from these two subproblems. This elegantly handles the circular dependency. Each subproblem can be solved in O(N) time and O(1) space, so the total complexity remains the same.

#### Tricks/Gotchas
-   A common edge case is an array with only one element. In this case, the answer is just that element, and the slicing logic must handle this gracefully.
