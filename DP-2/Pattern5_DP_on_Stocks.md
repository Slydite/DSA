# Pattern 5: DP on Stocks

The "DP on Stocks" pattern is a series of problems that involve maximizing profit from buying and selling stocks under various constraints. The core idea is to define a state at each day `i` based on whether we are holding a stock or not (`can_buy`). This state can be extended to include transaction counts, cooldowns, etc.

**General Recurrence Relation:**
Let `solve(index, can_buy)` be the max profit from `index` onwards.
- If `can_buy`:
    - **Choice 1 (Buy):** `-prices[index] + solve(index + 1, cannot_buy)`
    - **Choice 2 (Skip):** `0 + solve(index + 1, can_buy)`
    - We take `max(Choice1, Choice2)`.
- If `cannot_buy`:
    - **Choice 1 (Sell):** `prices[index] + solve(index + 1, can_buy)` (plus any fees/cooldowns)
    - **Choice 2 (Skip):** `0 + solve(index + 1, cannot_buy)`
    - We take `max(Choice1, Choice2)`.

---

### 1. Best Time to Buy and Sell Stock
`[EASY]` `#dp-on-stocks` `#greedy`

#### Problem Statement
Maximize profit with a **single transaction** (one buy, one sell).

#### Implementation Overview
While a simple greedy approach is most efficient (O(n) time, O(1) space), this problem can be framed with DP to show the foundational thinking. However, the greedy solution is standard and preferred.

```python
# Greedy Solution
def max_profit_one_transaction(prices: list[int]) -> int:
    min_price = float('inf')
    max_profit = 0
    for price in prices:
        min_price = min(min_price, price)
        max_profit = max(max_profit, price - min_price)
    return max_profit
```
- **Time Complexity:** O(n).
- **Space Complexity:** O(1).

---

### 2. Best Time to Buy and Sell Stock II
`[MEDIUM]` `#dp-on-stocks` `#greedy`

#### Problem Statement
Maximize profit with **infinite transactions**.

#### Recurrence Relation
`solve(index, can_buy)`:
- `can_buy`: `max(-prices[index] + solve(index+1, 0), solve(index+1, 1))`
- `!can_buy`: `max(prices[index] + solve(index+1, 1), solve(index+1, 0))`

---
#### a) Memoization (Top-Down)
```python
def max_profit_infinite_memo(prices: list[int]) -> int:
    n = len(prices)
    dp = [[-1] * 2 for _ in range(n)]

    def solve(index, can_buy):
        if index == n: return 0
        if dp[index][can_buy] != -1: return dp[index][can_buy]

        if can_buy:
            buy_profit = -prices[index] + solve(index + 1, 0)
            skip_profit = solve(index + 1, 1)
            dp[index][can_buy] = max(buy_profit, skip_profit)
        else:
            sell_profit = prices[index] + solve(index + 1, 1)
            skip_profit = solve(index + 1, 0)
            dp[index][can_buy] = max(sell_profit, skip_profit)

        return dp[index][can_buy]

    return solve(0, 1)
```
- **Time Complexity:** O(n * 2) ~ O(n).
- **Space Complexity:** O(n * 2) for DP table + O(n) for recursion stack.

---
#### b) Space Optimization
```python
def max_profit_infinite_optimized(prices: list[int]) -> int:
    n = len(prices)
    ahead_can_buy, ahead_cannot_buy = 0, 0

    for i in range(n - 1, -1, -1):
        # Current state depends on 'ahead' state
        curr_can_buy = max(-prices[i] + ahead_cannot_buy, ahead_can_buy)
        curr_cannot_buy = max(prices[i] + ahead_can_buy, ahead_cannot_buy)

        ahead_can_buy = curr_can_buy
        ahead_cannot_buy = curr_cannot_buy

    return ahead_can_buy
```
- **Time Complexity:** O(n).
- **Space Complexity:** O(1).

---

### 3. Best Time to Buy and Sell Stock III
`[HARD]` `#dp-on-stocks`

#### Problem Statement
Maximize profit with **at most two transactions**.

#### Recurrence Relation
The state must now include the transaction count.
`solve(index, can_buy, transactions_left)`

---
#### a) Tabulation (Bottom-Up)
A 3D DP table `dp[index][can_buy][transactions]` can be used. A more common and intuitive tabulation uses a 2D array `dp[k][day]` or tracks the 4 states (buy1, sell1, buy2, sell2).

```python
def max_profit_two_transactions_tab(prices: list[int]) -> int:
    n = len(prices)
    # dp[day][transaction_state]
    # States: 0:buy1, 1:sell1, 2:buy2, 3:sell2
    dp = [[0] * 4 for _ in range(n)]

    dp[0][0] = -prices[0] # buy1
    dp[0][2] = -prices[0] # buy2

    for i in range(1, n):
        # State 0: First Buy
        dp[i][0] = max(dp[i-1][0], -prices[i])
        # State 1: First Sell
        dp[i][1] = max(dp[i-1][1], dp[i-1][0] + prices[i])
        # State 2: Second Buy
        dp[i][2] = max(dp[i-1][2], dp[i-1][1] - prices[i])
        # State 3: Second Sell
        dp[i][3] = max(dp[i-1][3], dp[i-1][2] + prices[i])

    return dp[n-1][3]
```
- **Time Complexity:** O(n * 4) ~ O(n).
- **Space Complexity:** O(n * 4) ~ O(n).

---
#### b) Space Optimization
```python
def max_profit_two_transactions_optimized(prices: list[int]) -> int:
    buy1, sell1 = float('-inf'), 0
    buy2, sell2 = float('-inf'), 0

    for price in prices:
        buy1 = max(buy1, -price)
        sell1 = max(sell1, buy1 + price)
        buy2 = max(buy2, sell1 - price)
        sell2 = max(sell2, buy2 + price)

    return sell2
```
- **Time Complexity:** O(n).
- **Space Complexity:** O(1).

---

### 4. Best Time to Buy and Sell Stock with Cooldown
`[MEDIUM]` `#dp-on-stocks` `#cooldown`

#### Problem Statement
Maximize profit with infinite transactions, but with a one-day cooldown after selling.

#### Recurrence Relation
`solve(index, can_buy)`:
- `can_buy`: `max(-prices[index] + solve(index+1, 0), solve(index+1, 1))`
- `!can_buy`: The sell choice now forces a cooldown. `max(prices[index] + solve(index+2, 1), solve(index+1, 0))`. `index+2` skips one day.

---
#### a) Memoization (Top-Down)
```python
def max_profit_cooldown_memo(prices: list[int]) -> int:
    n = len(prices)
    dp = [[-1] * 2 for _ in range(n)]

    def solve(index, can_buy):
        if index >= n: return 0
        if dp[index][can_buy] != -1: return dp[index][can_buy]

        if can_buy:
            profit = max(-prices[index] + solve(index + 1, 0), solve(index + 1, 1))
        else:
            profit = max(prices[index] + solve(index + 2, 1), solve(index + 1, 0))

        dp[index][can_buy] = profit
        return profit

    return solve(0, 1)
```
- **Time/Space Complexity:** O(n).

---
#### b) Space Optimization
The state machine approach is cleanest here.
- `held`: Max profit ending today holding a stock.
- `sold`: Max profit ending today having just sold.
- `rest`: Max profit ending today being able to buy.

```python
def max_profit_cooldown_optimized(prices: list[int]) -> int:
    held, sold, rest = float('-inf'), 0, 0

    for price in prices:
        prev_sold = sold
        # Profit if we sell today
        sold = held + price
        # Profit if we hold stock today
        held = max(held, rest - price)
        # Profit if we rest today
        rest = max(rest, prev_sold)

    return max(sold, rest)
```
- **Time Complexity:** O(n).
- **Space Complexity:** O(1).

---

### 5. Best Time to Buy and Sell Stock with Transaction Fee
`[MEDIUM]` `#dp-on-stocks` `#fee`

#### Problem Statement
Maximize profit with infinite transactions, but pay a transaction `fee` for each completed transaction.

#### Recurrence Relation
`solve(index, can_buy)`:
- `can_buy`: `max(-prices[index] + solve(index+1, 0), solve(index+1, 1))`
- `!can_buy`: `max(prices[index] - fee + solve(index+1, 1), solve(index+1, 0))`. The fee is subtracted upon selling.

---
#### a) Memoization (Top-Down)
```python
def max_profit_fee_memo(prices: list[int], fee: int) -> int:
    n = len(prices)
    dp = [[-1] * 2 for _ in range(n)]

    def solve(index, can_buy):
        if index == n: return 0
        if dp[index][can_buy] != -1: return dp[index][can_buy]

        if can_buy:
            profit = max(-prices[index] + solve(index + 1, 0), solve(index + 1, 1))
        else:
            profit = max(prices[index] - fee + solve(index + 1, 1), solve(index + 1, 0))

        dp[index][can_buy] = profit
        return profit

    return solve(0, 1)
```
- **Time/Space Complexity:** O(n).

---
#### b) Space Optimization
```python
def max_profit_fee_optimized(prices: list[int], fee: int) -> int:
    n = len(prices)
    ahead_can_buy, ahead_cannot_buy = 0, 0

    for i in range(n - 1, -1, -1):
        # Max profit if I can buy today
        curr_can_buy = max(-prices[i] + ahead_cannot_buy, ahead_can_buy)
        # Max profit if I can sell today
        curr_cannot_buy = max(prices[i] - fee + ahead_can_buy, ahead_cannot_buy)

        ahead_can_buy = curr_can_buy
        ahead_cannot_buy = curr_cannot_buy

    return ahead_can_buy
```
- **Time Complexity:** O(n).
- **Space Complexity:** O(1).
