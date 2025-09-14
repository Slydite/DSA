# Pattern 2: Partition DP & MCM

Partition DP is a powerful pattern for problems where the objective is to find an optimal way to solve a problem by partitioning a sequence. The core idea is to define a state `dp[i][j]` representing the optimal solution for the subproblem on the range `arr[i...j]`. To compute `dp[i][j]`, we iterate through all possible partition points `k` between `i` and `j`, recursively solving the subproblems and combining their results. Matrix Chain Multiplication (MCM) is the most famous example.

---

### 1. Matrix Chain Multiplication (MCM)
`[HARD]` `#partition-dp` `#mcm`

#### Problem Statement
Given an array `arr` where `arr[i-1] x arr[i]` is the dimension of the `i`-th matrix, find the minimum number of scalar multiplications needed to multiply the chain of matrices.

#### Recurrence Relation
Let `solve(i, j)` be the min cost to multiply matrices `A[i]` through `A[j]`.
The dimensions of matrix `A[k]` are `arr[k-1] x arr[k]`.
To find `solve(i, j)`, we can split the chain at any point `k` between `i` and `j-1`.
- **`cost = solve(i, k) + solve(k+1, j) + cost_of_final_multiplication`**
- The final multiplication is between the resulting matrix from `(i..k)` (size `arr[i-1] x arr[k]`) and `(k+1..j)` (size `arr[k] x arr[j]`). The cost is `arr[i-1] * arr[k] * arr[j]`.
- **`solve(i, j) = min(solve(i,k) + solve(k+1,j) + arr[i-1]*arr[k]*arr[j])`** for `k` in `i..j-1`.
- **Base Case:** `solve(i, i) = 0` (a single matrix requires no multiplications).

---
#### a) Memoization (Top-Down)
```python
def mcm_memo(arr: list[int]) -> int:
    n = len(arr)
    dp = [[-1] * n for _ in range(n)]

    def solve(i, j):
        if i == j:
            return 0
        if dp[i][j] != -1:
            return dp[i][j]

        min_cost = float('inf')
        for k in range(i, j):
            cost = solve(i, k) + solve(k + 1, j) + arr[i-1] * arr[k] * arr[j]
            min_cost = min(min_cost, cost)

        dp[i][j] = min_cost
        return dp[i][j]

    return solve(1, n - 1)
```
- **Time Complexity:** O(n^3). There are O(n^2) states, and each state takes O(n) time for the loop over `k`.
- **Space Complexity:** O(n^2) for DP table + O(n) for recursion stack.

---
#### b) Tabulation (Bottom-Up)
```python
def mcm_tab(arr: list[int]) -> int:
    n = len(arr)
    dp = [[0] * n for _ in range(n)]

    # l is the chain length
    for l in range(2, n):
        for i in range(1, n - l + 1):
            j = i + l - 1
            dp[i][j] = float('inf')
            for k in range(i, j):
                cost = dp[i][k] + dp[k+1][j] + arr[i-1] * arr[k] * arr[j]
                dp[i][j] = min(dp[i][j], cost)

    return dp[1][n-1]
```
- **Time Complexity:** O(n^3).
- **Space Complexity:** O(n^2).

---

### 2. Minimum Cost to Cut the Stick
`[HARD]` `#partition-dp`

#### Problem Statement
Given a stick of length `n` and an array `cuts` of positions, find the minimum cost to make all cuts. The cost of a cut is the length of the stick segment it's on.

#### Recurrence Relation
1. Add `0` and `n` to `cuts` and sort it. This gives us the boundaries of all segments.
2. Let `solve(i, j)` be the min cost to cut the stick segment defined by `cuts[i]` and `cuts[j]`.
3. To find `solve(i, j)`, we try making the first cut at each possible position `k` between `i` and `j`.
- **Cost:** `(cuts[j] - cuts[i])` (cost of the current cut) `+ solve(i, k) + solve(k, j)`.
- **`solve(i, j) = (cuts[j] - cuts[i]) + min(solve(i,k) + solve(k,j))`** for `k` in `i+1..j-1`.
- **Base Case:** If `j <= i + 1`, there are no cuts to be made, so cost is 0.

---
#### a) Memoization (Top-Down)
```python
def min_cost_cut_stick_memo(n: int, cuts: list[int]) -> int:
    cuts = sorted([0] + cuts + [n])
    m = len(cuts)
    dp = [[-1] * m for _ in range(m)]

    def solve(i, j):
        if j <= i + 1:
            return 0
        if dp[i][j] != -1:
            return dp[i][j]

        min_cost = float('inf')
        for k in range(i + 1, j):
            cost = (cuts[j] - cuts[i]) + solve(i, k) + solve(k, j)
            min_cost = min(min_cost, cost)

        dp[i][j] = min_cost
        return dp[i][j]

    return solve(0, m - 1)
```
- **Time/Space Complexity:** O(m^3), where m is the number of cuts.

---
#### b) Tabulation (Bottom-Up)
```python
def min_cost_cut_stick_tab(n: int, cuts: list[int]) -> int:
    cuts = sorted([0] + cuts + [n])
    m = len(cuts)
    dp = [[0] * m for _ in range(m)]

    # Iterate by increasing length of the segment (j - i)
    for i in range(m - 2, -1, -1):
        for j in range(i + 2, m):
            min_cost = float('inf')
            for k in range(i + 1, j):
                cost = (cuts[j] - cuts[i]) + dp[i][k] + dp[k][j]
                min_cost = min(min_cost, cost)
            dp[i][j] = min_cost

    return dp[0][m-1]
```
- **Time/Space Complexity:** O(m^3).

---

### 3. Burst Balloons
`[HARD]` `#partition-dp`

#### Problem Statement
Given `n` balloons with values `nums[i]`, bursting balloon `i` gives `nums[left] * nums[i] * nums[right]` coins. Find the maximum coins.

#### Recurrence Relation
The key is to think in reverse: which balloon do we burst **last** in a given range `(i, j)`?
1. Add `1` to the beginning and end of `nums` to handle boundaries.
2. Let `solve(i, j)` be the max coins from bursting balloons in the open interval `(i, j)`.
3. Let `k` be the *last* balloon burst in `(i, j)`. Its neighbors will be `i` and `j`.
- **`coins = solve(i,k) + solve(k,j) + nums[i]*nums[k]*nums[j]`**.
- **`solve(i, j) = max(coins)`** over all `k` from `i+1` to `j-1`.
- **Base Case:** If `j <= i + 1`, no balloons to burst, cost is 0.

---
#### a) Memoization (Top-Down)
```python
def max_coins_memo(nums: list[int]) -> int:
    nums = [1] + nums + [1]
    n = len(nums)
    dp = [[-1] * n for _ in range(n)]

    def solve(i, j):
        if i >= j - 1: return 0
        if dp[i][j] != -1: return dp[i][j]

        max_c = 0
        for k in range(i + 1, j):
            coins = solve(i, k) + solve(k, j) + nums[i] * nums[k] * nums[j]
            max_c = max(max_c, coins)
        dp[i][j] = max_c
        return dp[i][j]

    return solve(0, n - 1)
```
- **Time/Space Complexity:** O(n^3).

---
#### b) Tabulation (Bottom-Up)
```python
def max_coins_tab(nums: list[int]) -> int:
    nums = [1] + nums + [1]
    n = len(nums)
    dp = [[0] * n for _ in range(n)]

    for i in range(n - 2, -1, -1):
        for j in range(i + 2, n):
            max_c = 0
            for k in range(i + 1, j):
                coins = dp[i][k] + dp[k][j] + nums[i] * nums[k] * nums[j]
                max_c = max(max_c, coins)
            dp[i][j] = max_c

    return dp[0][n-1]
```
- **Time/Space Complexity:** O(n^3).

---

### 4. Partition Array for Maximum Sum
`[MEDIUM]` `#partition-dp`

#### Problem Statement
Partition an array `arr` into contiguous subarrays of length at most `k`. After partitioning, each subarray's values are changed to become the max value of that subarray. Return the largest sum of the array after partitioning.

#### Recurrence Relation
This is a 1D DP problem, but with a partition-like thought process.
- **`dp[i]`**: max sum for the prefix `arr[0...i-1]`.
- To compute `dp[i]`, we consider the last subarray ending at `i-1`. It can have length `j` from 1 to `k`.
- **`dp[i] = max(dp[i-j] + max_in_last_partition * j)`** for `j` from 1 to `k`.

---
#### a) Memoization (Top-Down)
```python
def max_sum_after_partitioning_memo(arr: list[int], k: int) -> int:
    n = len(arr)
    dp = [-1] * n

    def solve(index):
        if index == n: return 0
        if dp[index] != -1: return dp[index]

        max_ans = 0
        max_val_in_partition = 0
        for j in range(index, min(n, index + k)):
            max_val_in_partition = max(max_val_in_partition, arr[j])
            partition_len = j - index + 1
            current_sum = (max_val_in_partition * partition_len) + solve(j + 1)
            max_ans = max(max_ans, current_sum)

        dp[index] = max_ans
        return dp[index]

    return solve(0)
```
- **Time Complexity:** O(n * k).
- **Space Complexity:** O(n) for DP table + O(n) for recursion stack.

---
#### b) Tabulation (Bottom-Up)
```python
def max_sum_after_partitioning_tab(arr: list[int], k: int) -> int:
    n = len(arr)
    dp = [0] * (n + 1)

    for i in range(1, n + 1):
        max_val_in_partition = 0
        # Look back at most k elements for the last partition
        for j in range(1, k + 1):
            if i - j >= 0:
                max_val_in_partition = max(max_val_in_partition, arr[i-j])
                current_sum = dp[i-j] + max_val_in_partition * j
                dp[i] = max(dp[i], current_sum)

    return dp[n]
```
- **Time Complexity:** O(n * k).
- **Space Complexity:** O(n).
