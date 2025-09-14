# Pattern 2: Unbounded Knapsack

The Unbounded Knapsack pattern is a variation of 0/1 Knapsack. The key difference is that you can use each item an **unlimited** number of times. This changes the recurrence relation, as the choice for an item does not remove it from the set of future choices.

---

### 1. Unbounded Knapsack
`[MEDIUM]` `#unbounded-knapsack`

#### Problem Statement
Given items with weights and values, and a knapsack of capacity `W`, find the maximum value of items that can be put into the knapsack. You can use any item an unlimited number of times.

#### Recurrence Relation
Let `solve(index, capacity)` be the max value from items `0..index` with a given `capacity`.
- **Choice 1 (Don't Pick):** If we don't pick `nums[index]`, the value is `solve(index - 1, capacity)`.
- **Choice 2 (Pick):** If we pick `nums[index]`, the value is `values[index] + solve(index, capacity - weights[index])`. Note that we stay at the same `index` because we can pick the item again.
- **`solve(index, capacity) = max(choice1, choice2)`**

---
#### a) Memoization (Top-Down)
```python
def unbounded_knapsack_memo(W, values, weights):
    n = len(values)
    dp = [[-1] * (W + 1) for _ in range(n)]

    def solve(index, capacity):
        if index == 0:
            return (capacity // weights[0]) * values[0]
        if dp[index][capacity] != -1:
            return dp[index][capacity]

        not_pick = solve(index - 1, capacity)
        pick = -1
        if weights[index] <= capacity:
            pick = values[index] + solve(index, capacity - weights[index])

        dp[index][capacity] = max(pick, not_pick)
        return dp[index][capacity]

    return solve(n - 1, W)
```
- **Time Complexity:** O(n * W).
- **Space Complexity:** O(n * W) for DP table + O(n) for recursion stack.

---
#### b) Tabulation (Bottom-Up)
```python
def unbounded_knapsack_tab(W, values, weights):
    n = len(values)
    dp = [[0] * (W + 1) for _ in range(n)]

    # Base case for the first item
    for w in range(W + 1):
        dp[0][w] = (w // weights[0]) * values[0]

    for i in range(1, n):
        for w in range(W + 1):
            not_pick = dp[i-1][w]
            pick = -1
            if weights[i] <= w:
                pick = values[i] + dp[i][w - weights[i]]
            dp[i][w] = max(pick, not_pick)

    return dp[n-1][W]
```
- **Time Complexity:** O(n * W).
- **Space Complexity:** O(n * W).

---
#### c) Space Optimization (1D Array)
The tabulation can be optimized to a single 1D array. The key difference from 0/1 knapsack is that the inner loop for `w` runs from left to right. This allows the current item `i` to be considered multiple times for a given capacity `w`.

```python
def unbounded_knapsack_optimized(W, values, weights):
    n = len(values)
    dp = [0] * (W + 1)

    for i in range(n):
        for w in range(weights[i], W + 1):
            dp[w] = max(dp[w], values[i] + dp[w - weights[i]])

    return dp[W]
```
- **Time Complexity:** O(n * W).
- **Space Complexity:** O(W).

---

### 2. Coin Change (Minimum Coins)
`[MEDIUM]` `#unbounded-knapsack` `#coin-change`

#### Problem Statement
Given coins of different denominations and a total `amount`, find the fewest coins needed to make up that amount. If impossible, return -1.

#### Recurrence Relation
Let `dp[i]` be the min coins for amount `i`.
- **`dp[i] = 1 + min(dp[i - coin])`** for every `coin` denomination.
- **Base Case:** `dp[0] = 0`.

---
#### a) Memoization (Top-Down)
```python
def coin_change_min_memo(coins: list[int], amount: int) -> int:
    dp = {}
    def solve(rem_amount):
        if rem_amount == 0: return 0
        if rem_amount < 0: return float('inf')
        if rem_amount in dp: return dp[rem_amount]

        min_coins = float('inf')
        for coin in coins:
            res = solve(rem_amount - coin)
            if res != float('inf'):
                min_coins = min(min_coins, 1 + res)

        dp[rem_amount] = min_coins
        return min_coins

    result = solve(amount)
    return result if result != float('inf') else -1
```
- **Time Complexity:** O(amount * len(coins)).
- **Space Complexity:** O(amount) for DP table + O(amount) for recursion stack.

---
#### b) Tabulation (Bottom-Up)
```python
def coin_change_min_tab(coins: list[int], amount: int) -> int:
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0

    for i in range(1, amount + 1):
        for coin in coins:
            if i >= coin:
                dp[i] = min(dp[i], 1 + dp[i - coin])

    return dp[amount] if dp[amount] != float('inf') else -1
```
- **Time Complexity:** O(amount * len(coins)).
- **Space Complexity:** O(amount).

---

### 3. Coin Change II (Number of Combinations)
`[MEDIUM]` `#unbounded-knapsack` `#coin-change` `#count-combinations`

#### Problem Statement
Given coins and an `amount`, find the number of **combinations** of coins that make up that amount.

#### Recurrence Relation
Let `dp[i]` = number of ways to make sum `i`. To avoid counting permutations, we process one coin at a time.
- For each `coin`, we update the `dp` array: **`dp[j] = dp[j] + dp[j - coin]`**.

---
#### a) Tabulation (Bottom-Up)
The tabulation approach is the most natural for this problem. The order of loops is crucial for counting combinations instead of permutations.

```python
def coin_change_combinations_tab(amount: int, coins: list[int]) -> int:
    dp = [0] * (amount + 1)
    dp[0] = 1 # Base case: one way to make sum 0 (by choosing no coins)

    # Outer loop for coins ensures we count combinations
    for coin in coins:
        for j in range(coin, amount + 1):
            dp[j] += dp[j - coin]

    return dp[amount]
```
- **Time Complexity:** O(amount * len(coins)).
- **Space Complexity:** O(amount).

---

### 4. Rod Cutting Problem
`[MEDIUM]` `#unbounded-knapsack`

#### Problem Statement
Given a rod of length `n` and prices for pieces of different lengths, find the maximum value obtainable by cutting the rod.

#### Implementation Overview
This is an unbounded knapsack problem where rod length is capacity, piece lengths are weights, and prices are values.
- **DP State:** `dp[i]` = max profit from a rod of length `i`.
- **Recurrence:** `dp[i] = max(prices[j-1] + dp[i-j])` for all cut lengths `j` from 1 to `i`.

---
#### a) Tabulation (Bottom-Up)
```python
def rod_cutting_tab(prices: list[int], n: int) -> int:
    # Let lengths be 1-based for easier mapping
    lengths = [i + 1 for i in range(len(prices))]
    dp = [0] * (n + 1)

    for i in range(1, n + 1):
        for j in range(len(lengths)):
            if lengths[j] <= i:
                dp[i] = max(dp[i], prices[j] + dp[i - lengths[j]])

    return dp[n]
```
- **Time Complexity:** O(n * len(prices)).
- **Space Complexity:** O(n).
