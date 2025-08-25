# Pattern 2: Unbounded Knapsack

The Unbounded Knapsack pattern is a variation of the classic 0/1 Knapsack (or Subset Sum) problem. The key difference is that you can use each item an **unlimited** number of times. This seemingly small change has a significant impact on the recurrence relation and the way the DP table is filled. Problems in this category often involve finding an optimal value (max/min) or counting combinations for a target, given a set of items that can be reused.

---

### 1. Unbounded Knapsack
`[MEDIUM]` `#unbounded-knapsack`

#### Problem Statement
Given a list of items, each with a weight and a value, and a knapsack of a maximum weight capacity `W`, determine the maximum total value of items that can be put into the knapsack. You can use any item an unlimited number of times.

*Example:* `W = 100`, `values = [10, 30, 20]`, `weights = [5, 10, 15]`. **Output:** `300` (10 items of weight 10 and value 30).

#### Implementation Overview
-   **DP State:** `dp[w]` = Maximum value achievable with a knapsack of capacity `w`.
-   **Recurrence Relation:** For each capacity `w` from 1 to `W`, we try to form that capacity using each available item.
    `dp[w] = max(dp[w], value[i] + dp[w - weight[i]])` for each item `i`, provided `w >= weight[i]`.
-   **Space Optimization:** The standard solution uses a 1D DP array of size `(W + 1)`. The key difference from 0/1 knapsack is that the inner loop (or in this case, the single loop over capacity) processes weights in increasing order. This allows an item's value to be used multiple times to build up the solution for a given capacity.

#### Python Code Snippet (1D DP)
```python
def unbounded_knapsack(W: int, values: list[int], weights: list[int]) -> int:
    n = len(values)
    dp = [0] * (W + 1)

    for w in range(1, W + 1):
        for i in range(n):
            if weights[i] <= w:
                dp[w] = max(dp[w], values[i] + dp[w - weights[i]])

    return dp[W]
```

---

### 2. Coin Change (Minimum Coins)
`[MEDIUM]` `#unbounded-knapsack` `#coin-change`

#### Problem Statement
Given an array of distinct integer coins and a total `amount`, find the fewest number of coins that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return -1.

*Example:* `coins = [1, 2, 5]`, `amount = 11`. **Output:** `3` (5 + 5 + 1).

#### Implementation Overview
This is a classic unbounded knapsack problem where the items are coins, their "weight" is their denomination, their "value" is 1, and we want to minimize the total "value" (number of coins).
-   **DP State:** `dp[i]` = Minimum number of coins required to make a sum of `i`.
-   **Initialization:** `dp` array of size `(amount + 1)` with a large value (infinity). Set `dp[0] = 0`.
-   **Recurrence Relation:** For each amount `i` from 1 to `amount`:
    `dp[i] = min(dp[i], 1 + dp[i - coin])` for each `coin` in the coin set, where `i >= coin`.
-   **Final Answer:** `dp[amount]`. If it's still infinity, the amount is unreachable.

#### Python Code Snippet
```python
def coin_change_min(coins: list[int], amount: int) -> int:
    # dp[i] will be storing the minimum number of coins required for amount i
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0 # Base case

    for i in range(1, amount + 1):
        for coin in coins:
            if i >= coin:
                dp[i] = min(dp[i], 1 + dp[i - coin])

    return dp[amount] if dp[amount] != float('inf') else -1
```

---

### 3. Coin Change II (Number of Combinations)
`[MEDIUM]` `#unbounded-knapsack` `#coin-change` `#count-combinations`

#### Problem Statement
Given an array of distinct integer coins and a total `amount`, find the number of **combinations** of coins that make up that amount.

*Example:* `amount = 5`, `coins = [1, 2, 5]`. **Output:** `4`
(Combinations: 5, 2+2+1, 2+1+1+1, 1+1+1+1+1)

#### Implementation Overview
This variation focuses on counting combinations. The key is the order of loops to avoid counting permutations.
-   **DP State:** `dp[i]` = Number of ways to make a sum of `i`.
-   **Initialization:** `dp` array of size `(amount + 1)`. `dp[0] = 1` (one way to make sum 0: by choosing no coins).
-   **Recurrence Relation:** We iterate through the coins one by one. For each coin, we update the `dp` array for all amounts it can contribute to. This ensures we are only considering combinations.
    ```
    for coin in coins:
        for i from coin to amount:
            dp[i] = dp[i] + dp[i - coin]
    ```

#### Python Code Snippet
```python
def coin_change_combinations(amount: int, coins: list[int]) -> int:
    dp = [0] * (amount + 1)
    dp[0] = 1

    # Outer loop for coins ensures we count combinations, not permutations
    for coin in coins:
        for j in range(coin, amount + 1):
            dp[j] += dp[j - coin]

    return dp[amount]
```

---

### 4. Rod Cutting Problem
`[MEDIUM]` `#unbounded-knapsack`

#### Problem Statement
Given a rod of length `n` and an array of prices where `prices[i]` is the price of a piece of length `i+1`, determine the maximum value obtainable by cutting up the rod and selling the pieces.

*Example:* `prices = [1, 5, 8, 9, 10, 17, 17, 20]` for lengths 1 to 8. `n = 8`.
**Output:** `22` (by cutting into two pieces of length 2 and 6).

#### Implementation Overview
This is a classic unbounded knapsack problem in disguise.
-   **Knapsack Analogy:**
    -   The "knapsack capacity" is the total length of the rod, `n`.
    -   The "items" are the different possible piece lengths (1, 2, ..., n).
    -   The "weight" of an item is its length.
    -   The "value" of an item is its price.
-   **DP State:** `dp[i]` = Maximum profit obtainable from a rod of length `i`.
-   **Recurrence Relation:** For each length `i`, we can make a cut of length `j` and add its price to the optimal solution for the remaining length `i-j`.
    `dp[i] = max(price[j-1] + dp[i-j])` for all possible cut lengths `j` from 1 to `i`.

#### Python Code Snippet
```python
def rod_cutting(prices: list[int], n: int) -> int:
    # dp[i] will be the maximum price for a rod of length i
    dp = [0] * (n + 1)

    for i in range(1, n + 1):
        max_val = 0
        for j in range(1, i + 1):
            # prices array is 0-indexed, so price of length j is at prices[j-1]
            max_val = max(max_val, prices[j-1] + dp[i-j])
        dp[i] = max_val

    return dp[n]
```
