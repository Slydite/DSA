# Pattern 1: Subset Sum & Partition DP

This pattern is a cornerstone of Dynamic Programming, often compared to the 0/1 Knapsack problem. The fundamental idea is, for each element, we have two choices: either include it in our subset or not. This binary choice structure forms the basis of the recurrence relation. These problems typically ask for the existence of a subset with a certain property, the count of such subsets, or the optimal partition of a set.

---

### 1. Subset Sum Equal to Target (DP-14)
`[MEDIUM]` `#subset-sum` `#0-1-knapsack`

#### Problem Statement
Given a set of non-negative integers and a value `sum`, determine if there is a subset of the given set with a sum equal to the given `sum`.

#### Implementation Overview
-   **DP State:** `dp[i][j]` is a boolean value indicating whether a sum of `j` can be achieved using elements from the first `i` items.
-   **Recurrence Relation:** For each item `nums[i-1]`, we have two choices:
    1.  **Exclude `nums[i-1]`**: The result is the same as without this item: `dp[i-1][j]`.
    2.  **Include `nums[i-1]`**: This is possible only if `j >= nums[i-1]`. The result is `dp[i-1][j - nums[i-1]]`.
    Combining these, `dp[i][j] = dp[i-1][j] || dp[i-1][j - nums[i-1]]`.
-   **Base Cases:** `dp[0][0] = true` (an empty set can form a sum of 0). `dp[i][0] = true` for all `i`.
-   **Space Optimization:** A 2D DP table of `(n+1) x (sum+1)` can be optimized to a 1D DP array of size `(sum+1)`.

---

### 2. Partition Equal Subset Sum (DP-15)
`[MEDIUM]` `#subset-sum` `#partition`

#### Problem Statement
Given a non-empty array containing only positive integers, find if the array can be partitioned into two subsets such that the sum of elements in both subsets is equal.

#### Implementation Overview
This is a direct application of the Subset Sum problem.
1.  Calculate the total sum of the array, `totalSum`.
2.  If `totalSum` is odd, it's impossible to partition it into two equal halves, so return `false`.
3.  If `totalSum` is even, the problem reduces to finding if there is a subset with a sum equal to `target = totalSum / 2`.
4.  Solve the "Subset Sum Equal to Target" problem with this `target`.

---

### 3. Partition a Set Into Two Subsets With Minimum Absolute Sum Difference (DP-16)
`[MEDIUM]` `#subset-sum` `#partition` `#optimization`

#### Problem Statement
Given an array of integers, partition it into two subsets, `S1` and `S2`, such that the absolute difference between their sums is minimized.

#### Implementation Overview
Let the total sum be `totalSum`. The goal is to minimize `abs(sum(S1) - sum(S2))`.
We know `sum(S1) + sum(S2) = totalSum`, so `sum(S2) = totalSum - sum(S1)`.
The expression to minimize becomes `abs(sum(S1) - (totalSum - sum(S1)))` which is `abs(2*sum(S1) - totalSum)`.

To minimize this, `sum(S1)` should be as close to `totalSum / 2` as possible.
1.  Use the boolean DP table from the "Subset Sum" problem. `dp[j]` will be `true` if a subset with sum `j` is possible.
2.  Iterate from `j = totalSum / 2` down to `0`.
3.  The first `j` for which `dp[j]` is `true` gives the `sum(S1)` that is closest to the half-sum.
4.  Calculate the minimum difference using this `sum(S1)`.

---

### 4. Count Subsets with Sum K (DP-17)
`[MEDIUM]` `#subset-sum` `#count`

#### Problem Statement
Given an array of integers and a sum `k`, find the number of subsets of the given array with a sum equal to `k`.

#### Implementation Overview
This is similar to the boolean Subset Sum, but instead of a boolean, `dp[i][j]` stores the *count* of subsets.
-   **DP State:** `dp[i][j]` = number of subsets with sum `j` using the first `i` items.
-   **Recurrence Relation:**
    -   Exclude `nums[i-1]`: `dp[i-1][j]` ways.
    -   Include `nums[i-1]`: `dp[i-1][j - nums[i-1]]` ways.
    The total is the sum: `dp[i][j] = dp[i-1][j] + dp[i-1][j - nums[i-1]]`.
-   **Base Cases:** `dp[0][0] = 1`.

#### Tricks/Gotchas
-   The problem might include `0`s in the array. If an element is `0`, it can be included or excluded. If `nums[i-1] == 0`, the recurrence becomes `dp[i][j] = dp[i-1][j] * 2`. Special handling for this case might be needed depending on the exact problem constraints and how the base cases are set up. A simpler way is to just follow the main recurrence.

---

### 5. Count Partitions with Given Difference (DP-18)
`[MEDIUM]` `#subset-sum` `#partition` `#count`

#### Problem Statement
Given an array and a difference `diff`, count the number of ways to partition the array into two subsets `S1` and `S2` such that `sum(S1) - sum(S2) = diff`.

#### Implementation Overview
This problem can be mathematically reduced to "Count Subsets with Sum K".
1.  Let `sum(S1)` be `s1` and `sum(S2)` be `s2`. We are given `s1 - s2 = diff`.
2.  We also know `s1 + s2 = totalSum`.
3.  Adding the two equations: `2*s1 = totalSum + diff`, which means `s1 = (totalSum + diff) / 2`.
4.  The problem is now to find the number of subsets that sum up to `s1`.
5.  This is exactly the "Count Subsets with Sum K" problem, where `K = s1`.
6.  **Edge cases:** If `totalSum + diff` is odd or `totalSum + diff < 0`, no solution is possible.

---

### 6. Target Sum (DP-21)
`[MEDIUM]` `#subset-sum` `#count`

#### Problem Statement
You are given a list of non-negative integers, `a1, a2, ..., an`, and a target, `S`. Now you have 2 symbols `+` and `-`. For each integer, you should choose one from `+` and `-` as its new symbol. Find out how many ways to assign symbols to make the sum of integers equal to the target `S`.

#### Implementation Overview
This is another variation that reduces to "Count Subsets with Sum K".
1.  Let the set of numbers with a `+` sign be `P` and the set with a `-` sign be `N`.
2.  We want `sum(P) - sum(N) = S`.
3.  We know `sum(P) + sum(N) = totalSum`.
4.  Adding the two equations gives `2*sum(P) = totalSum + S`.
5.  So, `sum(P) = (totalSum + S) / 2`.
6.  The problem is now to find the number of subsets `P` that sum to `(totalSum + S) / 2`. This is again the "Count Subsets with Sum K" problem.
