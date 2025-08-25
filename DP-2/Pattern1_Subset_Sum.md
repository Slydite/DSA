# Pattern 1: Subset Sum & Partition DP

This pattern is a cornerstone of Dynamic Programming, often compared to the 0/1 Knapsack problem. The fundamental idea is, for each element, we have two choices: either include it in our subset or not. This binary choice structure forms the basis of the recurrence relation. These problems typically ask for the existence of a subset with a certain property, the count of such subsets, or the optimal partition of a set.

---

### 1. Subset Sum Equal to Target
`[MEDIUM]` `#subset-sum` `#0-1-knapsack`

#### Problem Statement
Given a set of non-negative integers `nums` and a value `k`, determine if there is a subset of the given set with a sum equal to `k`.

*Example:* `nums = [1, 2, 3]`, `k = 5`. **Output:** `true` (Subset {2, 3})

#### Implementation Overview
-   **DP State:** `dp[i][j]` is a boolean value indicating whether a sum of `j` can be achieved using elements from the first `i` items.
-   **Recurrence Relation:** For each item `nums[i-1]`, we have two choices:
    1.  **Exclude `nums[i-1]`**: The result is the same as without this item: `dp[i-1][j]`.
    2.  **Include `nums[i-1]`**: This is possible only if `j >= nums[i-1]`. The result is `dp[i-1][j - nums[i-1]]`.
    Combining these, `dp[i][j] = dp[i-1][j] or dp[i-1][j - nums[i-1]]`.
-   **Space Optimization:** A 2D DP table of `(n+1) x (k+1)` can be optimized to a 1D DP array of size `(k+1)`.

#### Python Code Snippet (Space Optimized)
```python
def subset_sum_to_k(nums: list[int], k: int) -> bool:
    n = len(nums)
    # dp[j] will be true if sum j is possible
    dp = [False] * (k + 1)
    dp[0] = True # Base case: sum 0 is always possible with an empty set

    for num in nums:
        # Iterate backwards to prevent using the same element multiple times in one subset
        for j in range(k, num - 1, -1):
            dp[j] = dp[j] or dp[j - num]

    return dp[k]
```

---

### 2. Partition Equal Subset Sum
`[MEDIUM]` `#subset-sum` `#partition`

#### Problem Statement
Given a non-empty array `nums` containing only positive integers, find if the array can be partitioned into two subsets such that the sum of elements in both subsets is equal.

*Example:* `nums = [1, 5, 11, 5]`. **Output:** `true` (Subsets {1, 5, 5} and {11})

#### Implementation Overview
This is a direct application of the Subset Sum problem.
1.  Calculate the total sum of the array, `totalSum`.
2.  If `totalSum` is odd, it's impossible to partition it into two equal integer halves, so return `false`.
3.  If `totalSum` is even, the problem reduces to finding if there is a subset with a sum equal to `target = totalSum / 2`.
4.  Solve the "Subset Sum Equal to Target" problem with this `target`.

#### Python Code Snippet
```python
def can_partition(nums: list[int]) -> bool:
    total_sum = sum(nums)
    if total_sum % 2 != 0:
        return False

    target = total_sum // 2

    # Now this is the subset sum problem
    dp = [False] * (target + 1)
    dp[0] = True

    for num in nums:
        for j in range(target, num - 1, -1):
            dp[j] = dp[j] or dp[j - num]

    return dp[target]
```

---

### 3. Partition a Set Into Two Subsets With Minimum Absolute Sum Difference
`[MEDIUM]` `#subset-sum` `#partition` `#optimization`

#### Problem Statement
Given an array of integers, partition it into two subsets, `S1` and `S2`, such that the absolute difference between their sums is minimized.

*Example:* `arr = [1, 6, 11, 5]`. **Output:** `1` (S1={1,5,6}, S2={11}. Sums are 12, 11. Diff is 1).

#### Implementation Overview
Let `totalSum` be the total sum. We want to minimize `abs(sum(S1) - sum(S2))`.
Since `sum(S2) = totalSum - sum(S1)`, we want to minimize `abs(sum(S1) - (totalSum - sum(S1)))` which is `abs(2*sum(S1) - totalSum)`.
This means we need to find a possible subset sum `s1` that is as close to `totalSum / 2` as possible.
1.  First, find all possible subset sums up to `totalSum` using the subset sum DP approach.
2.  The `dp` array will tell us which sums are possible.
3.  Iterate from `totalSum / 2` down to `0`. The first `s1` for which `dp[s1]` is `true` is the best possible sum for the first subset.
4.  The minimum difference is `totalSum - 2 * s1`.

#### Python Code Snippet
```python
def min_subset_sum_difference(arr: list[int]) -> int:
    total_sum = sum(arr)
    k = total_sum

    # Find all possible subset sums
    dp = [False] * (k + 1)
    dp[0] = True
    for num in arr:
        for j in range(k, num - 1, -1):
            dp[j] = dp[j] or dp[j - num]

    min_diff = float('inf')
    for s1 in range(total_sum // 2, -1, -1):
        if dp[s1]:
            s2 = total_sum - s1
            min_diff = s2 - s1 # s2 will be >= s1
            break

    return min_diff
```

---

### 4. Count Subsets with Sum K
`[MEDIUM]` `#subset-sum` `#count`

#### Problem Statement
Given an array of integers and a sum `k`, find the number of subsets of the given array with a sum equal to `k`.

*Example:* `nums = [1, 2, 3, 3]`, `k = 6`. **Output:** `3` ({1,2,3}, {1,2,3}, {3,3})

#### Implementation Overview
This is similar to the boolean Subset Sum, but `dp[j]` stores the *count* of subsets that sum to `j`.
-   **Recurrence Relation:** `dp[j] = dp[j] (subsets without current num) + dp[j - num] (subsets with current num)`.
-   **Base Case:** `dp[0] = 1` (the empty set is one way to make sum 0).

#### Python Code Snippet
```python
def count_subsets_with_sum(nums: list[int], k: int) -> int:
    dp = [0] * (k + 1)
    dp[0] = 1

    for num in nums:
        for j in range(k, num - 1, -1):
            dp[j] += dp[j - num]

    return dp[k]
```

---

### 5. Count Partitions with Given Difference
`[MEDIUM]` `#subset-sum` `#partition` `#count`

#### Problem Statement
Given an array and a difference `diff`, count the number of ways to partition the array into two subsets `S1` and `S2` such that `sum(S1) - sum(S2) = diff`.

*Example:* `nums = [1,1,2,3]`, `diff = 1`. **Output:** `3` ({1,3} & {1,2}, {1,3} & {1,2}, {1,1,2} & {3})

#### Implementation Overview
This problem can be mathematically reduced to "Count Subsets with Sum K".
1.  We are given `s1 - s2 = diff`. We also know `s1 + s2 = totalSum`.
2.  Adding the two equations: `2*s1 = totalSum + diff`, which means `s1 = (totalSum + diff) / 2`.
3.  The problem is now to find the number of subsets that sum up to `s1`.
4.  **Edge cases:** If `totalSum + diff` is odd or negative, no solution is possible.

#### Python Code Snippet
```python
def count_partitions_with_diff(nums: list[int], diff: int) -> int:
    total_sum = sum(nums)

    # Check edge cases
    if (total_sum + diff) % 2 != 0 or total_sum < diff:
        return 0

    target = (total_sum + diff) // 2

    # Now it's the "Count Subsets with Sum K" problem
    dp = [0] * (target + 1)
    dp[0] = 1
    for num in nums:
        for j in range(target, num - 1, -1):
            dp[j] += dp[j - num]

    return dp[target]
```

---

### 6. Target Sum
`[MEDIUM]` `#subset-sum` `#count`

#### Problem Statement
You are given a list of non-negative integers, `nums`, and a target, `S`. You have 2 symbols `+` and `-`. For each integer, you should choose one from `+` and `-` as its new symbol. Find out how many ways to assign symbols to make the sum of integers equal to the target `S`.

*Example:* `nums = [1,1,1,1,1]`, `S = 3`. **Output:** `5`

#### Implementation Overview
This is another variation that reduces to "Count Subsets with Sum K".
1.  Let the set of numbers with a `+` sign be `P` and the set with a `-` sign be `N`.
2.  We want `sum(P) - sum(N) = S`. We know `sum(P) + sum(N) = totalSum`.
3.  Adding the two equations gives `2*sum(P) = totalSum + S`.
4.  So, `sum(P) = (totalSum + S) / 2`.
5.  The problem is now to find the number of subsets `P` that sum to this target value.

#### Python Code Snippet
```python
def find_target_sum_ways(nums: list[int], S: int) -> int:
    total_sum = sum(nums)

    # Same logic as "Count Partitions with Given Difference"
    if abs(S) > total_sum or (total_sum + S) % 2 != 0:
        return 0

    target = (total_sum + S) // 2

    dp = [0] * (target + 1)
    dp[0] = 1
    for num in nums:
        for j in range(target, num - 1, -1):
            dp[j] += dp[j - num]

    return dp[target]
```
