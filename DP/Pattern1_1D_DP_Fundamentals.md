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

*Example:* `n = 3`. **Output:** `3` (Ways: 1+1+1, 1+2, 2+1)

#### Implementation Overview
This is a classic DP problem that is identical to the Fibonacci sequence.
-   **Recurrence Relation:** Let `dp[i]` be the number of ways to reach step `i`. To reach step `i`, you could have come from step `i-1` (by taking one step) or from step `i-2` (by taking two steps). Therefore, `dp[i] = dp[i-1] + dp[i-2]`.
-   **Base Cases:** `dp[0] = 1`, `dp[1] = 1`.
-   **Space Optimization:** Since `dp[i]` only depends on the two previous values, we can optimize space from O(n) to O(1) by only storing the last two values (`prev1`, `prev2`).

#### Python Code Snippet (Space Optimized)
```python
def climb_stairs(n: int) -> int:
    if n <= 1:
        return 1

    prev2 = 1 # ways to reach step 0
    prev1 = 1 # ways to reach step 1

    for i in range(2, n + 1):
        current = prev1 + prev2
        prev2 = prev1
        prev1 = current

    return prev1
```

---

### 3. Frog Jump
`[EASY]` `#1D-DP`

#### Problem Statement
A frog is trying to get from the 1st to the Nth stone. The heights of the stones are given in an array. The frog can jump from stone `i` to `i+1` or `i+2`. The energy cost of a jump is the absolute difference in height between the stones. Find the minimum total energy required to reach the Nth stone.

*Example:* `heights = [10, 20, 30, 10]`. **Output:** `20` (10->30->10, cost = |30-10| + |10-30| = 20 + 20 = 40. Path 10->20->10 has cost |20-10|+|10-20|=10+10=20)

#### Implementation Overview
-   **Recurrence Relation:** Let `dp[i]` be the minimum energy to reach stone `i`. To reach stone `i`, the frog must have jumped from `i-1` or `i-2`.
    -   Cost from `i-1`: `dp[i-1] + abs(height[i] - height[i-1])`
    -   Cost from `i-2`: `dp[i-2] + abs(height[i] - height[i-2])`
    So, `dp[i] = min(cost_from_i-1, cost_from_i-2)`.
-   **Base Case:** `dp[0] = 0`.
-   **Space Optimization:** This can be space-optimized to O(1).

#### Python Code Snippet (Space Optimized)
```python
def frog_jump(heights: list[int]) -> int:
    n = len(heights)
    if n <= 1:
        return 0

    prev2 = 0 # min energy to reach stone 0
    prev1 = abs(heights[1] - heights[0]) # min energy to reach stone 1

    for i in range(2, n):
        jump1 = prev1 + abs(heights[i] - heights[i-1])
        jump2 = prev2 + abs(heights[i] - heights[i-2])
        current = min(jump1, jump2)
        prev2 = prev1
        prev1 = current

    return prev1
```

---

### 4. Frog Jump with K Distances
`[MEDIUM]` `#1D-DP`

#### Problem Statement
This is a generalization of the previous problem. The frog can now jump from stone `i` to any stone `i+j` where `1 <= j <= k`. Find the minimum energy to reach the Nth stone.

#### Implementation Overview
-   **Recurrence Relation:** `dp[i] = min(dp[i-j] + abs(height[i] - height[i-j]))` for `j` from 1 to `k`.
-   **Tabulation:** This requires a nested loop. The outer loop iterates `i` from 1 to `n-1`, and the inner loop iterates `j` from 1 to `k` to check all possible previous stones. The time complexity is O(N*K).

#### Python Code Snippet (Tabulation)
```python
def frog_jump_k(heights: list[int], k: int) -> int:
    n = len(heights)
    dp = [float('inf')] * n
    dp[0] = 0

    for i in range(1, n):
        for j in range(1, k + 1):
            if i - j >= 0:
                jump_cost = dp[i-j] + abs(heights[i] - heights[i-j])
                dp[i] = min(dp[i], jump_cost)

    return dp[n-1]
```

---

### 5. House Robber
`[MEDIUM]` `#1D-DP`

#### Problem Statement
Given an array of positive integers `nums` representing the money in each house, find the maximum amount of money you can rob without alerting the police. The constraint is that you cannot rob two adjacent houses.

*Example:* `nums = [2, 7, 9, 3, 1]`. **Output:** `12` (Rob houses with 2, 9, and 1).

#### Implementation Overview
-   **Recurrence Relation:** Let `dp[i]` be the maximum money robbed considering houses up to index `i`. At index `i`, we have two choices:
    1.  **Rob `nums[i]`:** The sum is `nums[i] + dp[i-2]` (since we can't rob house `i-1`).
    2.  **Skip `nums[i]`:** The sum is `dp[i-1]`.
    Therefore, `dp[i] = max(nums[i] + dp[i-2], dp[i-1])`.
-   **Space Optimization:** This can be space-optimized to O(1).

#### Python Code Snippet (Space Optimized)
```python
def house_robber(nums: list[int]) -> int:
    if not nums: return 0
    if len(nums) == 1: return nums[0]

    prev2 = 0 # max money robbing up to i-2
    prev1 = 0 # max money robbing up to i-1

    for num in nums:
        # dp[i] = max(dp[i-1], num + dp[i-2])
        current = max(prev1, num + prev2)
        prev2 = prev1
        prev1 = current

    return prev1
```

---

### 6. House Robber II
`[MEDIUM]` `#1D-DP` `#circular`

#### Problem Statement
This is a variation of the previous problem where the houses are arranged in a circle. This means the first and the last houses are now considered adjacent.

*Example:* `nums = [2, 3, 2]`. **Output:** `3` (Cannot rob house 1 and 3, so either rob 2 or 3).

#### Implementation Overview
The circular arrangement means if we rob the first house, we cannot rob the last one, and vice-versa. This constraint can be handled by breaking the problem into two separate, non-circular subproblems:
1.  **Rob houses from 0 to n-2:** Solve the standard House Robber problem on the subarray that excludes the last house.
2.  **Rob houses from 1 to n-1:** Solve the standard House Robber problem on the subarray that excludes the first house.

The final answer is the maximum of the results from these two subproblems.

#### Python Code Snippet
```python
def house_robber_ii(nums: list[int]) -> int:
    if not nums: return 0
    if len(nums) == 1: return nums[0]

    def rob_linear(sub_nums):
        prev2, prev1 = 0, 0
        for num in sub_nums:
            current = max(prev1, num + prev2)
            prev2 = prev1
            prev1 = current
        return prev1

    # Max of robbing houses 0 to n-2 OR houses 1 to n-1
    return max(rob_linear(nums[:-1]), rob_linear(nums[1:]))
```
