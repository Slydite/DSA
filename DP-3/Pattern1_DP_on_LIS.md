# Pattern 1: DP on LIS (Longest Increasing Subsequence)

The Longest Increasing Subsequence (LIS) pattern is a fundamental DP concept used to find the longest subsequence of a given sequence where the elements are sorted in increasing order. A wide variety of problems can be solved by reducing them to LIS.

---

### 1. Longest Increasing Subsequence
`[MEDIUM]` `#lis` `#dp` `#binary-search`

#### Problem Statement
Given an integer array `nums`, return the length of the longest strictly increasing subsequence.

#### Recurrence Relation
Let `solve(index, prev_index)` be the length of the LIS from `nums[index...]` where the previous element chosen was at `prev_index`.
- **Choice 1 (Pick):** If `nums[index] > nums[prev_index]`, we can pick it. Length is `1 + solve(index + 1, index)`.
- **Choice 2 (Don't Pick):** We skip `nums[index]`. Length is `solve(index + 1, prev_index)`.
- We take the max of these choices. The state is `(index, prev_index)`, leading to an O(n^2) DP table.

---
#### a) Memoization (Top-Down O(n^2))
```python
def length_of_lis_memo(nums: list[int]) -> int:
    n = len(nums)
    dp = [[-1] * (n + 1) for _ in range(n)]

    def solve(index, prev_index):
        if index == n:
            return 0
        if dp[index][prev_index + 1] != -1:
            return dp[index][prev_index + 1]

        # Don't pick current element
        length = solve(index + 1, prev_index)

        # Pick current element (if valid)
        if prev_index == -1 or nums[index] > nums[prev_index]:
            length = max(length, 1 + solve(index + 1, index))

        dp[index][prev_index + 1] = length
        return length

    return solve(0, -1)
```
- **Time Complexity:** O(n^2). Each state `dp[i][j]` is computed once.
- **Space Complexity:** O(n^2) for DP table + O(n) for recursion stack.

---
#### b) Tabulation (Bottom-Up O(n^2))
A more intuitive tabulation approach uses `dp[i]` to store the length of the LIS ending at index `i`.

```python
def length_of_lis_tab(nums: list[int]) -> int:
    n = len(nums)
    if n == 0: return 0
    dp = [1] * n # dp[i] = length of LIS ending at index i

    for i in range(n):
        for prev in range(i):
            if nums[i] > nums[prev]:
                dp[i] = max(dp[i], 1 + dp[prev])

    return max(dp)
```
- **Time Complexity:** O(n^2) for the nested loops.
- **Space Complexity:** O(n) for the DP array.

---
#### c) Advanced Solution (O(n log n) with Binary Search)
This approach maintains an auxiliary array `sub` which stores the smallest tail of all increasing subsequences of a given length.

```python
import bisect
def length_of_lis_optimized(nums: list[int]) -> int:
    sub = []
    for num in nums:
        idx = bisect.bisect_left(sub, num)
        if idx == len(sub):
            sub.append(num)
        else:
            sub[idx] = num
    return len(sub)
```
- **Time Complexity:** O(n log n). The loop runs n times, and each binary search (`bisect_left`) takes O(log n).
- **Space Complexity:** O(n) for the `sub` array.

---

### 2. Printing Longest Increasing Subsequence
`[MEDIUM]` `#lis` `#dp` `#backtracking`

#### Problem Statement
Given an integer array `nums`, find and print one of its longest increasing subsequences.

#### Implementation Overview
This requires the O(n^2) tabulation approach, augmented with a `parent` array to reconstruct the path.
1.  Use the O(n^2) tabulation to fill a `dp` array (`dp[i]` = LIS length ending at `i`).
2.  While filling `dp`, also fill a `parent` array. When `dp[i]` is updated by `1 + dp[j]`, set `parent[i] = j`.
3.  Find the index `last_idx` where the maximum value in `dp` occurs. This is the end of an LIS.
4.  Backtrack from `last_idx` using the `parent` array to reconstruct the LIS.

#### Python Code Snippet
```python
def print_lis(nums: list[int]) -> list[int]:
    n = len(nums)
    if n == 0: return []

    dp = [1] * n
    parent = [-1] * n
    max_len, last_idx = 0, 0

    for i in range(n):
        for j in range(i):
            if nums[i] > nums[j] and dp[i] < 1 + dp[j]:
                dp[i] = 1 + dp[j]
                parent[i] = j
        if dp[i] > max_len:
            max_len = dp[i]
            last_idx = i

    lis = []
    while last_idx != -1:
        lis.append(nums[last_idx])
        last_idx = parent[last_idx]

    return lis[::-1]
```
- **Time Complexity:** O(n^2).
- **Space Complexity:** O(n).

---

### 3. Largest Divisible Subset
`[MEDIUM]` `#lis-variant` `#dp`

#### Problem Statement
Given a set of distinct positive integers `nums`, return the largest subset where for every pair `(a, b)`, either `a % b == 0` or `b % a == 0`.

#### Implementation Overview
This is an LIS variation. The "increasing" property is replaced by a "divisibility" property.
1.  **Sort `nums`**. This is crucial. Now we only need to check `nums[i] % nums[j] == 0` for `j < i`.
2.  The problem becomes finding the longest subsequence where each element is divisible by the previous one.
3.  This is structurally identical to "Printing LIS". Use the same O(n^2) DP approach with the parent tracking.

#### Python Code Snippet
```python
def largest_divisible_subset(nums: list[int]) -> list[int]:
    n = len(nums)
    if n == 0: return []
    nums.sort()

    dp = [1] * n
    parent = [-1] * n
    max_len, last_idx = 1, 0

    for i in range(n):
        for j in range(i):
            if nums[i] % nums[j] == 0 and dp[i] < 1 + dp[j]:
                dp[i] = 1 + dp[j]
                parent[i] = j
        if dp[i] > max_len:
            max_len = dp[i]
            last_idx = i

    lds = []
    while last_idx != -1:
        lds.append(nums[last_idx])
        last_idx = parent[last_idx]

    return lds[::-1]
```
- **Time Complexity:** O(n^2).
- **Space Complexity:** O(n).

---

### 4. Longest String Chain
`[MEDIUM]` `#lis-variant` `#dp` `#string`

#### Problem Statement
Given `words`, find the length of the longest "word chain," where `word_i` is a predecessor of `word_{i+1}` (formed by deleting one letter).

#### Implementation Overview
1.  **Sort `words` by length**. This ensures we process potential predecessors before their successors.
2.  **DP State:** `dp[word]` = length of the longest chain ending with `word`. A hash map is ideal for this.
3.  **Recurrence:** For each `word`, generate all its possible predecessors by deleting one character. The longest chain for `word` is `1 + max(dp[predecessor])` over all valid predecessors found in the map.

#### Python Code Snippet
```python
def longest_str_chain(words: list[str]) -> int:
    words.sort(key=len)
    dp = {} # {word: max_chain_len}
    max_chain = 0

    for word in words:
        current_len = 1
        # Generate all possible predecessors
        for i in range(len(word)):
            predecessor = word[:i] + word[i+1:]
            if predecessor in dp:
                current_len = max(current_len, dp[predecessor] + 1)
        dp[word] = current_len
        max_chain = max(max_chain, current_len)

    return max_chain
```
- **Time Complexity:** O(N * L^2), where N is the number of words and L is the max word length. Sorting is O(N log N).
- **Space Complexity:** O(N * L) to store the DP map.

---

### 5. Longest Bitonic Subsequence
`[MEDIUM]` `#lis-variant` `#dp`

#### Problem Statement
Find the length of the longest bitonic subsequence (first increasing, then decreasing).

#### Implementation Overview
A bitonic subsequence has a "peak". We can find the longest one by considering every element as a potential peak.
1.  **`dp1[i]`**: Length of the LIS ending at `i` (calculated from left-to-right).
2.  **`dp2[i]`**: Length of the Longest Decreasing Subsequence (LDS) starting at `i` (or LIS from right-to-left).
3.  For each `i`, a bitonic sequence with `nums[i]` as the peak has length `dp1[i] + dp2[i] - 1`. The `-1` is because `nums[i]` is counted in both.
4.  The answer is the maximum of this value over all `i`.

#### Python Code Snippet
```python
def longest_bitonic_subsequence(nums: list[int]) -> int:
    n = len(nums)
    if n == 0: return 0

    # dp1[i]: LIS ending at i (left-to-right)
    dp1 = [1] * n
    for i in range(n):
        for j in range(i):
            if nums[i] > nums[j]:
                dp1[i] = max(dp1[i], 1 + dp1[j])

    # dp2[i]: LIS ending at i (right-to-left)
    dp2 = [1] * n
    for i in range(n - 1, -1, -1):
        for j in range(n - 1, i, -1):
            if nums[i] > nums[j]:
                dp2[i] = max(dp2[i], 1 + dp2[j])

    max_val = 0
    for i in range(n):
        # Peak must have elements on both sides, so dp1[i] and dp2[i] should be > 1
        # but the formula works even if one side is empty.
        max_val = max(max_val, dp1[i] + dp2[i] - 1)

    return max_val
```
- **Time Complexity:** O(n^2) due to the two nested loops for calculating `dp1` and `dp2`.
- **Space Complexity:** O(n) for the two DP arrays.

---

### 6. Number of Longest Increasing Subsequences
`[MEDIUM]` `#lis-variant` `#dp` `#count`

#### Problem Statement
Given an array, return the number of longest increasing subsequences.

#### Implementation Overview
We need to track not just the length of LIS ending at `i`, but also the count of such subsequences.
- **DP State:**
    - `length[i]`: The length of the LIS ending at `nums[i]`.
    - `count[i]`: The number of distinct LIS that end at `nums[i]`.
- **Recurrence:** For each `i`, iterate `j` from `0` to `i-1`:
    - If `nums[i] > nums[j]`:
        - If `length[j] + 1 > length[i]`: We've found a new, longer LIS. Update `length[i]` and reset the count: `count[i] = count[j]`.
        - If `length[j] + 1 == length[i]`: We've found another LIS of the same max length. Add its ways: `count[i] += count[j]`.
- **Final Answer:** Find the `max_len` across the `length` array. The answer is the sum of `count[k]` for all `k` where `length[k] == max_len`.

#### Python Code Snippet
```python
def find_number_of_lis(nums: list[int]) -> int:
    n = len(nums)
    if n <= 1: return n

    length = [1] * n # length[i] = length of LIS ending at i
    count = [1] * n  # count[i] = number of LIS ending at i

    for i in range(n):
        for j in range(i):
            if nums[i] > nums[j]:
                if length[j] + 1 > length[i]:
                    length[i] = length[j] + 1
                    count[i] = count[j]
                elif length[j] + 1 == length[i]:
                    count[i] += count[j]

    max_len = max(length)
    result = 0
    for i in range(n):
        if length[i] == max_len:
            result += count[i]

    return result
```
- **Time Complexity:** O(n^2).
- **Space Complexity:** O(n).
