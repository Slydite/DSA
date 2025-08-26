# Pattern 3: DP on Squares

This is a mini-pattern that deals with problems on a 2D grid (matrix) where the goal is to find the largest square or rectangle of a certain type, or to count the total number of such shapes. The DP state `dp[i][j]` typically stores information about the size or property of a shape ending at the cell `(i, j)`.

---

### 1. Count Square Submatrices with All Ones
`[MEDIUM]` `#dp-on-squares` `#grid-dp`

#### Problem Statement
Given a `m x n` matrix of ones and zeros, return how many square submatrices have all ones.

*Example:* `matrix = [[0,1,1,1],[1,1,1,1],[0,1,1,1]]`. **Output:** `15`

#### Implementation Overview
-   **DP State:** `dp[i][j]` = the side length of the largest square of all ones whose **bottom-right corner** is at `(i, j)`.
-   **Recurrence Relation:**
    -   If `matrix[i][j] == 0`, then `dp[i][j] = 0`.
    -   If `matrix[i][j] == 1`, `dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])`.
-   **Insight for Counting:** A `dp[i][j]` value of `k` means there is a `k x k` square, a `(k-1) x (k-1)` square, ..., and a `1 x 1` square all ending at this same corner. Therefore, `dp[i][j]` represents `k` squares.
-   **Final Answer:** The total number of squares is the sum of all values in the `dp` table.
-   **Space Optimization:** The input matrix can be used as the DP table to achieve O(1) extra space.

#### Python Code Snippet
```python
def count_squares(matrix: list[list[int]]) -> int:
    m, n = len(matrix), len(matrix[0])
    count = 0
    # The input matrix can be used as the DP table
    for i in range(m):
        for j in range(n):
            if matrix[i][j] == 1:
                if i > 0 and j > 0:
                    matrix[i][j] = 1 + min(matrix[i-1][j], matrix[i][j-1], matrix[i-1][j-1])
                count += matrix[i][j]
    return count
```

---

### 2. Maximal Rectangle
`[HARD]` `#dp-on-squares` `#grid-dp` `#histogram` `#stack`

#### Problem Statement
Given a `m x n` binary matrix filled with 0s and 1s, find the largest rectangle containing only 1s and return its area.

*Example:* `matrix = [["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]]`. **Output:** `6`.

#### Implementation Overview
This problem is famously solved by reducing it to the "Largest Rectangle in Histogram" problem for each row.
-   **Algorithm:**
    1.  Create a `height` array of size `n` (the number of columns), initialized to zeros.
    2.  Iterate through each `row` of the matrix.
        a.  For each `col`, update the `height` array: `height[col] += 1` if `matrix[row][col] == '1'`, else `height[col] = 0`.
        b.  This `height` array now represents a histogram. Calculate the largest rectangle area in this histogram using a monotonic stack.
        c.  Update the overall `max_area`.
-   **Largest Rectangle in Histogram (Subproblem):**
    -   Use a monotonic stack to find the previous and next smaller elements for each bar, which define the width of the rectangle for which that bar is the minimum height.

#### Python Code Snippet
```python
def maximal_rectangle(matrix: list[list[str]]) -> int:
    if not matrix or not matrix[0]:
        return 0

    m, n = len(matrix), len(matrix[0])
    heights = [0] * n
    max_area = 0

    def largest_rectangle_in_histogram(h: list[int]) -> int:
        stack = [-1]
        max_h_area = 0
        for i, height in enumerate(h):
            while stack[-1] != -1 and h[stack[-1]] >= height:
                h_pop = h[stack.pop()]
                w = i - stack[-1] - 1
                max_h_area = max(max_h_area, h_pop * w)
            stack.append(i)

        while stack[-1] != -1:
            h_pop = h[stack.pop()]
            w = len(h) - stack[-1] - 1
            max_h_area = max(max_h_area, h_pop * w)
        return max_h_area

    for i in range(m):
        for j in range(n):
            heights[j] = heights[j] + 1 if matrix[i][j] == '1' else 0

        max_area = max(max_area, largest_rectangle_in_histogram(heights))

    return max_area
```
