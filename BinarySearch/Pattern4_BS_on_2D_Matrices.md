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

**Example:** `matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]]`, `target = 3`. **Output:** `true`.

#### Implementation Overview
Because of the matrix's properties, it can be treated as a single, large, sorted 1D array of size `m * n`. We can perform a standard binary search on this "flattened" array.
1.  **Search Space:** The logical indices range from `0` to `m*n - 1`.
2.  **Binary Search:**
    -   Initialize `low = 0`, `high = m*n - 1`.
    -   In each step, calculate the logical `mid` index.
    -   **Convert `mid` to 2D coordinates:** The trick is to map the 1D `mid` index back to a 2D `(row, col)` pair.
        -   `row = mid // n` (where `n` is the number of columns)
        -   `col = mid % n`
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
        # Convert 1D index to 2D coordinates
        row = mid_idx // n
        col = mid_idx % n
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
Given an `m x n` matrix where each row is sorted and each column is sorted. Write an efficient algorithm that searches for a `target` value.

**Example:** `matrix = [[1,4,7,11],[2,5,8,12],[3,6,9,16],[10,13,14,17]]`, `target = 5`. **Output:** `true`.

#### Implementation Overview
While this can be solved with binary search (e.g., binary searching each row), the most elegant and efficient solution is a "stair-step search" that is not a true binary search but has a similar O(log-like) time complexity of O(m+n).
1.  **Starting Point:** Start at a strategic corner. The top-right corner (`row = 0`, `col = n-1`) is a great choice.
2.  **Search Logic:**
    -   Loop while the pointers are within the matrix bounds.
    -   Let the current element be `curr = matrix[row][col]`.
    -   If `curr == target`, return `true`.
    -   If `curr > target`, the target cannot be in the current column (since the column is sorted). So, eliminate the column by moving left: `col -= 1`.
    -   If `curr < target`, the target cannot be in the current row (since the row is sorted). So, eliminate the row by moving down: `row += 1`.
3.  If the loop finishes, the element was not found.

---

### 3. Find Peak Element in a 2D Matrix
`[HARD]` `#binary-search` `#2d-array`

#### Problem Statement
A peak element in a 2D grid is an element that is strictly greater than all of its adjacent neighbors (up, down, left, and right). Find and return the coordinates of any peak element.

#### Implementation Overview
This is a clever application of binary search on the columns of the matrix.
1.  **Search Space:** Binary search on the column indices, from `low = 0` to `high = n - 1`.
2.  **Binary Search on Columns:**
    -   In each step, pick a `mid` column.
    -   Find the **global maximum** element in this `mid` column. Let its row be `max_row`.
    -   The element `matrix[max_row][mid]` is our candidate peak.
    -   **Check Neighbors:** Check its left and right neighbors (`matrix[max_row][mid-1]` and `matrix[max_row][mid+1]`).
        -   If it's greater than both, it's a peak. Return `[max_row, mid]`.
        -   If the left neighbor is greater, a peak is guaranteed to exist in the left half of the matrix. So, `high = mid - 1`.
        -   If the right neighbor is greater, a peak is guaranteed to exist in the right half. So, `low = mid + 1`.
This works because finding the global max in a column ensures there is no "uphill" path upwards or downwards from our candidate. We only need to check left and right.

---

### 4. Find the Row with Maximum Number of 1's
`[EASY]` `#binary-search` `#2d-array`

#### Problem Statement
Given a binary matrix (containing only 0s and 1s) where each row is sorted, find the row with the maximum number of 1s.

#### Implementation Overview
A naive solution is to count the 1s in each row (O(m*n)). A better solution uses binary search to find the *first occurrence* of 1 in each row.
1.  Initialize `max_ones = 0` and `result_row_index = -1`.
2.  Iterate through each row of the matrix.
3.  For each row, use binary search (or `lower_bound`) to find the index of the first `1`.
4.  The number of ones in that row is `n - first_one_index`.
5.  Compare this count with `max_ones` and update the result if a new maximum is found.

#### Alternative
The stair-step search from problem #2 can also be adapted here for an O(m+n) solution, which is often better than the O(m*log(n)) binary search approach. Start at the top-right corner and move left if you see a `1`, and down if you see a `0`.
