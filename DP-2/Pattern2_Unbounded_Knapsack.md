# Pattern 2: Unbounded Knapsack

The Unbounded Knapsack pattern is a variation of the classic 0/1 Knapsack (or Subset Sum) problem. The key difference is that you can use each item an unlimited number of times. This seemingly small change has a significant impact on the recurrence relation and the way the DP table is filled. Problems in this category often involve finding an optimal value (max/min) or counting combinations for a target, given a set of items that can be reused.

---

### 1. Unbounded Knapsack (DP-23)
`[HARD]` `#unbounded-knapsack`

#### Problem Statement
Given a list of items, each with a weight and a value, and a knapsack of a maximum weight capacity, determine the maximum total value of items that can be put into the knapsack. You can use any item an unlimited number of times.

#### Implementation Overview
-   **DP State:** `dp[i][w]` = Maximum value achievable with a knapsack of capacity `w`, considering items up to index `i`.
-   **Recurrence Relation:** For each item `i` and weight `w`, we have two choices:
    1.  **Don't include item `i`**: The value is the same as for the previous item at the same weight: `dp[i-1][w]`.
    2.  **Include item `i`**: This is possible if `w >= weight[i]`. The value is `value[i] + dp[i][w - weight[i]]`. The crucial difference from 0/1 Knapsack is using `dp[i]` in the second term (not `dp[i-1]`), which signifies that we can still use item `i` again for the remaining weight.
    `dp[i][w] = max(dp[i-1][w], value[i] + dp[i][w - weight[i]])`.
-   **Space Optimization:** This can be optimized to a 1D DP array of size `(capacity + 1)`. The inner loop for weights should run from `0` to `capacity`.

---

### 2. Minimum Coins (DP-20)
`[HARD]` `#unbounded-knapsack` `#coin-change`

#### Problem Statement
Given an array of distinct integer coins and a total amount, find the fewest number of coins that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return -1.

#### Implementation Overview
This is a classic unbounded knapsack problem where the items are the coins, their "weight" is their denomination, their "value" is 1 (since we count each coin as one), and we want to minimize the total "value".
-   **DP State:** `dp[i]` = Minimum number of coins required to make a sum of `i`.
-   **Initialization:** Initialize `dp` array of size `(amount + 1)` with a large value (e.g., infinity). Set `dp[0] = 0`.
-   **Recurrence Relation:** For each amount `i` from 1 to `total_amount`:
    `dp[i] = min(dp[i], 1 + dp[i - coin])` for each `coin` in the coin set, where `i >= coin`.
-   **Final Answer:** `dp[amount]`. If `dp[amount]` is still the initial large value, it means the amount is unreachable.

---

### 3. Coin Change 2 (DP-22)
`[HARD]` `#unbounded-knapsack` `#coin-change` `#count-combinations`

#### Problem Statement
Given an array of distinct integer coins and a total amount, find the number of combinations of coins that make up that amount.

#### Implementation Overview
This variation focuses on counting combinations, not permutations. The key is the order of loops.
-   **DP State:** `dp[i]` = Number of ways to make a sum of `i`.
-   **Initialization:** `dp` array of size `(amount + 1)`. `dp[0] = 1` (there is one way to make sum 0: by choosing no coins).
-   **Recurrence Relation:** To count combinations, we iterate through the coins one by one and, for each coin, update the `dp` array for all amounts it can contribute to.
    ```
    for coin in coins:
        for i from coin to amount:
            dp[i] = dp[i] + dp[i - coin]
    ```
-   **Final Answer:** `dp[amount]`.

#### Tricks/Gotchas
-   The order of loops is critical. Iterating through coins in the outer loop and amounts in the inner loop ensures we count combinations (e.g., {1, 2} is the same as {2, 1}). If the loops were swapped, we would be counting permutations.

---

### 4. Rod Cutting Problem (DP-24)
`[HARD]` `#unbounded-knapsack`

#### Problem Statement
Given a rod of length `n` and an array of prices that includes prices of all pieces of size smaller than `n`, determine the maximum value obtainable by cutting up the rod and selling the pieces.

#### Implementation Overview
This is a classic unbounded knapsack problem in disguise.
-   **Knapsack Analogy:**
    -   The "knapsack capacity" is the total length of the rod, `n`.
    -   The "items" are the different possible piece lengths (1, 2, ..., n).
    -   The "weight" of an item is its length.
    -   The "value" of an item is its price.
-   **DP State:** `dp[i]` = Maximum profit obtainable from a rod of length `i`.
-   **Recurrence Relation:** For each length `i` from 1 to `n`, we can either not cut it, or make a cut of length `j` and find the optimal solution for the remaining `i-j`.
    `dp[i] = max(price[j-1] + dp[i-j])` for all possible cut lengths `j` from 1 to `i`.
-   **Final Answer:** `dp[n]`.
