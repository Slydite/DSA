# Pattern 3: DP on Squares

This is a mini-pattern that deals with problems on a 2D grid (matrix) where the goal is to find the largest square or rectangle of a certain type, or to count the total number of such shapes. The DP state `dp[i][j]` typically stores information about the size or property of a shape ending at the cell `(i, j)`.

---

### 1. Count Square Submatrices with All Ones (DP-56)
`[HARD]` `#dp-on-squares` `#grid-dp`

#### Problem Statement
Given a `m x n` matrix of ones and zeros, return how many square submatrices have all ones.

#### Implementation Overview
This problem can be solved efficiently using a single DP pass.
-   **DP State:** `dp[i][j]` = the side length of the largest square of all ones whose **bottom-right corner** is at `(i, j)`.
-   **Recurrence Relation:**
    -   If `matrix[i][j] == 0`, then no square can end here, so `dp[i][j] = 0`.
    -   If `matrix[i][j] == 1`, a square can only be formed if the cells to its left, top, and top-left also form squares. The size of the new square is limited by the smallest of these three neighboring squares.
        `dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])`.
-   **Insight for Counting:** The value `dp[i][j]` doesn't just tell us the size of the *largest* square ending at `(i, j)`. It also tells us the *total number* of squares ending at `(i, j)`. A `dp[i][j]` value of `k` means there is a `k x k` square, a `(k-1) x (k-1)` square, ..., and a `1 x 1` square all ending at this same corner. Therefore, `dp[i][j]` represents `k` squares.
-   **Final Answer:** The total number of square submatrices is the sum of all values in the `dp` table.
-   **Space Optimization:** The input matrix can be used as the DP table to achieve O(1) extra space.

---

### 2. Maximum Rectangle Area with all 1's (DP-55)
`[HARD]` `#dp-on-squares` `#grid-dp` `#histogram` `#stack`

#### Problem Statement
Given a `m x n` binary matrix filled with 0s and 1s, find the largest rectangle containing only 1s and return its area.

#### Implementation Overview
This problem is famously solved by reducing it to the "Largest Rectangle in Histogram" problem for each row.
-   **Algorithm:**
    1.  Initialize `max_area = 0`.
    2.  Create a `height` array of size `n` (the number of columns), initialized to zeros.
    3.  Iterate through each `row` of the matrix from top to bottom.
        a.  For each `col` in the current `row`, update the `height` array:
            -   If `matrix[row][col] == 1`, then `height[col] += 1`.
            -   If `matrix[row][col] == 0`, then the streak of 1s is broken, so `height[col] = 0`.
        b.  After updating the `height` array for the current row, it now represents a histogram.
        c.  Calculate the largest rectangle area in this histogram. This is a standard problem solvable in O(n) using a monotonic stack.
        d.  Update `max_area = max(max_area, largest_area_in_histogram)`.
-   **Largest Rectangle in Histogram (Subproblem):**
    -   Use a monotonic stack to keep track of the indices of bars in increasing order of height.
    -   When you encounter a bar that is shorter than the one at the top of the stack, you pop from the stack. For each popped bar, you calculate the area it could form. The width of the rectangle is from the current index to the index of the new top of the stack.
-   **Final Answer:** The `max_area` after processing all rows. The overall time complexity is O(m * n).
