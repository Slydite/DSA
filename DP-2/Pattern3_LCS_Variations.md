# Pattern 3: Longest Common Subsequence (LCS) & Variations

The Longest Common Subsequence (LCS) is one of the most fundamental and versatile patterns in Dynamic Programming, especially for problems involving two strings. The core idea is to build a 2D DP table where `dp[i][j]` represents the solution for the prefixes of the strings. A remarkable number of string problems can be solved by either applying the LCS algorithm directly or by slightly modifying its recurrence relation or interpretation.

---

### 1. Longest Common Subsequence (DP-25)
`[HARD]` `#lcs` `#string-dp`

#### Problem Statement
Given two strings, `text1` and `text2`, return the length of their longest common subsequence. A subsequence is a new string generated from the original string with some characters deleted without changing the relative order of the remaining characters.

#### Implementation Overview
-   **DP State:** `dp[i][j]` = the length of the LCS of `text1[0...i-1]` and `text2[0...j-1]`.
-   **Recurrence Relation:**
    -   If `text1[i-1] == text2[j-1]`, the characters match. This character is part of the LCS. So, `dp[i][j] = 1 + dp[i-1][j-1]`.
    -   If `text1[i-1] != text2[j-1]`, the characters don't match. We take the best result from the subproblems where we exclude one of the characters: `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`.
-   **Base Cases:** `dp[0][j] = 0` and `dp[i][0] = 0` for all `i, j`. An empty string has no common subsequence with any other string.
-   **Space Optimization:** The `dp` table can be space-optimized to O(n) where n is the length of the shorter string.

---

### 2. Print Longest Common Subsequence (DP-26)
`[HARD]` `#lcs` `#string-dp` `#backtracking`

#### Problem Statement
Given two strings, find and print one of their longest common subsequences.

#### Implementation Overview
1.  First, compute the entire `dp` table as you would for finding the length of the LCS.
2.  Once the table is filled, backtrack from the bottom-right corner (`dp[m][n]`) to reconstruct the LCS string.
3.  Start at `i = m`, `j = n`.
    -   If `text1[i-1] == text2[j-1]`, this character is part of the LCS. Prepend it to your result string and move diagonally up-left: `i--`, `j--`.
    -   If the characters don't match, compare `dp[i-1][j]` and `dp[i][j-1]`. Move in the direction of the larger value. If `dp[i-1][j] > dp[i][j-1]`, move up (`i--`). Otherwise, move left (`j--`).
4.  Continue until you reach the first row or column.

---

### 3. Longest Common Substring (DP-27)
`[HARD]` `#lcs` `#string-dp` `#substring`

#### Problem Statement
Given two strings, find the length of the longest common substring. A substring is a contiguous block of characters.

#### Implementation Overview
This is a subtle but important variation of LCS.
-   **DP State:** `dp[i][j]` = the length of the common substring *ending* at `text1[i-1]` and `text2[j-1]`.
-   **Recurrence Relation:**
    -   If `text1[i-1] == text2[j-1]`, the common substring is extended. `dp[i][j] = 1 + dp[i-1][j-1]`.
    -   If `text1[i-1] != text2[j-1]`, the common substring is broken. We reset the count: `dp[i][j] = 0`.
-   **Final Answer:** The length of the longest common substring is the **maximum value found anywhere** in the `dp` table. You need to keep track of this maximum as you fill the table.

---

### 4. Longest Palindromic Subsequence (DP-28)
`[HARD]` `#lps` `#lcs` `#string-dp`

#### Problem Statement
Given a string `s`, find the length of the longest palindromic subsequence in `s`.

#### Implementation Overview
This problem has a beautiful reduction to LCS. A palindrome reads the same forwards and backwards.
-   **Insight:** The longest palindromic subsequence of a string `s` is the same as the longest common subsequence of `s` and its reverse, `s_rev`.
-   **Algorithm:**
    1.  Create a reversed copy of the input string `s`, let's call it `s_rev`.
    2.  Calculate the length of the LCS between `s` and `s_rev`.
    3.  This length is the answer.

---

### 5. Minimum Insertions to Make a String Palindrome (DP-29)
`[HARD]` `#lps` `#lcs` `#string-dp`

#### Problem Statement
Given a string `s`, find the minimum number of insertions required to make `s` a palindrome.

#### Implementation Overview
This problem builds directly on the Longest Palindromic Subsequence (LPS) pattern.
-   **Insight:** The characters that are already part of the longest palindromic subsequence do not need to be touched. The characters that are *not* part of the LPS are the ones that are "unmatched". Each of these unmatched characters needs a corresponding character inserted somewhere else in the string to make it a palindrome.
-   **Algorithm:**
    1.  Find the length of the longest palindromic subsequence of `s`, let's call it `len_lps`.
    2.  The number of insertions needed is `len(s) - len_lps`.

---

### 6. Minimum Insertions/Deletions to Convert String A to String B (DP-30)
`[HARD]` `#lcs` `#string-dp`

#### Problem Statement
Given two strings, `str1` and `str2`, find the minimum number of deletions and insertions required to convert `str1` into `str2`.

#### Implementation Overview
The core of this problem is to find the parts of the strings that are already common and don't need to be changed. This is exactly the LCS.
-   **Insight:** The longest common subsequence is the part of `str1` that can be kept.
    -   The characters in `str1` that are not in the LCS must be deleted.
    -   The characters in `str2` that are not in the LCS must be inserted.
-   **Algorithm:**
    1.  Calculate the length of the LCS of `str1` and `str2`, let it be `len_lcs`.
    2.  Number of deletions = `len(str1) - len_lcs`.
    3.  Number of insertions = `len(str2) - len_lcs`.
    4.  Total operations = `(len(str1) - len_lcs) + (len(str2) - len_lcs)`.

---

### 7. Shortest Common Supersequence (DP-31)
`[HARD]` `#lcs` `#string-dp` `#scs`

#### Problem Statement
Given two strings `str1` and `str2`, return the shortest string that has both `str1` and `str2` as subsequences.

#### Implementation Overview
This is a constructive problem that combines the elements of both strings.
-   **Insight:** If we simply concatenate the two strings, we get a valid supersequence, but it's not the shortest because the common characters are repeated. The length of the shortest common supersequence is found by adding the lengths of both strings and subtracting the length of their longest common subsequence (to remove the duplication).
-   **Length Calculation:** `len(SCS) = len(str1) + len(str2) - len(LCS(str1, str2))`.
-   **Printing the SCS:** This requires backtracking on the LCS `dp` table, similar to printing the LCS, but with a twist:
    -   When `str1[i-1] == str2[j-1]`, it's a common character. Add it to the result and move diagonally (`i--`, `j--`).
    -   When they don't match, find which subproblem gave the better LCS result. If `dp[i-1][j]` was larger, it means `str1[i-1]` is unique to the supersequence here. Add `str1[i-1]` and move up (`i--`). Otherwise, add `str2[j-1]` and move left (`j--`).
    -   After the main loop, append any remaining characters from the non-empty string.
