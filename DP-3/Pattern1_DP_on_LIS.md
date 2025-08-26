# Pattern 1: DP on LIS (Longest Increasing Subsequence)

The Longest Increasing Subsequence (LIS) pattern is a fundamental DP concept used to find the longest subsequence of a given sequence in which the subsequence's elements are in sorted order, lowest to highest. A wide variety of problems can be solved by reducing them to LIS. The standard DP solution is O(n^2), but a more advanced and common version uses binary search for an O(n log n) solution.

---

### 1. Longest Increasing Subsequence
`[MEDIUM]` `#lis` `#dp` `#binary-search`

#### Problem Statement
Given an integer array `nums`, return the length of the longest strictly increasing subsequence.

*Example:* `nums = [10,9,2,5,3,7,101,18]`. **Output:** `4` (LIS is [2,3,7,101]).

#### Implementation Overview (O(n log n) Binary Search)
This efficient approach maintains an auxiliary array `sub` which stores the smallest tail of all increasing subsequences with length `i+1` at `sub[i]`.
-   Iterate through each number `num` in `nums`.
-   If `num` is greater than the last element in `sub`, it extends the LIS. Append `num` to `sub`.
-   If `num` is not greater, it might form a new, shorter subsequence with a smaller tail. Find the smallest element in `sub` that is greater than or equal to `num` (using binary search) and replace it with `num`. This improves the potential for future subsequences.
-   The length of the `sub` array at the end is the length of the LIS.

#### Python Code Snippet
```python
import bisect
def length_of_lis(nums: list[int]) -> int:
    # sub[i] is the smallest tail of all increasing subsequences of length i+1
    sub = []
    for num in nums:
        # Find the first element in sub that is not less than num
        idx = bisect.bisect_left(sub, num)
        if idx == len(sub):
            # num is greater than all elements in sub, extend the LIS
            sub.append(num)
        else:
            # Replace the element at idx with num to have a smaller tail
            sub[idx] = num
    return len(sub)
```

---

### 2. Printing Longest Increasing Subsequence
`[MEDIUM]` `#lis` `#dp` `#backtracking`

#### Problem Statement
Given an integer array `nums`, find and print one of its longest increasing subsequences.

#### Implementation Overview
1.  Solve for the lengths of LIS ending at each index using the O(n^2) DP approach. Store these in a `dp` array.
2.  While filling the `dp` table, also use a `parent` array. `parent[i]` stores the index `j` of the previous element in the LIS ending at `i`.
3.  Find the index `last_idx` where the maximum value in `dp` occurs. This is the end of an LIS.
4.  Backtrack from `last_idx` using the `parent` array to reconstruct the LIS.

#### Python Code Snippet
```python
def print_lis(nums: list[int]) -> list[int]:
    n = len(nums)
    if n == 0: return []

    dp = [1] * n
    parent = [-1] * n
    max_len, last_idx = 1, 0

    for i in range(1, n):
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

---

### 3. Largest Divisible Subset
`[MEDIUM]` `#lis-variant` `#dp`

#### Problem Statement
Given a set of distinct positive integers `nums`, return the largest subset `answer` such that for every pair `(ans[i], ans[j])`, either `ans[i] % ans[j] == 0` or `ans[j] % ans[i] == 0`.

*Example:* `nums = [1,2,4,8]`. **Output:** `[1,2,4,8]`.

#### Implementation Overview
This is a variation of LIS.
1.  **Sort `nums`**. This is crucial. The divisibility check now only needs to be `nums[i] % nums[j] == 0` for `j < i`.
2.  The problem is now to find the longest subsequence where each element is divisible by the previous one. This is structurally identical to printing the LIS.
3.  Use the O(n^2) LIS algorithm with the divisibility check and a `parent` array to reconstruct the subset.

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

---

### 4. Longest String Chain
`[MEDIUM]` `#lis-variant` `#dp` `#string`

#### Problem Statement
You are given an array of `words`. A word chain is a sequence where `word_{i+1}` is a predecessor of `word_i` (formed by adding exactly one letter anywhere). Find the length of the longest possible word chain.

*Example:* `words = ["a","b","ba","bca","bda","bdca"]`. **Output:** `4` ("a" -> "ba" -> "bda" -> "bdca").

#### Implementation Overview
This is another LIS variation.
1.  **Sort `words` by length**. This ensures predecessors appear before their successors.
2.  **DP State:** `dp[i]` = length of the longest word chain ending with `words[i]`.
3.  **Recurrence:** `dp[i] = 1 + max(dp[j])` for all `j < i` where `words[j]` is a predecessor of `words[i]`.

#### Python Code Snippet
```python
def longest_str_chain(words: list[str]) -> int:
    words.sort(key=len)
    dp = {} # Using a dict for {word: max_chain_len} is easier
    max_chain = 0

    for word in words:
        current_len = 1
        # Check all possible predecessors by removing one character
        for i in range(len(word)):
            predecessor = word[:i] + word[i+1:]
            if predecessor in dp:
                current_len = max(current_len, dp[predecessor] + 1)
        dp[word] = current_len
        max_chain = max(max_chain, current_len)

    return max_chain
```

---

### 5. Longest Bitonic Subsequence
`[MEDIUM]` `#lis-variant` `#dp`

#### Problem Statement
Given an integer array `nums`, return the length of the longest bitonic subsequence. A bitonic subsequence is first strictly increasing, then strictly decreasing.

*Example:* `nums = [1,11,2,10,4,5,2,1]`. **Output:** `6` ([1,2,4,5,2,1]).

#### Implementation Overview
1.  `dp1[i]`: Length of the LIS ending at `i` (from left-to-right).
2.  `dp2[i]`: Length of the LIS ending at `i` but calculated from right-to-left (this is equivalent to the longest decreasing subsequence ending at `i`).
3.  The length of a bitonic sequence with `nums[i]` as the peak is `dp1[i] + dp2[i] - 1`.
4.  The answer is the maximum of this value over all `i`.

#### Python Code Snippet
```python
def longest_bitonic_subsequence(nums: list[int]) -> int:
    n = len(nums)
    if n == 0: return 0

    # LIS from left to right
    dp1 = [1] * n
    for i in range(n):
        for j in range(i):
            if nums[i] > nums[j]:
                dp1[i] = max(dp1[i], 1 + dp1[j])

    # LIS from right to left (Longest Decreasing Subsequence)
    dp2 = [1] * n
    for i in range(n - 1, -1, -1):
        for j in range(n - 1, i, -1):
            if nums[i] > nums[j]:
                dp2[i] = max(dp2[i], 1 + dp2[j])

    max_bitonic = 0
    for i in range(n):
        max_bitonic = max(max_bitonic, dp1[i] + dp2[i] - 1)

    return max_bitonic
```

---

### 6. Number of Longest Increasing Subsequences
`[MEDIUM]` `#lis-variant` `#dp` `#count`

#### Problem Statement
Given an integer array `nums`, return the number of longest increasing subsequences.

*Example:* `nums = [1,3,5,4,7]`. **Output:** `2` (LIS are [1,3,4,7] and [1,3,5,7]).

#### Implementation Overview
-   **DP State:** We need two DP arrays:
    1.  `length[i]`: The length of the LIS ending at `nums[i]`.
    2.  `count[i]`: The number of distinct LIS that end at `nums[i]`.
-   **Recurrence:** For each `i`, iterate `j` from `0` to `i-1`:
    -   If `nums[i] > nums[j]`:
        -   If `length[j] + 1 > length[i]`: We've found a new, longer LIS. Update `length[i]` and reset `count[i] = count[j]`.
        -   If `length[j] + 1 == length[i]`: We've found another LIS of the same max length. Add its ways: `count[i] += count[j]`.
-   **Final Answer:** Find `max_len`. The answer is the sum of `count[k]` for all `k` where `length[k] == max_len`.

#### Python Code Snippet
```python
def find_number_of_lis(nums: list[int]) -> int:
    n = len(nums)
    if n == 0: return 0

    length = [1] * n
    count = [1] * n

    for i in range(n):
        for j in range(i):
            if nums[i] > nums[j]:
                if length[j] + 1 > length[i]:
                    length[i] = length[j] + 1
                    count[i] = count[j] # Reset count
                elif length[j] + 1 == length[i]:
                    count[i] += count[j] # Add ways

    max_len = max(length)
    result = 0
    for i in range(n):
        if length[i] == max_len:
            result += count[i]

    return result
```
