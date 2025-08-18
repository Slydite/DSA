# Pattern 1: DP on LIS (Longest Increasing Subsequence)

The Longest Increasing Subsequence (LIS) pattern is a fundamental DP concept used to find the longest subsequence of a given sequence in which the subsequence's elements are in sorted order, lowest to highest. A wide variety of problems can be solved by reducing them to LIS. The standard DP solution is O(n^2), but a more advanced and common version uses binary search for an O(n log n) solution.

---

### 1. Longest Increasing Subsequence (DP-41, DP-43)
`[HARD]` `#lis` `#dp` `#binary-search`

#### Problem Statement
Given an integer array `nums`, return the length of the longest strictly increasing subsequence.

#### Implementation Overview

**O(n^2) DP Approach:**
-   **DP State:** `dp[i]` = the length of the LIS ending at index `i`.
-   **Recurrence Relation:** To calculate `dp[i]`, we look at all previous indices `j < i`. If `nums[i] > nums[j]`, it means we can potentially extend the LIS that ends at `j`. So, `dp[i] = max(dp[i], 1 + dp[j])`.
-   **Initialization:** `dp` array filled with 1s, as every element is an LIS of length 1.
-   **Final Answer:** The maximum value in the `dp` array after filling it.

**O(n log n) Binary Search Approach:**
This is a more efficient and clever approach. We maintain an auxiliary array (let's call it `tails` or `sub`) which stores the smallest tail of all increasing subsequences with length `i+1` at `tails[i]`.
-   Iterate through each number `num` in `nums`.
-   If `num` is greater than the last element in `tails`, it extends the longest subsequence we've found so far. Append `num` to `tails`.
-   If `num` is not greater, it might be able to form a new, shorter subsequence with a smaller tail. We find the smallest element in `tails` that is greater than or equal to `num` (using binary search, e.g., `bisect_left` in Python) and replace it with `num`. This makes the potential for future subsequences better without changing the lengths of existing ones.
-   The length of the `tails` array at the end is the length of the LIS.

---

### 2. Printing Longest Increasing Subsequence (DP-42)
`[HARD]` `#lis` `#dp` `#backtracking`

#### Problem Statement
Given an integer array `nums`, find and print one of its longest increasing subsequences.

#### Implementation Overview
1.  First, solve for the lengths of LIS ending at each index using the O(n^2) DP approach. Store these lengths in a `dp` array.
2.  While filling the `dp` table, also use a `hash` or `parent` array. `hash[i]` stores the index `j` of the previous element in the LIS ending at `i`.
3.  Find the index `last_index` where the maximum value in `dp` occurs. This is the end of an LIS.
4.  Backtrack from `last_index` using the `hash` array until you reach the start of the subsequence, collecting elements along the way. Reverse the collected elements to get the final LIS.

---

### 3. Largest Divisible Subset (DP-44)
`[HARD]` `#lis-variant` `#dp`

#### Problem Statement
Given a set of distinct positive integers `nums`, return the largest subset `answer` such that every pair `(answer[i], answer[j])` of elements in this subset satisfies `answer[i] % answer[j] == 0` or `answer[j] % answer[i] == 0`.

#### Implementation Overview
This is a variation of LIS.
1.  **Sort the input array `nums`**. This is crucial. After sorting, the divisibility condition only needs to be checked one way: `nums[i] % nums[j] == 0` for `j < i`.
2.  The problem now is to find the longest subsequence where each element is divisible by the previous one. This is structurally identical to LIS.
3.  Use the O(n^2) LIS algorithm:
    -   `dp[i]` = size of the largest divisible subset ending with `nums[i]`.
    -   The recurrence is `dp[i] = 1 + max(dp[j])` for all `j < i` where `nums[i] % nums[j] == 0`.
4.  Use a `hash`/`parent` array during the DP calculation to reconstruct the subset, just like in "Printing LIS".

---

### 4. Longest String Chain (DP-45)
`[HARD]` `#lis-variant` `#dp` `#string`

#### Problem Statement
You are given an array of `words`. A word chain is a sequence of words `[word1, word2, ..., wordk]` where `word_{i+1}` is a predecessor of `word_i` (formed by adding exactly one letter anywhere in `word_i`). Find the length of the longest possible word chain.

#### Implementation Overview
This is another LIS variation.
1.  **Sort the `words` array based on length**. This ensures that any predecessor of a word will appear before it in the sorted array.
2.  **DP State:** `dp[i]` = the length of the longest word chain ending with `words[i]`.
3.  **Recurrence:** For each `words[i]`, iterate through all previous words `words[j]` (`j < i`). If `words[j]` is a predecessor of `words[i]`, we can extend the chain. `dp[i] = max(dp[i], 1 + dp[j])`.
4.  A helper function is needed to check if one word is a predecessor of another. This can be done by comparing characters with two pointers.
5.  The answer is the maximum value in the `dp` array.

---

### 5. Longest Bitonic Subsequence (DP-46)
`[HARD]` `#lis-variant` `#dp`

#### Problem Statement
Given an integer array `nums`, return the length of the longest bitonic subsequence. A bitonic subsequence is a subsequence that is first strictly increasing and then strictly decreasing.

#### Implementation Overview
The peak of the bitonic sequence can be any element in the array.
1.  **Calculate LIS from left-to-right:** Create a `dp1[i]` array where `dp1[i]` stores the length of the LIS ending at index `i`.
2.  **Calculate LIS from right-to-left:** Create a `dp2[i]` array where `dp2[i]` stores the length of the LIS starting at index `i` and going to the right (this is equivalent to the length of the longest *decreasing* subsequence ending at `i`).
3.  For each index `i`, a potential bitonic subsequence with `nums[i]` as the peak has a length of `dp1[i] + dp2[i] - 1`. The `-1` is because `nums[i]` is counted in both subsequences.
4.  The answer is the maximum value of `dp1[i] + dp2[i] - 1` over all possible `i`.

---

### 6. Number of Longest Increasing Subsequences (DP-47)
`[HARD]` `#lis-variant` `#dp` `#count`

#### Problem Statement
Given an integer array `nums`, return the number of longest increasing subsequences.

#### Implementation Overview
This requires extending the standard LIS DP approach to keep track of counts as well as lengths.
-   **DP State:** We need two DP arrays of size `n`.
    1.  `length[i]`: The length of the LIS ending at `nums[i]`.
    2.  `count[i]`: The number of distinct LIS that end at `nums[i]`.
-   **Initialization:** `length` array with 1s, `count` array with 1s.
-   **Recurrence:** For each `i` from 0 to `n-1`, iterate `j` from 0 to `i-1`:
    -   If `nums[i] > nums[j]`:
        -   If `length[j] + 1 > length[i]`: We've found a longer LIS ending at `i`. Update `length[i] = length[j] + 1` and reset the count: `count[i] = count[j]`.
        -   If `length[j] + 1 == length[i]`: We've found another LIS of the same maximum length. Add its ways: `count[i] += count[j]`.
-   **Final Answer:** Find the `max_len` in the `length` array. The answer is the sum of `count[k]` for all indices `k` where `length[k] == max_len`.
