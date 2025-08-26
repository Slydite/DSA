# Pattern 5: DP on Stocks

The "DP on Stocks" pattern is a series of problems that involve maximizing profit from buying and selling stocks under various constraints. While some of the simpler versions can be solved with a greedy approach, the DP framework is powerful because it can be systematically extended to handle more complex rules like transaction limits, cooldowns, and fees. The core idea is to define a state at each day `i` based on whether we are holding a stock or not.

---

### 1. Best Time to Buy and Sell Stock
`[EASY]` `#dp-on-stocks` `#greedy`

#### Problem Statement
You are given an array `prices` where `prices[i]` is the price of a given stock on the `i`-th day. You want to maximize your profit by choosing a **single day** to buy one stock and choosing a **different day in the future** to sell that stock.

*Example:* `prices = [7,1,5,3,6,4]`. **Output:** `5` (Buy at 1, sell at 6).

#### Implementation Overview (Greedy)
The most efficient solution is a greedy one. We iterate through the prices, keeping track of the minimum price seen so far and the maximum profit we could have made.
1.  Initialize `min_price = float('inf')` and `max_profit = 0`.
2.  For each `price` in `prices`:
    -   Update `min_price = min(min_price, price)`.
    -   Calculate potential profit: `profit = price - min_price`.
    -   Update `max_profit = max(max_profit, profit)`.
3.  Return `max_profit`.

#### Python Code Snippet (Greedy)
```python
def max_profit_one_transaction(prices: list[int]) -> int:
    min_price = float('inf')
    max_profit = 0
    for price in prices:
        if price < min_price:
            min_price = price
        elif price - min_price > max_profit:
            max_profit = price - min_price
    return max_profit
```

---

### 2. Best Time to Buy and Sell Stock II
`[MEDIUM]` `#dp-on-stocks` `#greedy`

#### Problem Statement
You are given an array `prices`. On each day, you can decide to buy and/or sell the stock. You can hold at most one share at any time, but you can buy and then immediately sell it on the same day. Find the maximum profit you can achieve (infinite transactions are allowed).

*Example:* `prices = [7,1,5,3,6,4]`. **Output:** `7` (Buy at 1, sell at 5. Buy at 3, sell at 6. Profit = 4 + 3 = 7).

#### Implementation Overview (Greedy)
The key insight is that the total profit is the sum of all positive price changes from one day to the next. A long upward trend `(p3 - p0)` is mathematically the same as the sum of its smaller parts `(p1-p0) + (p2-p1) + (p3-p2)`.
1.  Initialize `total_profit = 0`.
2.  Iterate from the second day (`i=1`).
3.  If `prices[i] > prices[i-1]`, add the difference `prices[i] - prices[i-1]` to `total_profit`.

#### Python Code Snippet (Greedy)
```python
def max_profit_infinite_transactions(prices: list[int]) -> int:
    total_profit = 0
    for i in range(1, len(prices)):
        if prices[i] > prices[i-1]:
            total_profit += prices[i] - prices[i-1]
    return total_profit
```

---

### 3. Best Time to Buy and Sell Stock III
`[HARD]` `#dp-on-stocks`

#### Problem Statement
Find the maximum profit you can achieve. You may complete **at most two transactions**.

*Example:* `prices = [3,3,5,0,0,3,1,4]`. **Output:** `6` (Buy at 0, sell at 3. Buy at 1, sell at 4).

#### Implementation Overview
The state must now include the number of transactions. A very intuitive way to handle this is to track the state after each of the 4 possible actions: first buy, first sell, second buy, second sell.
-   `buy1`: Max profit after the first buy.
-   `sell1`: Max profit after the first sell.
-   `buy2`: Max profit after the second buy.
-   `sell2`: Max profit after the second sell.
Iterate through prices and update these four variables.

#### Python Code Snippet
```python
def max_profit_two_transactions(prices: list[int]) -> int:
    buy1, sell1 = float('-inf'), 0
    buy2, sell2 = float('-inf'), 0

    for price in prices:
        buy1 = max(buy1, -price)
        sell1 = max(sell1, buy1 + price)
        buy2 = max(buy2, sell1 - price)
        sell2 = max(sell2, buy2 + price)

    return sell2
```

---

### 4. Best Time to Buy and Sell Stock IV
`[HARD]` `#dp-on-stocks`

#### Problem Statement
Find the maximum profit you can achieve. You may complete **at most k transactions**.

#### Implementation Overview
This generalizes Part III. We can use a DP array of size `2k` to track the state after each buy and sell.
-   `dp[j]` with even `j` represents the max profit after the `j/2`-th sell.
-   `dp[j]` with odd `j` represents the max profit after the `(j+1)/2`-th buy.
-   **Optimization:** If `k >= n/2`, we can perform infinite transactions, so the problem reduces to Part II.

#### Python Code Snippet
```python
def max_profit_k_transactions(k: int, prices: list[int]) -> int:
    n = len(prices)
    if n == 0 or k == 0:
        return 0

    # If k is large enough, it's the same as infinite transactions
    if k >= n // 2:
        total_profit = 0
        for i in range(1, n):
            if prices[i] > prices[i-1]:
                total_profit += prices[i] - prices[i-1]
        return total_profit

    # dp[j] where j is even is a sell, odd is a buy
    dp = [float('-inf')] * (2 * k)

    for price in prices:
        for j in range(0, 2 * k, 2):
            # First buy
            dp[j] = max(dp[j], -price)
            # First sell
            dp[j+1] = max(dp[j+1], dp[j] + price)
            # Subsequent buys/sells
            if j > 0:
                dp[j] = max(dp[j], dp[j-1] - price)

    return int(dp[-1]) if dp[-1] != float('-inf') else 0

```

---

### 5. Best Time to Buy and Sell Stock with Cooldown
`[MEDIUM]` `#dp-on-stocks` `#cooldown`

#### Problem Statement
You may complete as many transactions as you like, but you must observe a one-day cooldown period after you sell. You cannot buy on the day immediately following a sale.

*Example:* `prices = [1,2,3,0,2]`. **Output:** `3` (Buy at 1, sell at 2. Buy at 0, sell at 2).

#### Implementation Overview
The state machine needs to track three states: holding a stock (`held`), having just sold (`sold`), and being able to buy (`rest`).
-   `held[i] = max(held[i-1], rest[i-1] - prices[i])`
-   `sold[i] = held[i-1] + prices[i]`
-   `rest[i] = max(rest[i-1], sold[i-1])`
This can be space-optimized to O(1).

#### Python Code Snippet (Space Optimized)
```python
def max_profit_with_cooldown(prices: list[int]) -> int:
    held_prev, sold_prev, rest_prev = float('-inf'), 0, 0

    for price in prices:
        held_curr = max(held_prev, rest_prev - price)
        sold_curr = held_prev + price
        rest_curr = max(rest_prev, sold_prev)

        held_prev, sold_prev, rest_prev = held_curr, sold_curr, rest_curr

    return max(sold_prev, rest_prev)
```

---

### 6. Best Time to Buy and Sell Stock with Transaction Fee
`[MEDIUM]` `#dp-on-stocks` `#fee`

#### Problem Statement
You may complete as many transactions as you like, but you need to pay a transaction fee for each complete transaction (one buy + one sell).

*Example:* `prices = [1,3,2,8,4,9]`, `fee = 2`. **Output:** `8`.

#### Implementation Overview
This is a small modification to the "infinite transactions" DP formulation.
-   **DP State:** `cash` (max profit holding no stock), `hold` (max profit holding one stock).
-   **Recurrence:** The fee can be applied either at buy or sell. Applying at sell is common.
    -   `cash = max(cash, hold + price - fee)` (Sell and pay fee).
    -   `hold = max(hold, cash - price)` (Buy).

#### Python Code Snippet (Space Optimized)
```python
def max_profit_with_fee(prices: list[int], fee: int) -> int:
    cash = 0 # Max profit if we don't have a stock
    hold = -prices[0] # Max profit if we do have a stock

    for i in range(1, len(prices)):
        # Today's cash is either yesterday's cash, or we sell today
        prev_cash = cash
        cash = max(cash, hold + prices[i] - fee)
        # Today's hold is either yesterday's hold, or we buy today
        hold = max(hold, prev_cash - prices[i])

    return cash
```
