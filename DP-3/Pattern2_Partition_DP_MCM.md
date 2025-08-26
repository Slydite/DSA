# Pattern 2: Partition DP & MCM (Matrix Chain Multiplication)

Partition DP is a powerful pattern used for problems where the objective is to find the optimal way to solve a problem for a sequence (e.g., an array or a string) by partitioning it. The core idea is to define a state `dp[i][j]` that represents the optimal solution for the subproblem on the range `arr[i...j]`. To compute `dp[i][j]`, we iterate through all possible partition points `k` between `i` and `j`, recursively solving the subproblems `dp[i][k]` and `dp[k+1][j]` and then combining their results. Matrix Chain Multiplication (MCM) is the most famous example of this pattern.

---

### 1. Matrix Chain Multiplication
`[HARD]` `#partition-dp` `#mcm`

#### Problem Statement
Given a sequence of matrices, find the most efficient way to multiply these matrices together. The problem is not to perform the multiplications, but to decide the sequence. Given an array `arr` where `arr[i-1] x arr[i]` is the dimension of the `i`-th matrix, find the minimum number of scalar multiplications needed.

*Example:* `arr = [10, 20, 30, 40, 50]`. This represents 4 matrices of dimensions 10x20, 20x30, 30x40, 40x50. **Output:** `13400`.

#### Implementation Overview
-   **DP State:** `dp[i][j]` = Minimum number of multiplications to compute the product of matrices from `A[i]` to `A[j]`.
-   **Recurrence Relation:** To compute `dp[i][j]`, we try every possible split point `k` where we make the final multiplication. `i <= k < j`.
    -   `cost = dp[i][k] + dp[k+1][j] + arr[i-1] * arr[k] * arr[j]`.
    -   `dp[i][j] = min(cost)` over all `k` from `i` to `j-1`.
-   **Tabulation:** The table is filled diagonally by chain length.

#### Python Code Snippet
```python
def matrix_multiplication_cost(arr: list[int]) -> int:
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

---

### 2. Minimum Cost to Cut the Stick
`[HARD]` `#partition-dp` `#mcm-variant`

#### Problem Statement
Given a wooden stick of length `n` and an array `cuts` where `cuts[i]` denotes a position you should perform a cut. The cost of a cut is the length of the stick segment being cut. Find the minimum total cost.

*Example:* `n = 7`, `cuts = [1,3,4,5]`. **Output:** `16`.

#### Implementation Overview
This can be mapped to MCM.
1.  Add `0` and `n` to `cuts` and sort it.
2.  **DP State:** `dp[i][j]` = min cost to make all cuts between `cuts[i]` and `cuts[j]`.
3.  **Recurrence Relation:** The cost of the first cut in segment `(cuts[i], cuts[j])` is `cuts[j] - cuts[i]`. We try all possible first cuts `k` between `i` and `j`.
    -   `cost = (cuts[j] - cuts[i]) + dp[i][k] + dp[k][j]`.
    -   `dp[i][j] = (cuts[j] - cuts[i]) + min(cost)` over all `k` from `i+1` to `j-1`.

#### Python Code Snippet
```python
def min_cost_to_cut_stick(n: int, cuts: list[int]) -> int:
    cuts = sorted([0] + cuts + [n])
    m = len(cuts)
    dp = [[0] * m for _ in range(m)]

    for i in range(m - 2, -1, -1):
        for j in range(i + 2, m):
            min_cost = float('inf')
            for k in range(i + 1, j):
                cost = (cuts[j] - cuts[i]) + dp[i][k] + dp[k][j]
                min_cost = min(min_cost, cost)
            dp[i][j] = min_cost

    return dp[0][m-1]
```

---

### 3. Burst Balloons
`[HARD]` `#partition-dp` `#mcm-variant`

#### Problem Statement
Given `n` balloons, with values `nums[i]`. If you burst balloon `i`, you get `nums[left] * nums[i] * nums[right]` coins. Find the maximum coins you can collect.

*Example:* `nums = [3,1,5,8]`. **Output:** `167`.

#### Implementation Overview
The key is to think in reverse: which balloon do we burst **last** in a given range `(i, j)`?
1.  Add `1` to the beginning and end of `nums`.
2.  **DP State:** `dp[i][j]` = max coins by bursting all balloons in the open interval `(i, j)`.
3.  **Recurrence:** Let `k` be the *last* balloon burst in `(i, j)`. Its neighbors will be `i` and `j`.
    -   `coins = nums[i]*nums[k]*nums[j] + dp[i][k] + dp[k][j]`.
    -   `dp[i][j] = max(coins)` over all `k` from `i+1` to `j-1`.

#### Python Code Snippet
```python
def max_coins_burst_balloons(nums: list[int]) -> int:
    nums = [1] + nums + [1]
    n = len(nums)
    dp = [[0] * n for _ in range(n)]

    for i in range(n - 2, -1, -1):
        for j in range(i + 2, n):
            max_c = 0
            for k in range(i + 1, j):
                coins = nums[i] * nums[k] * nums[j] + dp[i][k] + dp[k][j]
                max_c = max(max_c, coins)
            dp[i][j] = max_c

    return dp[0][n-1]
```

---

### 4. Evaluate Boolean Expression to True
`[HARD]` `#partition-dp`

#### Problem Statement
Given a boolean expression of symbols `T`, `F` and operators `&, |, ^`, count the number of ways to parenthesize it to evaluate to `true`.

*Example:* `S = "T|F&T"`. **Output:** `2` ((T|F)&T, T|(F&T)).

#### Implementation Overview
-   **DP State:** `dp[i][j]` stores `{true_count, false_count}` for the sub-expression `S[i...j]`.
-   **Recurrence:** Iterate through all operators `k` in the range. Combine results from left `(i, k-1)` and right `(k+1, j)` subproblems based on the operator at `k`.

#### Python Code Snippet
```python
def evaluate_expression_true_ways(s: str) -> int:
    ops, expr = [], []
    for char in s:
        if char in '&|^': ops.append(char)
        else: expr.append(True if char == 'T' else False)

    n = len(expr)
    dp = [[(0, 0)] * n for _ in range(n)]

    for i in range(n - 1, -1, -1):
        for j in range(i, n):
            if i == j:
                dp[i][j] = (1, 0) if expr[i] else (0, 1)
                continue

            true_ways, false_ways = 0, 0
            for k in range(i, j):
                lt, lf = dp[i][k]
                rt, rf = dp[k+1][j]
                op = ops[k]

                if op == '&':
                    true_ways += lt * rt
                    false_ways += (lt*rf + lf*rt + lf*rf)
                elif op == '|':
                    true_ways += (lt*rt + lt*rf + lf*rt)
                    false_ways += lf * rf
                elif op == '^':
                    true_ways += (lt*rf + lf*rt)
                    false_ways += (lt*rt + lf*rf)
            dp[i][j] = (true_ways, false_ways)

    return dp[0][n-1][0]
```

---

### 5. Palindrome Partitioning II
`[MEDIUM]` `#partition-dp`

#### Problem Statement
Given a string `s`, partition `s` such that every substring of the partition is a palindrome. Return the minimum cuts needed.

*Example:* `s = "aab"`. **Output:** `1` (Partition "aa", "b").

#### Implementation Overview
-   **DP State:** `dp[i]` = min cuts needed for a palindrome partitioning of the prefix `s[0...i-1]`.
-   **Recurrence:** `dp[i] = min(1 + dp[j])` over all `j < i` where `s[j...i-1]` is a palindrome.
-   **Optimization:** Pre-compute all palindromic substrings in a 2D boolean table.

#### Python Code Snippet
```python
def min_cuts_palindrome_partitioning(s: str) -> int:
    n = len(s)
    # is_palindrome[i][j] is true if s[i..j] is a palindrome
    is_palindrome = [[False] * n for _ in range(n)]
    for i in range(n-1, -1, -1):
        for j in range(i, n):
            if s[i] == s[j] and (j - i < 2 or is_palindrome[i+1][j-1]):
                is_palindrome[i][j] = True

    # dp[i] = min cuts for prefix s[0..i-1]
    dp = [0] * (n + 1)
    for i in range(n + 1):
        dp[i] = i - 1 # Max cuts for string of length i is i-1

    for i in range(1, n + 1):
        for j in range(i):
            if is_palindrome[j][i-1]:
                dp[i] = min(dp[i], 1 + dp[j])

    return dp[n]
```

---

### 6. Partition Array for Maximum Sum
`[MEDIUM]` `#partition-dp`

#### Problem Statement
Given an integer array `arr`, you partition it into contiguous subarrays of length at most `k`. After partitioning, each subarray's values are changed to become the maximum value of that subarray. Return the largest sum of the given array after partitioning.

*Example:* `arr = [1,15,7,9,2,5,10]`, `k = 3`. **Output:** `84`.

#### Implementation Overview
-   **DP State:** `dp[i]` = max sum for the prefix `arr[0...i-1]`.
-   **Recurrence:** To compute `dp[i]`, we consider the last subarray ending at `i-1`. It can have length from 1 to `k`.
    -   `dp[i] = max(dp[j] + max(arr[j...i-1]) * (i-j))` over `j` from `i-1` down to `i-k`.

#### Python Code Snippet
```python
def max_sum_after_partitioning(arr: list[int], k: int) -> int:
    n = len(arr)
    dp = [0] * (n + 1)

    for i in range(1, n + 1):
        max_val_in_partition = 0
        # Look back at most k elements
        for j in range(1, k + 1):
            if i - j >= 0:
                max_val_in_partition = max(max_val_in_partition, arr[i-j])
                dp[i] = max(dp[i], dp[i-j] + max_val_in_partition * j)

    return dp[n]
```
