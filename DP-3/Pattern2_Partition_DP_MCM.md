# Pattern 2: Partition DP & MCM (Matrix Chain Multiplication)

Partition DP is a powerful pattern used for problems where the objective is to find the optimal way to solve a problem for a sequence (e.g., an array or a string) by partitioning it. The core idea is to define a state `dp[i][j]` that represents the optimal solution for the subproblem on the range `arr[i...j]`. To compute `dp[i][j]`, we iterate through all possible partition points `k` between `i` and `j`, recursively solving the subproblems `dp[i][k]` and `dp[k+1][j]` and then combining their results. Matrix Chain Multiplication (MCM) is the most famous example of this pattern.

---

### 1. Matrix Chain Multiplication (DP-48, DP-49)
`[HARD]` `#partition-dp` `#mcm`

#### Problem Statement
Given a sequence of matrices, find the most efficient way to multiply these matrices together. The problem is not actually to perform the multiplications, but merely to decide the sequence of the matrix multiplications. We are given a sequence of matrices `A1, A2, ..., An` and their dimensions `p0, p1, ..., pn` where matrix `Ai` has dimension `pi-1 x pi`. Find the minimum number of scalar multiplications needed.

#### Implementation Overview
-   **DP State:** `dp[i][j]` = Minimum number of scalar multiplications needed to compute the product of matrices from `A[i]` to `A[j]`.
-   **Recurrence Relation:** To compute `dp[i][j]`, we try every possible split point `k` where we make the final multiplication. `i <= k < j`.
    -   We split the chain into `(A[i]...A[k])` and `(A[k+1]...A[j])`.
    -   Cost = `cost(A[i]...A[k])` + `cost(A[k+1]...A[j])` + `cost of multiplying the two resulting matrices`.
    -   Cost = `dp[i][k] + dp[k+1][j] + dims[i-1] * dims[k] * dims[j]`.
    -   `dp[i][j] = min(dp[i][k] + dp[k+1][j] + dims[i-1] * dims[k] * dims[j])` over all `k` from `i` to `j-1`.
-   **Tabulation:** The table is filled diagonally. We compute solutions for chains of length 2, then 3, and so on, up to `n`.

---

### 2. Minimum Cost to Cut the Stick (DP-50)
`[HARD]` `#partition-dp` `#mcm-variant`

#### Problem Statement
Given a wooden stick of length `n` and an array `cuts` where `cuts[i]` denotes a position you should perform a cut. The cost of a cut is the length of the stick segment you are cutting. Find the minimum total cost to perform all cuts.

#### Implementation Overview
This problem can be mapped to MCM.
1.  Add `0` and `n` to the `cuts` array and sort it. This gives a list of all segment endpoints.
2.  **DP State:** `dp[i][j]` = minimum cost to make all cuts between position `cuts[i]` and `cuts[j]`.
3.  **Recurrence Relation:** The cost of the first cut we make in the segment `(cuts[i], cuts[j])` is `cuts[j] - cuts[i]`. We can choose any `cuts[k]` (where `i < k < j`) as our first cut.
    -   `cost = (cuts[j] - cuts[i]) + dp[i][k] + dp[k][j]`.
    -   `dp[i][j] = (cuts[j] - cuts[i]) + min(dp[i][k] + dp[k][j])` over all `k` from `i+1` to `j-1`.
-   The final answer is `dp[0][cuts.length - 1]`.

---

### 3. Burst Balloons (DP-51)
`[HARD]` `#partition-dp` `#mcm-variant`

#### Problem Statement
You are given `n` balloons, indexed from 0 to `n-1`. Each balloon has a number painted on it represented by the array `nums`. You are asked to burst all the balloons. If you burst the `i`-th balloon, you will get `nums[left] * nums[i] * nums[right]` coins, where `left` and `right` are the adjacent indices to `i`. After the burst, `left` and `right` then become adjacent. Find the maximum coins you can collect.

#### Implementation Overview
This is a tricky problem. The key is to think in reverse: which balloon do we burst **last** in a given range?
1.  Add `1` to the beginning and end of `nums` to handle boundary conditions.
2.  **DP State:** `dp[i][j]` = maximum coins we can collect by bursting all balloons in the open interval `(i, j)`.
3.  **Recurrence Relation:** Let `k` be the index of the *last* balloon to be burst in `(i, j)`. When we burst `k`, its neighbors will be `i` and `j`.
    -   The coins gained from this last burst are `nums[i] * nums[k] * nums[j]`.
    -   The total coins are this amount plus the coins from the subproblems `(i, k)` and `(k, j)`.
    -   `dp[i][j] = max(nums[i]*nums[k]*nums[j] + dp[i][k] + dp[k][j])` over all `k` from `i+1` to `j-1`.
-   The final answer is `dp[0][n+1]`.

---

### 4. Evaluate Boolean Expression to True (DP-52)
`[HARD]` `#partition-dp`

#### Problem Statement
Given a boolean expression consisting of symbols `T` (true), `F` (false) and operators `&` (AND), `|` (OR), `^` (XOR), count the number of ways to parenthesize the expression such that it evaluates to `true`.

#### Implementation Overview
-   **DP State:** `dp[i][j]` must store the number of ways a sub-expression can be true and false. So, `dp[i][j] = {number_of_trues, number_of_falses}` for the expression from index `i` to `j`.
-   **Recurrence:** We iterate through all operators at index `k` in the range `[i, j]`.
    -   For each operator, we get the counts from the left subproblem `dp[i][k-1]` and the right subproblem `dp[k+1][j]`.
    -   Based on the operator (`&`, `|`, or `^`), we calculate how many of the combined evaluations result in `true` and how many result in `false`. For example, for `&`, `true_count += left_true * right_true`.
-   **Base Cases:** For a single character `dp[i][i]`, if it's 'T', the state is `{1, 0}`. If 'F', it's `{0, 1}`.

---

### 5. Palindrome Partitioning - II (DP-53)
`[HARD]` `#partition-dp`

#### Problem Statement
Given a string `s`, partition `s` such that every substring of the partition is a palindrome. Return the minimum cuts needed for a palindrome partitioning of `s`.

#### Implementation Overview
This can be solved with a 1D DP array.
-   **DP State:** `dp[i]` = the minimum number of cuts needed for a palindrome partitioning of the prefix `s[0...i-1]`.
-   **Recurrence:** To compute `dp[i]`, we can make the last cut at index `j` (where `0 <= j < i`). If the substring `s[j...i-1]` is a palindrome, then we have a potential solution: `1 + dp[j]`.
    -   `dp[i] = min(1 + dp[j])` over all `j` where `s[j...i-1]` is a palindrome.
-   **Optimization:** Pre-computing all possible palindromic substrings in a 2D boolean table `isPalindrome[i][j]` can speed up the inner checks from O(N) to O(1).
-   **Base Case:** `dp[0] = -1` (or handle it such that a full palindrome string requires 0 cuts).

---

### 6. Partition Array for Maximum Sum (DP-54)
`[HARD]` `#partition-dp`

#### Problem Statement
Given an integer array `arr`, you partition the array into contiguous subarrays of length at most `k`. After partitioning, each subarray's values are changed to become the maximum value of that subarray. Return the largest sum of the given array after partitioning.

#### Implementation Overview
-   **DP State:** `dp[i]` = the maximum sum we can get for the prefix `arr[0...i-1]`.
-   **Recurrence:** To compute `dp[i]`, we consider the last subarray. This subarray can have a length from 1 to `k`. Let's say the last subarray starts at index `j` and ends at `i-1`.
    -   The length of this subarray is `i-j`. This must be `<= k`.
    -   The maximum element in this subarray is `max_val = max(arr[j...i-1])`.
    -   The sum of this transformed subarray is `max_val * (i-j)`.
    -   The total sum for this partition is `dp[j] + (max_val * (i-j))`.
    -   `dp[i] = max(dp[j] + max(arr[j...i-1]) * (i-j))` over `j` from `i-1` down to `i-k`.
-   **Final Answer:** `dp[n]`.
