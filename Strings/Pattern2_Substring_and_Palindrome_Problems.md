### `[PATTERN] Substring and Palindrome Problems`

This pattern focuses on two common categories of string problems: those dealing with properties of substrings (like prefixes and occurrences) and those involving palindromes (strings that read the same forwards and backwards).

---
### Palindrome Patterns

A palindrome is a sequence that reads the same backward as forward. A common and efficient technique for solving many palindrome problems is the **Expand Around Center** method.

#### The Expand Around Center Method
The core idea is that any palindrome has a center. This center can be a single character (for odd-length palindromes like "r**a**cecar") or a pair of identical characters (for even-length palindromes like "aa**bb**aa"). By iterating through every possible center and expanding outwards, we can find all palindromic substrings.

---

### 1. Longest Palindromic Substring
`[MEDIUM]` `#palindrome` `#expand-around-center`

#### Problem Statement
Given a string `s`, return the longest palindromic substring in `s`.

#### Implementation Overview
We apply the "Expand Around Center" method.
1.  **Iterate Through Centers**: Loop through every character index `i` in the string. Each `i` can be the center of an odd-length palindrome, and each pair `(i, i+1)` can be the center of an even-length palindrome.
2.  **Expand**: For each center, use two pointers (`left` and `right`) to expand outwards as long as `s[left] == s[right]` and the pointers are within the string bounds.
3.  **Track Longest**: Keep track of the start index and length of the longest palindrome found so far.
4.  **Return Result**: After checking all centers, slice the string to return the longest one.

#### Python Code Snippet
```python
def longest_palindromic_substring(s: str) -> str:
    if not s or len(s) < 1:
        return ""

    start, max_len = 0, 1

    def expand_around_center(left, right):
        nonlocal start, max_len
        while left >= 0 and right < len(s) and s[left] == s[right]:
            if (right - left + 1) > max_len:
                max_len = right - left + 1
                start = left
            left -= 1
            right += 1

    for i in range(len(s)):
        # Odd length palindromes (e.g., "aba")
        expand_around_center(i, i)
        # Even length palindromes (e.g., "abba")
        expand_around_center(i, i + 1)

    return s[start : start + max_len]
```

---

### 2. Palindromic Substrings
`[MEDIUM]` `#palindrome` `#expand-around-center`

#### Problem Statement
Given a string `s`, return the number of palindromic substrings in it. Substrings with different start or end indices are counted as different substrings even if they consist of the same characters.

#### Implementation Overview
This problem is a direct companion to the "Longest Palindromic Substring" problem and uses the same "Expand Around Center" technique. Instead of tracking the longest palindrome, we simply increment a counter for every valid palindrome we find.

1.  **Iterate Through Centers**: Loop through every possible center (`i` and `i, i+1`).
2.  **Expand and Count**: For each center, expand outwards with two pointers. Every time `s[left] == s[right]`, we have found a new valid palindrome, so we increment our `count`.

#### Python Code Snippet
```python
def count_substrings(s: str) -> int:
    count = 0

    def expand_and_count(left, right):
        nonlocal count
        while left >= 0 and right < len(s) and s[left] == s[right]:
            # Each valid expansion is a new palindromic substring
            count += 1
            left -= 1
            right += 1

    for i in range(len(s)):
        # Odd length palindromes
        expand_and_count(i, i)
        # Even length palindromes
        expand_and_count(i, i + 1)

    return count
```

---

### 3. Valid Palindrome II
`[EASY]` `#palindrome` `#two-pointers`

#### Problem Statement
Given a string `s`, return `true` if `s` can be a palindrome after deleting **at most one** character from it.

#### Implementation Overview
We use a standard two-pointer approach to check for a palindrome. When we find the first mismatch, we are allowed to "skip" one of the mismatched characters. We then check if the rest of the string is a palindrome.

1.  Use two pointers, `left` and `right`, starting at the ends of the string.
2.  Move them inward. If `s[left] == s[right]`, continue.
3.  If `s[left] != s[right]`, this is our one chance to delete a character. We have two possibilities:
    a. Delete the character at `left` and check if the substring `s[left+1...right]` is a palindrome.
    b. Delete the character at `right` and check if the substring `s[left...right-1]` is a palindrome.
4.  If either of those checks returns `true`, then the original string can become a palindrome. Otherwise, it cannot.
5.  If the main loop completes without any mismatches, the string was already a palindrome.

#### Python Code Snippet
```python
def valid_palindrome_ii(s: str) -> bool:
    left, right = 0, len(s) - 1

    while left < right:
        if s[left] != s[right]:
            # Check if it's a palindrome by skipping either left or right
            skip_left = s[left+1 : right+1]
            skip_right = s[left : right]
            return skip_left == skip_left[::-1] or skip_right == skip_right[::-1]
        left += 1
        right -= 1

    return True
```

---
### Substring and Prefix Patterns

These problems involve finding, comparing, or manipulating substrings and prefixes.

---

### 4. Longest Common Prefix
`[EASY]` `#prefix` `#string`

#### Problem Statement
Write a function to find the longest common prefix string amongst an array of strings.

#### Implementation Overview
A simple and robust method is "Vertical Scanning". We compare characters at the same index across all strings.

1.  **Handle Edge Case**: If the input list `strs` is empty, return `""`.
2.  **Vertical Scan**: Iterate `i` from `0` to `len(strs[0]) - 1`.
    a. For each index `i`, take the character `c = strs[0][i]`.
    b. Then, loop through all other strings in the list (`strs[1:]`).
    c. Check if the current string is long enough (`i == len(other_str)`) or if its character at index `i` does not match `c`.
    d. If either is true, it means the common prefix ends just before index `i`. Return `strs[0][:i]`.
3.  If the outer loop completes, it means the entire first string is a common prefix. Return `strs[0]`.

#### Python Code Snippet
```python
from typing import List

def longest_common_prefix(strs: List[str]) -> str:
    if not strs:
        return ""

    # Iterate through the characters of the first string
    for i, char in enumerate(strs[0]):
        # Compare this character with the character at the same position in all other strings
        for other_str in strs[1:]:
            if i >= len(other_str) or other_str[i] != char:
                # Mismatch found, the prefix is up to index i
                return strs[0][:i]

    # If the loop completes, the entire first string is the prefix
    return strs[0]
```

---

### 5. Find the Index of the First Occurrence in a String (strStr)
`[EASY]` `#substring`

#### Problem Statement
Given two strings `needle` and `haystack`, return the index of the first occurrence of `needle` in `haystack`, or `-1` if `needle` is not part of `haystack`.

#### Implementation Overview
This can be solved with a straightforward sliding window or nested loop approach.
1.  Get the lengths of both strings, `n` and `m`.
2.  Iterate through the `haystack` with a pointer `i` from `0` up to `n - m`. This pointer `i` marks the potential start of a match.
3.  For each `i`, check if the substring of `haystack` of length `m` starting at `i` is equal to `needle`.
4.  In Python, this is simply `haystack[i : i+m] == needle`.
5.  If they are equal, return `i`.
6.  If the loop finishes without finding a match, return `-1`.

#### Python Code Snippet
```python
def str_str(haystack: str, needle: str) -> int:
    n, m = len(haystack), len(needle)

    if m == 0:
        return 0
    if n < m:
        return -1

    for i in range(n - m + 1):
        if haystack[i : i+m] == needle:
            return i

    return -1
```

#### Tricks/Gotchas
- **Advanced Algorithms**: While the naive O(n*m) approach is simple and often sufficient, more advanced O(n+m) algorithms like **KMP (Knuth-Morris-Pratt)** and **Rabin-Karp** exist for this problem and are good to be aware of.
