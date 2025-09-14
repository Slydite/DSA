# Pattern 1: Subset Sum & Partition DP

This pattern is a cornerstone of Dynamic Programming, often called **0/1 Knapsack** style problems. The fundamental idea is, for each element, we have two choices: either **include it** in our subset or **not include it**. This binary choice structure forms the basis of the recurrence relation. These problems typically ask for the existence of a subset with a certain property, the count of such subsets, or the optimal partition of a set.

---

### 1. Subset Sum Equal to Target
`[MEDIUM]` `#subset-sum` `#0-1-knapsack`

#### Problem Statement
Given a set of non-negative integers `nums` and a value `k`, determine if there is a subset of the given set with a sum equal to `k`.

#### Recurrence Relation
Let `solve(index, target)` be a function that returns true if a subset summing to `target` can be formed using elements from `nums[0...index]`.
- **Choice 1 (Don't Pick):** If we don't pick `nums[index]`, we need to see if the target can be formed from the remaining elements: `solve(index - 1, target)`.
- **Choice 2 (Pick):** If we pick `nums[index]`, we need to see if `target - nums[index]` can be formed from the remaining elements: `solve(index - 1, target - nums[index])`.
- **`solve(index, target) = solve(index-1, target) OR solve(index-1, target - nums[index])`**
- **Base Case:** `target == 0` is always true. `index < 0` is false if target isn't 0.

---
#### a) Memoization (Top-Down)
```python
def subset_sum_memo(nums: list[int], k: int) -> bool:
    n = len(nums)
    dp = [[-1] * (k + 1) for _ in range(n)]

    def solve(index, target):
        if target == 0:
            return True
        if index == 0:
            return nums[0] == target
        if dp[index][target] != -1:
            return dp[index][target]

        not_pick = solve(index - 1, target)
        pick = False
        if nums[index] <= target:
            pick = solve(index - 1, target - nums[index])

        dp[index][target] = not_pick or pick
        return dp[index][target]

    return solve(n - 1, k)
```
- **Time Complexity:** O(n * k). Each state `dp[i][j]` is computed once.
- **Space Complexity:** O(n * k) for the DP table + O(n) for recursion stack.

---
#### b) Tabulation (Bottom-Up)
```python
def subset_sum_tab(nums: list[int], k: int) -> bool:
    n = len(nums)
    dp = [[False] * (k + 1) for _ in range(n)]

    # Base case: target 0 is always possible
    for i in range(n):
        dp[i][0] = True

    if nums[0] <= k:
        dp[0][nums[0]] = True

    for i in range(1, n):
        for target in range(1, k + 1):
            not_pick = dp[i-1][target]
            pick = False
            if nums[i] <= target:
                pick = dp[i-1][target - nums[i]]
            dp[i][target] = not_pick or pick

    return dp[n-1][k]
```
- **Time Complexity:** O(n * k).
- **Space Complexity:** O(n * k).

---
#### c) Space Optimization
```python
def subset_sum_optimized(nums: list[int], k: int) -> bool:
    n = len(nums)
    prev_row = [False] * (k + 1)
    prev_row[0] = True

    if nums[0] <= k:
        prev_row[nums[0]] = True

    for i in range(1, n):
        # Iterate backwards to use the results from the 'previous' row (i-1)
        # before they are overwritten in this pass.
        for target in range(k, nums[i] - 1, -1):
            not_pick = prev_row[target]
            pick = prev_row[target - nums[i]]
            prev_row[target] = not_pick or pick

    return prev_row[k]
```
- **Time Complexity:** O(n * k).
- **Space Complexity:** O(k).

---

### 2. Partition Equal Subset Sum
`[MEDIUM]` `#subset-sum` `#partition`

#### Problem Statement
Given an array `nums`, find if it can be partitioned into two subsets with equal sums.

#### Implementation Overview
This is a direct application of Subset Sum. If the array can be partitioned into two equal sum subsets, the sum of each subset must be `total_sum / 2`.
1.  Calculate `total_sum`. If it's odd, return `False`.
2.  The problem becomes: find if there is a subset with sum equal to `target = total_sum / 2`.
3.  Use any of the Subset Sum solutions above.

#### Python Code Snippet (using optimized Subset Sum)
```python
def can_partition(nums: list[int]) -> bool:
    total_sum = sum(nums)
    if total_sum % 2 != 0:
        return False

    return subset_sum_optimized(nums, total_sum // 2)
```
- **Time Complexity:** O(n * total_sum).
- **Space Complexity:** O(total_sum).

---

### 3. Count Partitions with Given Difference
`[MEDIUM]` `#subset-sum` `#partition` `#count`

#### Problem Statement
Given an array and a difference `diff`, count the ways to partition it into two subsets `S1` and `S2` such that `sum(S1) - sum(S2) = diff`.

#### Implementation Overview
This problem reduces to **Count Subsets with Sum K**.
1.  We have two equations:
    - `sum(S1) - sum(S2) = diff`
    - `sum(S1) + sum(S2) = totalSum`
2.  Adding them gives `2 * sum(S1) = totalSum + diff`, so `sum(S1) = (totalSum + diff) / 2`.
3.  The problem is now to count the number of subsets that sum to this `target = (totalSum + diff) / 2`.
4.  This requires a counting version of the subset sum DP. Let `dp[j]` be the number of ways to make sum `j`. The recurrence is `dp[j] = dp[j] + dp[j - num]`.

#### Python Code Snippet
```python
def count_partitions_with_diff(nums: list[int], diff: int) -> int:
    total_sum = sum(nums)

    # Edge cases: if target is not an integer or is negative
    if (total_sum + diff) % 2 != 0 or (total_sum + diff) < 0:
        return 0

    target = (total_sum + diff) // 2

    # Count subsets with sum = target
    dp = [0] * (target + 1)
    dp[0] = 1 # Base case: one way to make sum 0 (empty set)
    for num in nums:
        for j in range(target, num - 1, -1):
            dp[j] += dp[j - num]

    return dp[target]
```
- **Time Complexity:** O(n * target).
- **Space Complexity:** O(target).
- **Related Problem:** The **Target Sum** problem is an identical variation.
