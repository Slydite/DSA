---

### 1. Longest Common Prefix
`[EASY]` `#string` `#prefix`

#### Problem Statement
Write a function to find the longest common prefix string amongst an array of strings. If there is no common prefix, return an empty string `""`.

#### Implementation Overview
There are several ways to solve this, but a simple and effective one is to iterate character by character, comparing the character at each position for all strings.

1.  **Handle Edge Cases**: If the input list is empty, return `""`. If it has one string, return that string.
2.  **Sort the Array**: A very clever trick is to sort the array of strings lexicographically. The longest common prefix of all the strings will be the common prefix between the *first* and *last* strings in the sorted array.
3.  **Compare First and Last**:
    -   Take the first string (`first_str`) and the last string (`last_str`) from the sorted array.
    -   Iterate through their characters from the beginning.
    -   Build a `prefix` string by adding characters that are identical in both `first_str` and `last_str`.
    -   Stop as soon as a mismatch is found.
4.  Return the resulting `prefix`.

**Alternative (Vertical Scanning):**
1. Iterate from the first character of the first string (`i = 0, 1, 2, ...`).
2. For each character `c` at `strs[0][i]`, check if this character exists and is the same at index `i` for all other strings in the array.
3. If it is, append `c` to the result.
4. If not (either because a string is too short or the character mismatches), the loop terminates, and you return the prefix found so far.

#### Python Code Snippet (Sorting Method)
```python
from typing import List

def longest_common_prefix(strs: List[str]) -> str:
    """
    Finds the longest common prefix from a list of strings.
    """
    if not strs:
        return ""

    # Sort the list of strings
    strs.sort()

    first_str = strs[0]
    last_str = strs[-1]
    prefix = []

    # Compare the first and the last string character by character
    for i in range(len(first_str)):
        if i < len(last_str) and first_str[i] == last_str[i]:
            prefix.append(first_str[i])
        else:
            # Stop at the first mismatch
            break

    return "".join(prefix)
```

#### Tricks/Gotchas
- **Sorting Approach**: The sorting method is concise and clever. It works because any common prefix must be a prefix of the lexicographically smallest string, and any deviation will show up earliest when comparing it with the lexicographically largest string.
- **Empty Input**: Always check for an empty list of strings as an edge case.

#### Related Problems
- Longest Palindromic Substring

---

### 2. Longest Palindromic Substring
`[HARD]` `#string` `#palindrome` `#substring` `#expand-around-center`

#### Problem Statement
Given a string `s`, return the longest palindromic substring in `s`.

#### Implementation Overview
While this can be solved with dynamic programming, a more intuitive and efficient approach (without DP, as requested) is the **Expand Around Center** method.

The idea is that any palindrome has a "center." This center can be a single character (for odd-length palindromes like "racecar") or a pair of characters (for even-length palindromes like "aabbaa").

1.  **Iterate Through Centers**: Loop through every possible center in the string. There are `2n - 1` such centers: `n` single-character centers and `n-1` double-character centers.
2.  **Expand and Check**: For each center, expand outwards with two pointers (`left` and `right`) as long as the characters at these pointers match and they are within the bounds of the string.
3.  **Track Longest**: Keep track of the start index and length of the longest palindrome found so far.
4.  **Return Result**: Once all centers have been checked, slice the string using the stored start index and length to return the longest palindromic substring.

#### Python Code Snippet
```python
def longest_palindromic_substring(s: str) -> str:
    if not s or len(s) < 1:
        return ""

    start, end = 0, 0

    for i in range(len(s)):
        # Odd length palindromes (center is one char)
        len1 = expand_around_center(s, i, i)
        # Even length palindromes (center is two chars)
        len2 = expand_around_center(s, i, i + 1)

        max_len = max(len1, len2)

        if max_len > (end - start):
            start = i - (max_len - 1) // 2
            end = i + max_len // 2

    return s[start:end+1]

def expand_around_center(s: str, left: int, right: int) -> int:
    L, R = left, right
    while L >= 0 and R < len(s) and s[L] == s[R]:
        L -= 1
        R += 1
    # Return the length of the palindrome found
    return R - L - 1
```

#### Tricks/Gotchas
- **Center Types**: Remember to check both odd-length (center `i, i`) and even-length (center `i, i+1`) palindromes for every possible position.
- **Index Calculation**: Calculating the `start` and `end` indices from the center `i` and `max_len` can be tricky. The formula `start = i - (max_len - 1) // 2` correctly handles both even and odd cases.

#### Related Problems
- Palindrome Check
- Count Number of Substrings

---

### 3. Count Number of Substrings
`[MEDIUM]` `#string` `#substring` `#sliding-window`

#### Problem Statement
This is a general problem type. A common variant is "Count number of substrings with exactly `k` distinct characters" or "at most `k` distinct characters". We will focus on the "at most `k`" variant, as it's a foundational sliding window pattern.

#### Implementation Overview
The problem of counting substrings with at most `k` distinct characters can be solved efficiently using a sliding window approach.

1.  **Initialize**:
    -   `left = 0`: The left pointer of the window.
    -   `count = 0`: The total count of valid substrings.
    -   `char_freq = {}`: A hash map to store the frequency of characters inside the current window.
2.  **Expand Window**: Iterate through the string with a `right` pointer from `0` to `n-1`.
    -   Add the character `s[right]` to the window and update its frequency in `char_freq`.
3.  **Shrink Window**:
    -   While the number of distinct characters in the window (i.e., `len(char_freq)`) is greater than `k`, you must shrink the window from the left.
    -   Decrement the frequency of `s[left]`. If its frequency becomes `0`, remove it from the map.
    -   Move the left pointer: `left += 1`.
4.  **Count Substrings**: After ensuring the window `s[left...right]` is valid (has at most `k` distinct characters), all substrings ending at `right` are also valid. The number of such substrings is `right - left + 1`. Add this to the total `count`.
5.  Return `count`.

To solve for **exactly `k`**, use the inclusion-exclusion principle: `count(exactly k) = count(at_most k) - count(at_most k-1)`.

#### Python Code Snippet (At Most K)
```python
from collections import defaultdict

def count_substrings_at_most_k(s: str, k: int) -> int:
    if not s:
        return 0

    left = 0
    count = 0
    char_freq = defaultdict(int)

    for right in range(len(s)):
        char_freq[s[right]] += 1

        while len(char_freq) > k:
            char_freq[s[left]] -= 1
            if char_freq[s[left]] == 0:
                del char_freq[s[left]]
            left += 1

        # All substrings ending at `right` are valid
        count += (right - left + 1)

    return count
```

#### Tricks/Gotchas
- **Sliding Window Logic**: The core idea is that for a valid window `s[left...right]`, every substring that ends at `right` (e.g., `s[right]`, `s[right-1...right]`, etc., down to `s[left...right]`) is also valid.
- **Inclusion-Exclusion**: The trick to calculate "exactly k" from "at most k" is a very common and powerful pattern.

#### Related Problems
- Sum of Beauty of all substring

---

### 4. Sum of Beauty of all Substring
`[MEDIUM]` `#string` `#substring` `#frequency`

#### Problem Statement
The beauty of a string is the difference between the frequency of the most frequent character and the least frequent character. Given a string `s`, return the sum of beauty of all of its substrings.

#### Implementation Overview
A brute-force approach that generates every substring and calculates its beauty is the most direct way to solve this. While more optimal solutions exist, they are significantly more complex.

1.  **Outer Loop (Start of Substring)**: Iterate with a pointer `i` from `0` to `n-1` to select the starting character of a substring.
2.  **Inner Loop (End of Substring)**: Iterate with a pointer `j` from `i` to `n-1` to generate all substrings starting at `i`.
3.  **Calculate Beauty for Each Substring**:
    -   For each substring `s[i...j]`, maintain a frequency map (or an array of size 26).
    -   Update the frequency of the character `s[j]` in the map.
    -   Find the maximum frequency (`max_f`) and minimum frequency (`min_f`) among the characters present in the current substring's frequency map.
    -   The beauty is `max_f - min_f`.
    -   Add this beauty to a running total `total_beauty`.
4.  Return `total_beauty`.

#### Python Code Snippet
```python
from collections import defaultdict

def sum_of_beauty(s: str) -> int:
    total_beauty = 0
    n = len(s)

    for i in range(n):
        # Freq map for substrings starting at i
        freq = defaultdict(int)
        for j in range(i, n):
            # Update frequency for the new character
            freq[s[j]] += 1

            # Calculate beauty for the current substring s[i...j]
            if len(freq) > 1:
                max_f = 0
                min_f = float('inf')
                # Find min and max frequency among present characters
                for char_code in freq:
                    max_f = max(max_f, freq[char_code])
                    min_f = min(min_f, freq[char_code])

                total_beauty += (max_f - min_f)

    return total_beauty
```

#### Tricks/Gotchas
- **Time Complexity**: This brute-force O(N^2) approach is acceptable for medium constraints. Each inner step (finding min/max) takes O(26) or O(log k), making the overall complexity roughly O(N^2).
- **Frequency Map Scope**: The frequency map should be initialized inside the outer loop, so it's fresh for each new starting position `i`.

#### Related Problems
- Count Number of Substrings
