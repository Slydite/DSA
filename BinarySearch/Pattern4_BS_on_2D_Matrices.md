# Pattern 4: Binary Search on 2D Matrices

This pattern covers techniques for applying binary search principles to 2D arrays (matrices). The key is often to find a way to logically "flatten" the 2D space into a 1D search space or to use the matrix's properties to eliminate rows and columns efficiently.

---

### 1. Search in a 2D Matrix
`[MEDIUM]` `#binary-search` `#2d-array`

#### Problem Statement
You are given an `m x n` integer matrix with the following two properties:
1.  Each row is sorted in non-decreasing order.
2.  The first integer of each row is greater than the last integer of the previous row.
Given an integer `target`, return `true` if `target` is in `matrix` or `false` otherwise.

*Example:*
- **Input:** `matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]]`, `target = 3`
- **Output:** `true`

#### Implementation Overview
Because of the matrix's properties, it can be treated as a single, large, sorted 1D array of size `m * n`. We can perform a standard binary search on this "flattened" array without actually creating it.
1.  **Search Space:** The logical indices range from `0` to `m*n - 1`.
2.  **Binary Search:**
    -   Initialize `low = 0`, `high = m*n - 1`.
    -   In each step, calculate the logical `mid` index.
    -   **Convert `mid` to 2D coordinates:** The trick is to map the 1D `mid` index back to a 2D `(row, col)` pair: `row = mid // n`, `col = mid % n`, where `n` is the number of columns.
    -   Compare `matrix[row][col]` with the `target` and adjust `low` and `high` as in a standard binary search.

#### Python Code Snippet
```python
def search_matrix(matrix, target):
    if not matrix or not matrix[0]:
        return False

    m, n = len(matrix), len(matrix[0])
    low, high = 0, m * n - 1

    while low <= high:
        mid_idx = low + (high - low) // 2
        row, col = mid_idx // n, mid_idx % n
        mid_val = matrix[row][col]

        if mid_val == target:
            return True
        elif mid_val < target:
            low = mid_idx + 1
        else:
            high = mid_idx - 1

    return False
```

---

### 2. Search in a Row and Column Wise Sorted Matrix
`[MEDIUM]` `#two-pointers` `#stair-step-search`

#### Problem Statement
Given an `m x n` matrix where each row is sorted in ascending order and each column is also sorted in ascending order. Write an efficient algorithm that searches for a `target` value.

*Example:*
- **Input:** `matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]]`, `target = 5`
- **Output:** `true`

#### Implementation Overview
Binary searching a single row is inefficient. The most elegant solution is a "stair-step search" with O(m+n) complexity, which cleverly eliminates a row or column in each step.
1.  **Starting Point:** Start at the top-right corner (`row = 0`, `col = n-1`). This point is the smallest in its column and the largest in its row.
2.  **Search Logic:**
    -   If the current element equals the `target`, return `true`.
    -   If the `current` element is greater than the `target`, the target cannot be in the current column (since all elements below are even larger). So, we can eliminate the entire column by moving left: `col -= 1`.
    -   If the `current` element is less than the `target`, the target cannot be in the current row (since all elements to the left are even smaller). So, we can eliminate the entire row by moving down: `row += 1`.
3.  If the pointers go out of bounds, the element was not found.

#### Python Code Snippet
```python
def search_in_sorted_matrix(matrix, target):
    if not matrix or not matrix[0]:
        return False

    m, n = len(matrix), len(matrix[0])
    row, col = 0, n - 1

    while row < m and col >= 0:
        current = matrix[row][col]
        if current == target:
            return True
        elif current > target:
            col -= 1
        else:
            row += 1

    return False
```

---

### 3. Find Peak Element in a 2D Matrix
`[MEDIUM]` `#binary-search` `#2d-array` `#divide-and-conquer`

#### Problem Statement
A peak element in a 2D grid is an element that is strictly greater than all of its adjacent neighbors (up, down, left, and right). Find and return the coordinates `[row, col]` of any peak element.

*Example:*
- **Input:** `mat = [[10,20,15],[21,30,14],[7,16,32]]`
- **Output:** `[1, 1]` (30 is a peak) or `[2, 2]` (32 is a peak)

#### Implementation Overview
We can apply binary search on the columns of the matrix to reduce the search space.
1.  **Search Space:** Binary search on the column indices, from `low = 0` to `high = n - 1`.
2.  **Binary Search on Columns:**
    -   In each step, pick a `mid_col`.
    -   Find the **global maximum** element in this `mid_col`. Let its row be `max_row`.
    -   The element `mat[max_row][mid_col]` is our candidate peak. It's already greater than its top and bottom neighbors. We only need to check its left and right neighbors.
    -   If the left neighbor (`mat[max_row][mid_col - 1]`) is greater, a peak is guaranteed to exist in the left half of the matrix. So, we search left: `high = mid_col - 1`.
    -   If the right neighbor (`mat[max_row][mid_col + 1]`) is greater, a peak is guaranteed to exist in the right half. So, we search right: `low = mid_col + 1`.
    -   If neither neighbor is greater, we have found a peak.

#### Python Code Snippet
```python
def find_peak_grid(mat):
    low_col, high_col = 0, len(mat[0]) - 1

    while low_col <= high_col:
        mid_col = low_col + (high_col - low_col) // 2

        # Find the max element in the mid_col
        max_row = 0
        for i in range(len(mat)):
            if mat[i][mid_col] > mat[max_row][mid_col]:
                max_row = i

        # Check if this element is a peak
        is_peak = True
        # Check left neighbor
        if mid_col > 0 and mat[max_row][mid_col] < mat[max_row][mid_col - 1]:
            is_peak = False
            high_col = mid_col - 1
        # Check right neighbor
        elif mid_col < len(mat[0]) - 1 and mat[max_row][mid_col] < mat[max_row][mid_col + 1]:
            is_peak = False
            low_col = mid_col + 1

        if is_peak:
            return [max_row, mid_col]

    return [-1, -1] # Should not be reached
```

---

### 4. Find the Row with Maximum Number of 1's
`[EASY]` `#binary-search` `#2d-array`

#### Problem Statement
Given a binary matrix where each row is sorted, find the 0-based index of the row with the maximum number of 1s. If there is a tie, return the smaller row index.

*Example:*
- **Input:** `mat = [[0,1,1,1],[0,0,1,1],[1,1,1,1],[0,0,0,0]]`
- **Output:** `2` (Row 2 has four 1s)

#### Implementation Overview
**Method 1: Binary Search each row (O(M log N))**
1.  Initialize `max_ones_count = 0` and `result_row_index = -1`.
2.  Iterate through each row `i` from `0` to `m-1`.
3.  For each row, use binary search (`lower_bound`) to find the index of the first `1`.
4.  The number of ones in that row is `n - first_one_index`.
5.  If this count is greater than `max_ones_count`, update `max_ones_count` and `result_row_index`.

**Method 2: Stair-step search (O(M + N))**
1. Start at the top-right corner (`row = 0`, `col = n-1`).
2. If `mat[row][col] == 1`, it means this entire column from this row down cannot be the start of a longer sequence of 1s than what we've found. We can move left to find more 1s in the current row. `col -= 1`.
3. If `mat[row][col] == 0`, it means this row cannot have the most 1s (since we are moving from the right). Move down to the next row: `row += 1`.
4. Keep track of the row index with the most 1s found.

#### Python Code Snippet (Method 2)
```python
def row_with_max_ones(mat):
    if not mat or not mat[0]:
        return -1

    m, n = len(mat), len(mat[0])
    row, col = 0, n - 1
    max_row_index = -1

    while row < m and col >= 0:
        if mat[row][col] == 1:
            # This row is a candidate, record it and search for more 1s to the left
            max_row_index = row
            col -= 1
        else:
            # This row can't have the most 1s, move to the next row
            row += 1

    return max_row_index
```
