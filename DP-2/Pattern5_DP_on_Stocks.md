# Pattern 5: DP on Stocks

The "DP on Stocks" pattern is a series of problems that involve maximizing profit from buying and selling stocks under various constraints. While some of the simpler versions can be solved with a greedy approach, the DP framework is powerful because it can be systematically extended to handle more complex rules like transaction limits, cooldowns, and fees. The core idea is to define a state at each day `i` based on whether we are holding a stock or not.

---

### 1. Best Time to Buy and Sell Stock (DP-35)
`[HARD]` `#dp-on-stocks`

#### Problem Statement
You are given an array `prices` where `prices[i]` is the price of a given stock on the `i`-th day. You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

#### Implementation Overview
While the optimal solution is a simple greedy approach (keep track of `min_price_so_far` and calculate `max_profit`), it can be framed as a DP problem, which helps build the foundation for more complex variations.
-   **DP State:** `dp[i][0]` = max profit at day `i` holding no stock. `dp[i][1]` = max profit at day `i` holding one stock.
-   **Recurrence Relation:**
    -   `dp[i][0] = max(dp[i-1][0], dp[i-1][1] + prices[i])` (Either did nothing, or sold the stock held yesterday).
    -   `dp[i][1] = max(dp[i-1][1], -prices[i])` (Either did nothing, or bought the stock today. Since it's the first transaction, profit is negative price).
-   **Final Answer:** `dp[n-1][0]`.

---

### 2. Buy and Sell Stock - II (DP-36)
`[HARD]` `#dp-on-stocks`

#### Problem Statement
You are given an array `prices`. On each day, you can decide to buy and/or sell the stock. You can hold at most one share of the stock at any time. However, you can buy it then immediately sell it on the same day. Find the maximum profit you can achieve. (Essentially, infinite transactions are allowed).

#### Implementation Overview
This can be solved greedily by adding up all positive price differences (`prices[i] - prices[i-1]`). The DP formulation is a good exercise.
-   **DP State:** `dp[i][0]` (cash, no stock), `dp[i][1]` (holding stock).
-   **Recurrence Relation:**
    -   `dp[i][0] = max(dp[i-1][0], dp[i-1][1] + prices[i])` (rest, or sell).
    -   `dp[i][1] = max(dp[i-1][1], dp[i-1][0] - prices[i])` (rest, or buy).
-   **Base Case:** `dp[0][0] = 0`, `dp[0][1] = -prices[0]`.

---

### 3. Buy and Sell Stock - III (DP-37)
`[HARD]` `#dp-on-stocks`

#### Problem Statement
Find the maximum profit you can achieve. You may complete **at most two transactions**.

#### Implementation Overview
The state must now include the number of transactions completed.
-   **DP State:** `dp[i][k][s]` = max profit on day `i` having completed `k` transactions, with state `s` (0 for no stock, 1 for holding stock).
-   A more intuitive state can be a 1D DP array of size 4 representing the states: `buy1`, `sell1`, `buy2`, `sell2`.
    -   `buy1`: Max profit after the first buy.
    -   `sell1`: Max profit after the first sell.
    -   `buy2`: Max profit after the second buy.
    -   `sell2`: Max profit after the second sell.
-   **Recurrence (1D DP):** Iterate through prices:
    -   `buy1 = max(buy1, -price)`
    -   `sell1 = max(sell1, buy1 + price)`
    -   `buy2 = max(buy2, sell1 - price)`
    -   `sell2 = max(sell2, buy2 + price)`
-   **Final Answer:** `sell2`.

---

### 4. Buy and Sell Stock - IV (DP-38)
`[HARD]` `#dp-on-stocks`

#### Problem Statement
Find the maximum profit you can achieve. You may complete **at most k transactions**.

#### Implementation Overview
This is a generalization of Part III.
-   **DP State:** Use a DP array `dp[j]` of size `2k`, where `dp[j]` with even `j` represents the max profit after the `j/2`-th sell, and odd `j` represents the max profit after the `(j+1)/2`-th buy.
-   **Recurrence:**
    -   `dp[j] = max(dp[j], dp[j-1] - price)` for buys (odd `j`).
    -   `dp[j] = max(dp[j], dp[j-1] + price)` for sells (even `j`).
-   **Final Answer:** `dp[2k-1]` (if `k>0`).
-   **Optimization:** If `k >= n/2`, the problem is equivalent to Part II (infinite transactions), which can be solved greedily in O(n). This avoids creating a potentially huge DP table.

---

### 5. Buy and Sell Stock With Cooldown (DP-39)
`[HARD]` `#dp-on-stocks` `#cooldown`

#### Problem Statement
You may complete as many transactions as you like, but you must observe a one-day cooldown period after you sell. You cannot buy on the day immediately following a sale.

#### Implementation Overview
The state machine needs to be expanded to include a "cooldown" state.
-   **States on day `i`:**
    1.  `held`: Max profit if holding a stock.
    2.  `sold`: Max profit if you just sold a stock today.
    3.  `rest`: Max profit if you are not holding a stock and are not in cooldown (free to buy).
-   **Recurrence:**
    -   `held[i] = max(held[i-1], rest[i-1] - prices[i])` (Hold previous stock, or buy from a rested state).
    -   `sold[i] = held[i-1] + prices[i]` (Must have held a stock yesterday to sell today).
    -   `rest[i] = max(rest[i-1], sold[i-1])` (Rest again, or come out of the cooldown state from yesterday's sale).
-   **Space Optimization:** Each state only depends on the previous day's states, so this can be optimized to O(1) space.

---

### 6. Buy and Sell Stock With Transaction Fee (DP-40)
`[HARD]` `#dp-on-stocks` `#fee`

#### Problem Statement
You may complete as many transactions as you like, but you need to pay a transaction fee for each transaction. The fee is paid once per buy-sell pair.

#### Implementation Overview
This is a small modification to the "infinite transactions" problem (Part II).
-   **DP State:** `dp[i][0]` (cash, no stock), `dp[i][1]` (holding stock).
-   **Recurrence Relation:** The fee can be applied either at the time of buying or selling. Applying it at selling is common.
    -   `dp[i][0] = max(dp[i-1][0], dp[i-1][1] + prices[i] - fee)` (Rest, or sell and pay the fee).
    -   `dp[i][1] = max(dp[i-1][1], dp[i-1][0] - prices[i])` (Rest, or buy).
-   **Base Case:** `dp[0][0] = 0`, `dp[0][1] = -prices[0]`.
-   **Final Answer:** `dp[n-1][0]`.
