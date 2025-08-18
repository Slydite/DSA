# Pattern 1: Variable-Size Sliding Window - Finding Max/Min Length

This pattern is used for problems where we need to find the longest or shortest subarray/substring that satisfies a certain condition. The window size is not fixed; it expands and shrinks dynamically.

A common approach involves:
- Two pointers, `left` and `right`, defining the current window.
- The `right` pointer always moves forward, expanding the window.
- The `left` pointer moves forward only when a condition is violated, shrinking the window.
- A data structure (like a hash map or an array) is often used to track the state of the window (e.g., character counts, sum).

---

### 1. Longest Substring Without Repeating Characters
`[MEDIUM]` `#sliding-window` `#hash-map`

#### Problem Statement
Given a string `s`, find the length of the longest substring that does not contain repeating characters.

*Example:*
- **Input:** `s = "abcabcbb"`
- **Output:** `3` (The substring is "abc")
- **Input:** `s = "bbbbb"`
- **Output:** `1` (The substring is "b")

#### Implementation Overview
The core idea is to use a sliding window that always maintains a substring without repeating characters.
1.  Initialize two pointers, `left = 0` and `right = 0`, a `max_length = 0`, and a hash set `char_set` to store characters in the current window.
2.  Iterate through the string with the `right` pointer.
3.  For each character `s[right]`:
    - If `s[right]` is already in `char_set`, it's a duplicate. We must shrink the window from the left until the duplicate is removed.
    - Repeatedly remove `s[left]` from `char_set` and increment `left` until `s[right]` is no longer in the set.
    - Add the current character `s[right]` to `char_set`.
4.  After handling the current character, the window `[left, right]` is valid. Update `max_length = max(max_length, right - left + 1)`.
5.  Continue until `right` reaches the end of the string.

#### Python Code Snippet
```python
def lengthOfLongestSubstring(s: str) -> int:
    char_set = set()
    left = 0
    max_len = 0
    for right in range(len(s)):
        while s[right] in char_set:
            char_set.remove(s[left])
            left += 1
        char_set.add(s[right])
        max_len = max(max_len, right - left + 1)
    return max_len
```

#### Tricks/Gotchas
- **Window Shrinking:** The `while` loop is crucial. It ensures the window is always valid before the `max_len` is calculated for the current `right` pointer position.
- **Data Structure:** Using a hash set provides efficient O(1) average time complexity for adding, removing, and checking for the existence of characters.

#### Related Problems
- 3. Fruit Into Baskets
- 5. Longest Substring with At Most K Distinct Characters
- 6. Minimum Window Substring

---

### 2. Max Consecutive Ones III
`[MEDIUM]` `#sliding-window`

#### Problem Statement
Given a binary array `nums` and an integer `k`, return the maximum number of consecutive 1s in the array if you can flip at most `k` 0s.

*Example:*
- **Input:** `nums = [1,1,1,0,0,0,1,1,1,1,0]`, `k = 2`
- **Output:** `6` (By flipping the two 0s at indices 4 and 5, we get the subarray `[1,1,1,1,1,1]`)

#### Implementation Overview
This problem can be rephrased as "find the longest subarray containing at most `k` zeros". This makes it a classic variable-size sliding window problem.
1.  Initialize `left = 0`, `max_length = 0`, and `zero_count = 0`.
2.  Iterate through the array with the `right` pointer, expanding the window.
3.  If `nums[right]` is a `0`, increment `zero_count`.
4.  If `zero_count` becomes greater than `k`, the window is invalid. We must shrink it from the left until it becomes valid again.
    - Enter a `while` loop that runs as long as `zero_count > k`.
    - If `nums[left]` is a `0`, decrement `zero_count`.
    - Increment `left`.
5.  After each potential shrink, the window `[left, right]` is valid. Calculate its length and update `max_length`.

#### Python Code Snippet
```python
def longestOnes(nums: list[int], k: int) -> int:
    left = 0
    max_len = 0
    zero_count = 0
    for right in range(len(nums)):
        if nums[right] == 0:
            zero_count += 1

        while zero_count > k:
            if nums[left] == 0:
                zero_count -= 1
            left += 1

        max_len = max(max_len, right - left + 1)

    return max_len
```

#### Tricks/Gotchas
- **Problem Rephrasing:** The key is to see this not as a "flipping" problem, but as a "longest subarray with a constraint" problem.
- **Window Invariant:** The core logic maintains the invariant that the window `[left, right]` never contains more than `k` zeros.

#### Related Problems
- 4. Longest Repeating Character Replacement
- 5. Longest Substring with At Most K Distinct Characters

---

### 3. Fruit Into Baskets
`[MEDIUM]` `#sliding-window` `#hash-map`

#### Problem Statement
You are visiting a farm with a single row of fruit trees, represented by an array `fruits` where `fruits[i]` is the type of fruit the `i`-th tree produces. You have two baskets, and each can only hold one type of fruit. Starting from any tree, you pick one fruit from every tree to the right, but you must stop when you encounter a third type of fruit.

Return the maximum number of fruits you can pick.

*Example:*
- **Input:** `fruits = [1, 2, 1, 2, 3]`
- **Output:** `4` (The subarray is `[1, 2, 1, 2]`)
- **Input:** `fruits = [0, 1, 2, 2]`
- **Output:** `3` (The subarray is `[1, 2, 2]`)

#### Implementation Overview
This problem is a direct application of the "longest subarray with at most K distinct elements" pattern, where `K=2`.
1.  Initialize `left = 0`, `max_length = 0`, and a hash map `fruit_counts` to store the frequency of each fruit type in the window.
2.  Iterate through `fruits` with the `right` pointer to expand the window.
3.  Add `fruits[right]` to the window by incrementing its count in `fruit_counts`.
4.  Check if the window has become invalid. The condition for invalidity is having more than 2 distinct fruit types (`len(fruit_counts) > 2`).
5.  If the window is invalid, shrink it from the left inside a `while` loop:
    - Decrement the count of `fruits[left]`.
    - If the count of `fruits[left]` becomes 0, it means that fruit type is no longer in the window, so remove it from the hash map.
    - Increment `left`.
6.  The window is now valid. Update `max_length` with the current window size.

#### Python Code Snippet
```python
import collections

def totalFruit(fruits: list[int]) -> int:
    left = 0
    max_len = 0
    fruit_counts = collections.defaultdict(int)
    for right in range(len(fruits)):
        fruit_counts[fruits[right]] += 1
        while len(fruit_counts) > 2:
            fruit_counts[fruits[left]] -= 1
            if fruit_counts[fruits[left]] == 0:
                del fruit_counts[fruits[left]]
            left += 1
        max_len = max(max_len, right - left + 1)
    return max_len
```

#### Tricks/Gotchas
- **Problem Mapping:** The crucial insight is to map the problem's narrative about baskets and fruits to a standard sliding window pattern.
- **Hash Map Management:** Correctly managing the hash map by decrementing counts and deleting keys with zero count is essential for the logic to work.

#### Related Problems
- 1. Longest Substring Without Repeating Characters

---

### 7. Maximum Points You Can Obtain from Cards
`[MEDIUM]` `#sliding-window` `#prefix-sum`

#### Problem Statement
There are several cards arranged in a row, each with a certain number of points given in the array `cardPoints`. In one step, you can take one card from either the beginning or the end of the row. You must take exactly `k` cards. Your score is the sum of points of the cards you have taken. Return the maximum possible score.

*Example:*
- **Input:** `cardPoints = [1, 2, 3, 4, 5, 6, 1]`, `k = 3`
- **Output:** `12` (Take three cards from the right: 1 + 6 + 5 = 12).

#### Implementation Overview
This problem seems complex due to the choice of taking from either end. However, it can be greatly simplified by inverting the problem.

The `k` cards taken will always consist of a prefix of length `i` and a suffix of length `k-i`. The cards *not* taken will always form a contiguous subarray of length `n-k` in the middle of the original array.

To maximize the sum of the cards taken, we must minimize the sum of the `n-k` cards that are left behind.

1.  Rephrase the problem: Find the minimum sum subarray of size `n-k`.
2.  Calculate the `total_sum` of all elements in `cardPoints`.
3.  If `n == k`, all cards must be taken, so the answer is `total_sum`.
4.  Use a fixed-size sliding window of size `window_size = n - k`.
5.  Calculate the sum of the initial window (`sum of first n-k elements`). This is our initial `min_window_sum`.
6.  Slide the window one element at a time to the right. In each step, update the window sum by adding the new element and subtracting the element that just left the window.
7.  Update `min_window_sum` with the minimum sum found across all windows.
8.  The final answer is `total_sum - min_window_sum`.

#### Python Code Snippet
```python
def maxScore(cardPoints: list[int], k: int) -> int:
    n = len(cardPoints)
    window_size = n - k
    total_sum = sum(cardPoints)

    if window_size == 0:
        return total_sum

    # Find the sum of the initial window of elements to be left behind
    current_window_sum = sum(cardPoints[:window_size])
    min_window_sum = current_window_sum

    # Slide the window to find the minimum sum subarray
    for i in range(window_size, n):
        # Add the new element and remove the old one
        current_window_sum += cardPoints[i] - cardPoints[i - window_size]
        min_window_sum = min(min_window_sum, current_window_sum)

    return total_sum - min_window_sum
```

#### Tricks/Gotchas
- **Problem Inversion:** The core trick is to invert the perspective from "maximizing the sum of ends" to "minimizing the sum of the middle". This transforms a tricky problem into a standard fixed-size sliding window problem.
- **Fixed vs. Variable Window:** Recognizing that the "leftover" elements form a fixed-size window is key.

#### Related Problems
This problem's solution is quite unique. The "inversion" technique is a valuable general problem-solving skill.
- 5. Longest Substring with At Most K Distinct Characters

---

### 4. Longest Repeating Character Replacement
`[MEDIUM]` `#sliding-window` `#hash-map`

#### Problem Statement
You are given a string `s` and an integer `k`. You can choose any character of the string and change it to any other uppercase English character. You can perform this operation at most `k` times. Return the length of the longest substring containing the same letter you can get after performing the operations.

*Example:*
- **Input:** `s = "AABABBA"`, `k = 1`
- **Output:** `4` (Replace the 'B' at index 2 to 'A' to get "AAAABBA", with a window of "AAAA").

#### Implementation Overview
The key to this problem is the condition for a valid window: a window is valid if the number of characters that are *not* the most frequent character is at most `k`. This can be expressed as: `window_length - count_of_most_frequent_char <= k`.

1.  Initialize `left = 0`, `max_length = 0`, `max_freq = 0` (to track the frequency of the most common character in the window), and a hash map `char_counts`.
2.  Iterate through the string with the `right` pointer.
3.  For each character `s[right]`:
    - Increment its count in `char_counts`.
    - Update `max_freq = max(max_freq, char_counts[s[right]])`.
4.  Check if the current window is invalid by checking if `(right - left + 1) - max_freq > k`.
5.  If the window is invalid, shrink it from the left:
    - Decrement the count of `s[left]`.
    - Increment `left`.
    - **Note:** We don't need to update `max_freq` when shrinking. The window size will only expand to a new maximum if we find a character with an even higher frequency later on.
6.  The window size `right - left + 1` is always the candidate for the maximum length. Update `max_length`.

#### Python Code Snippet
```python
import collections

def characterReplacement(s: str, k: int) -> int:
    left = 0
    max_len = 0
    max_freq = 0
    char_counts = collections.defaultdict(int)
    for right in range(len(s)):
        char_counts[s[right]] += 1
        max_freq = max(max_freq, char_counts[s[right]])

        # Check if the window is invalid
        if (right - left + 1) - max_freq > k:
            char_counts[s[left]] -= 1
            left += 1

        max_len = max(max_len, right - left + 1)

    return max_len
```

#### Tricks/Gotchas
- **The Condition:** The `window_length - max_freq <= k` condition is the most critical and clever part of this solution.
- **`max_freq` Optimization:** Understanding why `max_freq` doesn't need to be re-calculated upon shrinking is key to an efficient and clean implementation. The maximum window size is tied to finding a new `max_freq`.

#### Related Problems
- 2. Max Consecutive Ones III

---

### 5. Longest Substring with At Most K Distinct Characters
`[MEDIUM]` `#sliding-window` `#hash-map`

#### Problem Statement
Given a string `s` and an integer `k`, find the length of the longest substring of `s` that contains at most `k` distinct characters.

*Example:*
- **Input:** `s = "eceba"`, `k = 2`
- **Output:** `3` (The substring is "ece").
- **Input:** `s = "aa"`, `k = 1`
- **Output:** `2` (The substring is "aa").

#### Implementation Overview
This is a classic and fundamental sliding window problem. The window is valid as long as it contains no more than `k` unique characters.

1.  Initialize `left = 0`, `max_length = 0`, and a hash map `char_counts` to store character frequencies.
2.  Iterate through the string with the `right` pointer to expand the window.
3.  Add `s[right]` to the window by incrementing its count in `char_counts`.
4.  Check for invalidity: `len(char_counts) > k`.
5.  If the window is invalid, shrink it from the left in a `while` loop until it becomes valid again:
    - Decrement the count of `s[left]`.
    - If a character's count drops to 0, remove it from the hash map to keep the distinct count accurate.
    - Increment `left`.
6.  The window is now valid. Update `max_length` with the current window size.

#### Python Code Snippet
```python
import collections

def lengthOfLongestSubstringKDistinct(s: str, k: int) -> int:
    if k == 0:
        return 0

    left = 0
    max_len = 0
    char_counts = collections.defaultdict(int)

    for right in range(len(s)):
        char_counts[s[right]] += 1

        while len(char_counts) > k:
            char_counts[s[left]] -= 1
            if char_counts[s[left]] == 0:
                del char_counts[s[left]]
            left += 1

        max_len = max(max_len, right - left + 1)

    return max_len
```

#### Tricks/Gotchas
- **Template Problem:** This solution serves as a template for many other sliding window problems where the condition is based on a count of distinct elements.
- **Edge Case `k=0`:** If `k` is 0, no characters are allowed, so the result must be 0.

#### Related Problems
- 1. Longest Substring Without Repeating Characters
- 3. Fruit Into Baskets

---

### 6. Minimum Window Substring
`[HARD]` `#sliding-window` `#hash-map`

#### Problem Statement
Given two strings, `s` (the search string) and `t` (the target string), find the minimum-length substring of `s` that contains all the characters of `t`. If no such substring exists, return an empty string `""`.

*Example:*
- **Input:** `s = "ADOBECODEBANC"`, `t = "ABC"`
- **Output:** `"BANC"`
- **Input:** `s = "a"`, `t = "aa"`
- **Output:** `""`

#### Implementation Overview
This problem requires a more advanced sliding window. The window is valid if it contains all characters from `t` (respecting frequencies). We want to find the smallest such valid window.

1.  Create a frequency map of characters in `t` (`t_counts`).
2.  Initialize a frequency map for the current window (`window_counts`).
3.  Use two variables, `have` and `need`, to track the state of the window. `need` is the number of unique characters in `t`. `have` is the number of unique characters in `t` whose frequency in the window matches their frequency in `t`.
4.  Expand the window by moving the `right` pointer. For each character, update `window_counts`. If the character is in `t_counts` and its count in the window now matches its required count, increment `have`.
5.  Once `have == need`, the window is valid. Now, we must try to shrink it from the left to find the minimum possible length.
6.  Enter a `while` loop that continues as long as the window is valid (`have == need`):
    - Compare the current window's length to the minimum length found so far and update if it's smaller.
    - Shrink the window by incrementing `left`.
    - As `s[left]` is removed, update `window_counts`. If `s[left]` was a required character and its count in the window now drops below what's needed, decrement `have`. This will eventually break the shrink loop.
7.  After the main loop, if a valid window was found, return the substring corresponding to the stored minimum length window.

#### Python Code Snippet
```python
import collections

def minWindow(s: str, t: str) -> str:
    if not t or not s:
        return ""

    t_counts = collections.Counter(t)
    window_counts = {}

    have, need = 0, len(t_counts)
    res, res_len = [-1, -1], float('inf')
    left = 0

    for right, char in enumerate(s):
        window_counts[char] = window_counts.get(char, 0) + 1

        if char in t_counts and window_counts[char] == t_counts[char]:
            have += 1

        while have == need:
            # Update result
            if (right - left + 1) < res_len:
                res = [left, right]
                res_len = right - left + 1

            # Shrink window
            window_counts[s[left]] -= 1
            if s[left] in t_counts and window_counts[s[left]] < t_counts[s[left]]:
                have -= 1
            left += 1

    l, r = res
    return s[l:r+1] if res_len != float('inf') else ""
```

#### Tricks/Gotchas
- **Two-Phase Window:** The logic of "expand until valid, then shrink until invalid" is a common pattern for minimum window problems.
- **State Tracking:** Precisely tracking `have` and `need` is the most complex part. An error here will lead to incorrect window validation.
- **Result Storage:** You need to store the indices of the minimum window, not just its length, to be able to return the substring.

#### Related Problems
- 1. Longest Substring Without Repeating Characters
