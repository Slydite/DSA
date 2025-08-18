# Pattern 6: Matrix Problems

This pattern covers problems that involve 2D arrays (matrices). These problems often require clever in-place manipulation, simulated traversal, or dynamic programming for generation.

---

### 1. Set Matrix Zeros
`[MEDIUM]` `[TRICK]`
- **Problem:** If an element in an `m x n` matrix is 0, set its entire row and column to 0. This must be done in-place.
- **Overview (O(1) Space):** The key is to use the first row and first column of the matrix itself as markers.
    1.  First, check if the original first row/column contain a zero and store this in two boolean flags.
    2.  Iterate through the rest of the matrix (`[1,1]` onwards). If `matrix[i][j] == 0`, mark `matrix[i][0] = 0` and `matrix[0][j] = 0`.
    3.  Iterate through the rest of the matrix again. If an element's corresponding marker in the first row or column is 0, set the element to 0.
    4.  Finally, use the initial boolean flags to zero out the first row and column if necessary.

---

### 2. Rotate Matrix by 90 Degrees
`[MEDIUM]` `[FUNDAMENTAL]`
- **Problem:** Rotate an `n x n` matrix by 90 degrees clockwise, in-place.
- **Overview:** This is best achieved with a two-step process:
    1.  **Transpose the matrix:** Swap `matrix[i][j]` with `matrix[j][i]`.
    2.  **Reverse each row:** Iterate through each row and reverse its elements.

---

### 3. Print the Matrix in Spiral Manner
`[MEDIUM]` `[FUNDAMENTAL]`
- **Problem:** Given an `m x n` matrix, return all its elements in spiral order.
- **Overview:** This is a simulation problem using four pointers to define the boundaries of the current layer: `top`, `bottom`, `left`, `right`.
    - Loop while `top <= bottom` and `left <= right`. In each iteration:
        1. Traverse right along the `top` row, then increment `top`.
        2. Traverse down along the `right` column, then decrement `right`.
        3. Traverse left along the `bottom` row (if `top <= bottom`), then decrement `bottom`.
        4. Traverse up along the `left` column (if `left <= right`), then increment `left`.

---

### 4. Pascal's Triangle
`[EASY]`
- **Problem:** Given `numRows`, generate the first `numRows` of Pascal's triangle.
- **Overview:** This is a generation problem where each row is built from the previous one.
    - Start with the first row `[1]`.
    - Loop from `i = 1` to `numRows - 1`.
    - Each new row starts and ends with `1`. The elements in between are the sum of the two elements directly above them in the previous row: `new_row[j] = prev_row[j-1] + prev_row[j]`.
- **Variations:**
    - **Get a specific element `(r, c)`:** Use the combination formula `C(r, c)`.
    - **Get a specific row:** Use O(k) space by calculating the row iteratively.
