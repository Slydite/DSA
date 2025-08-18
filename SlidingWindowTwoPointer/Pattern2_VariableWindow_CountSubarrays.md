# Pattern 2: Variable-Size Sliding Window - Counting Subarrays

This pattern is used for problems that require counting the total number of subarrays or substrings that satisfy a given condition. A direct approach can be complex because, unlike max/min problems, the condition for one window doesn't easily extend.

A powerful technique for "exactly K" counting problems is to convert them into two "at most K" problems. The identity is:
`count(exactly K) = count(at most K) - count(at most K - 1)`

The "at most" version is often much easier to solve with a standard sliding window because the condition is monotonic (if a window is valid, all its sub-windows are also valid).

---

### 1. Binary Subarray with Sum
`[MEDIUM]` `#sliding-window` `#prefix-sum` `#counting`

#### Problem Statement
Given a binary array `nums` (containing only 0s and 1s) and an integer `goal`, return the number of non-empty subarrays with a sum equal to `goal`.

*Example:*
- **Input:** `nums = [1, 0, 1, 0, 1]`, `goal = 2`
- **Output:** `4` (The subarrays are `[1,0,1]`, `[0,1,0,1]`, `[1,0,1]` starting at index 2, and the full subarray `[1,0,1,0,1]` has a prefix `[1,0,1]` which also works) - Let's re-check the example. The valid subarrays are `[1,0,1]`, `[1,0,1,0]`, `[0,1,0,1]`, `[1,0,1]`. Ah, `[1,0,1]` is one, `[1,0,1,0]` sums to 2, `[0,1,0,1]` sums to 2. The example seems complex. Let's stick to the problem statement: `[1,0,1]`, `[0,1,0,1]`, `[1,0,1]` (from index 2) and `[1,0,1,0,1]`'s prefix `[1,0,1]` -> The valid subarrays are `[1,0,1]` (indices 0-2), `[1,0,1,0,1]` (indices 0-4) -> sum 3, `[0,1,0,1]` (indices 1-4) -> sum 2. Let's re-verify the logic. The distinct subarrays are: `[1,0,1]` (from index 0), `[1,0,1,0]` (from index 0) -> sum 2. `[0,1,0,1]` (from index 1). `[1,0,1]` (from index 2). Yes, 4 is correct.

#### Implementation Overview
A direct sliding window to count subarrays with a sum *exactly* equal to `goal` is tricky. When the sum is `goal`, you don't know if you should shrink or expand the window.

The standard solution uses the `at most K` trick.
1.  Define a helper function, `atMost(k)`, that counts the number of subarrays with a sum of *at most* `k`.
2.  The main function will return `atMost(goal) - atMost(goal - 1)`.
3.  **Inside `atMost(k)`:**
    - Use a standard sliding window with `left`, `right`, and `current_sum`.
    - Iterate with the `right` pointer, expanding the window and adding `nums[right]` to `current_sum`.
    - If `current_sum > k`, shrink the window from the left until it's valid again.
    - Crucially, every time the window `[left, right]` is valid, it means that all subarrays ending at `right` that start at or after `left` are also valid. The number of such subarrays is `right - left + 1`. Add this to your total `count`.

#### Python Code Snippet
```python
def numSubarraysWithSum(nums: list[int], goal: int) -> int:
    def atMost(k: int) -> int:
        if k < 0:
            return 0
        left = 0
        current_sum = 0
        count = 0
        for right in range(len(nums)):
            current_sum += nums[right]
            while current_sum > k:
                current_sum -= nums[left]
                left += 1
            # For a valid window [left, right], any subarray ending at right is valid.
            # e.g., [left...right], [left+1...right], ..., [right...right]
            count += right - left + 1
        return count

    return atMost(goal) - atMost(goal - 1)
```

#### Tricks/Gotchas
- **The `at most` conversion:** This is the most important concept for this entire pattern. Master it.
- **The counting logic `count += right - left + 1`:** This is the heart of the `atMost` helper. Understand why this correctly counts all valid subarrays ending at the current `right` position.
- **Alternative (Prefix Sum + Hash Map):** This problem can also be solved by iterating through the array, calculating the prefix sum, and using a hash map to find `prefix_sum - goal`. The sliding window approach is often more intuitive for this pattern.

#### Related Problems
- 2. Count Number of Nice Subarrays
- 4. Subarray with K Different Integers

---

### 2. Count Number of Nice Subarrays
`[MEDIUM]` `#sliding-window` `#counting` `#problem-reduction`

#### Problem Statement
Given an array of integers `nums` and an integer `k`, a "nice" subarray is a continuous subarray that has exactly `k` odd numbers in it. Return the number of nice subarrays.

*Example:*
- **Input:** `nums = [1, 1, 2, 1, 1]`, `k = 3`
- **Output:** `2` (The subarrays are `[1,1,2,1]` and `[1,2,1,1]`).

#### Implementation Overview
This problem can be elegantly reduced to the "Binary Subarray with Sum" problem. The core idea is that the exact values of the numbers don't matter, only their parity (odd or even).

1.  **Reduce the problem:** Transform the input array `nums` into a binary array where odd numbers become `1` and even numbers become `0`.
2.  The problem is now: "Find the number of subarrays in this new binary array with a sum of exactly `k`." This is precisely the previous problem.
3.  Apply the `atMost(k) - atMost(k - 1)` strategy to the binary array.

#### Python Code Snippet
```python
def numberOfSubarrays(nums: list[int], k: int) -> int:
    # Reduce the problem by converting odd/even to 1/0
    binary_nums = [1 if num % 2 != 0 else 0 for num in nums]

    def atMost(goal: int) -> int:
        if goal < 0:
            return 0
        left = 0
        current_sum = 0
        count = 0
        for right in range(len(binary_nums)):
            current_sum += binary_nums[right]
            while current_sum > goal:
                current_sum -= binary_nums[left]
                left += 1
            count += right - left + 1
        return count

    return atMost(k) - atMost(k - 1)
```

#### Tricks/Gotchas
- **Problem Reduction:** This is a powerful technique. Always look for ways to transform a problem into a structure you've seen before. Here, the abstraction is from numbers to their properties (parity).

#### Related Problems
- 1. Binary Subarray with Sum
- 4. Subarray with K Different Integers

---

### 3. Number of Substrings Containing All Three Characters
`[MEDIUM]` `#sliding-window` `#counting`

#### Problem Statement
Given a string `s` consisting only of characters 'a', 'b' and 'c', return the number of substrings that contain at least one of each of these characters in it.

*Example:*
- **Input:** `s = "abcabc"`
- **Output:** `10`

#### Implementation Overview
This problem can be solved with a single, efficient sliding window pass. The key insight is that once we find a minimal valid window, we can easily count all the superstrings that are also valid.

1.  Initialize `left = 0`, `count = 0`, and a frequency map `counts` for 'a', 'b', 'c'.
2.  Iterate through the string with the `right` pointer to expand the window.
3.  Add `s[right]` to the window by incrementing its count.
4.  Use a `while` loop to check if the current window `[left, right]` is valid (i.e., contains at least one 'a', 'b', and 'c').
5.  **If the window is valid:**
    - We have found the *minimal* valid window ending at `right` that starts at `left`.
    - This implies that any substring that starts at `left` and ends at `right` *or later* is also guaranteed to be valid.
    - The number of such substrings is `len(s) - right`. Add this to our total `count`.
    - Now, we must shrink the window from the left by incrementing `left` and decrementing the count of `s[left]`. This invalidates the current minimal window, and we continue the `while` loop to see if the new, smaller window `[left+1, right]` is also valid.
6.  The outer loop continues, expanding the window with `right` until the end of the string.

#### Python Code Snippet
```python
def numberOfSubstrings(s: str) -> int:
    left = 0
    count = 0
    counts = {'a': 0, 'b': 0, 'c': 0}

    for right in range(len(s)):
        counts[s[right]] += 1

        # Once the window is valid, every superstring ending after `right` is also valid.
        while all(c > 0 for c in counts.values()):
            count += len(s) - right

            # Shrink the window from the left to find the next minimal valid window
            counts[s[left]] -= 1
            left += 1

    return count
```

#### Tricks/Gotchas
- **The Counting Insight:** The `count += len(s) - right` is the core trick. It elegantly counts all valid substrings that can be formed once a minimal valid window `[left, right]` is found.
- **Shrinking and Recounting:** The `while` loop correctly handles cases where multiple valid windows can end at the same `right` (e.g., "aaabc", `right` at 'c'). It finds "aaabc", counts, then shrinks to "aabc", counts again, and so on.

#### Related Problems
- This problem has a unique counting method, but the window validation is similar to other problems.

---

### 4. Subarrays with K Different Integers
`[HARD]` `#sliding-window` `#counting` `#hash-map`

#### Problem Statement
Given an integer array `nums` and an integer `k`, return the number of "good" subarrays of `nums`. A good subarray is a contiguous subarray of `nums` that has exactly `k` different integers.

*Example:*
- **Input:** `nums = [1, 2, 1, 2, 3]`, `k = 2`
- **Output:** `7` (The subarrays are `[1,2]`, `[2,1]`, `[1,2]`, `[2,3]`, `[1,2,1]`, `[2,1,2]`, `[1,2,1,2]`).

#### Implementation Overview
This is the quintessential problem for the `exactly K = at most K - at most K-1` strategy. It's difficult to solve directly but becomes manageable with this conversion.

1.  The core idea is that the number of subarrays with exactly `k` distinct elements is equal to (the number of subarrays with *at most* `k` distinct elements) minus (the number of subarrays with *at most* `k-1` distinct elements).
2.  Implement a helper function, `atMostK(k_val)`, to solve the "at most" version of the problem.
3.  The main function simply returns `atMostK(k) - atMostK(k - 1)`.
4.  **Inside `atMostK(k_val)`:**
    - This is a standard counting sliding window.
    - Initialize `left = 0`, `count = 0`, and a hash map `counts` for frequencies.
    - Iterate with `right` to expand the window, adding `nums[right]` to `counts`.
    - If the number of distinct elements (`len(counts)`) exceeds `k_val`, shrink the window from the left until it becomes valid again.
    - For each valid window `[left, right]`, add `right - left + 1` to the total `count`.

#### Python Code Snippet
```python
import collections

def subarraysWithKDistinct(nums: list[int], k: int) -> int:
    def atMostK(k_val: int) -> int:
        left = 0
        count = 0
        counts = collections.defaultdict(int)
        for right in range(len(nums)):
            counts[nums[right]] += 1
            while len(counts) > k_val:
                counts[nums[left]] -= 1
                if counts[nums[left]] == 0:
                    del counts[nums[left]]
                left += 1
            count += right - left + 1
        return count

    return atMostK(k) - atMostK(k - 1)
```

#### Tricks/Gotchas
- **Purity of the Pattern:** This problem is the best example to learn and master the "at most K" conversion, as it's hard to solve otherwise.
- **`atMostK` Implementation:** Ensure your `atMostK` helper is robust. It combines the window validation from "Longest Substring with At Most K Distinct Characters" with the counting logic from "Binary Subarray with Sum".

#### Related Problems
- 1. Binary Subarray with Sum
- 2. Count Number of Nice Subarrays
