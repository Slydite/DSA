# Pattern 5: Advanced Binary Search

This pattern covers the most complex applications of binary search. These problems often involve searching for a "partition" or "cut" within the data rather than a specific value, or performing a search on a continuous (floating-point) answer space. These are among the hardest binary search problems.

---

### 1. Median of 2 Sorted Arrays
`[HARD]` `[TRICK]` `#binary-search-on-partition`

#### Problem Statement
Given two sorted arrays `nums1` and `nums2`, return the median of the two combined sorted arrays. The overall run time complexity should be O(log (m+n)).

#### Implementation Overview
This is solved by **binary searching on a potential partition**. The goal is to find a "cut" in the smaller array that, with a corresponding cut in the larger array, partitions the combined elements into a valid left/right half.
1.  **Setup:** Ensure `nums1` is the smaller array to limit the search space `[0, len(nums1)]`.
2.  **Binary Search on Partitions:**
    -   Pick a `cut1` in `nums1`. Calculate the corresponding `cut2` in `nums2`.
    -   Identify the four boundary elements: `left1`, `right1`, `left2`, `right2`.
    -   **Check for Correctness:** A valid partition is found if `left1 <= right2` AND `left2 <= right1`.
    -   **Adjust Search:** If `left1 > right2`, our cut is too far right (`high = cut1 - 1`). If `left2 > right1`, our cut is too far left (`low = cut1 + 1`).
    -   If the partition is valid, the median can be calculated from `max(left1, left2)` and `min(right1, right2)`.

#### Python Code Snippet
```python
def find_median_sorted_arrays(nums1, nums2):
    if len(nums1) > len(nums2):
        nums1, nums2 = nums2, nums1

    m, n = len(nums1), len(nums2)
    low, high = 0, m

    while low <= high:
        cut1 = low + (high - low) // 2
        cut2 = (m + n + 1) // 2 - cut1

        left1 = nums1[cut1 - 1] if cut1 != 0 else float('-inf')
        right1 = nums1[cut1] if cut1 != m else float('inf')

        left2 = nums2[cut2 - 1] if cut2 != 0 else float('-inf')
        right2 = nums2[cut2] if cut2 != n else float('inf')

        if left1 <= right2 and left2 <= right1:
            if (m + n) % 2 == 0:
                return (max(left1, left2) + min(right1, right2)) / 2.0
            else:
                return float(max(left1, left2))
        elif left1 > right2:
            high = cut1 - 1
        else:
            low = cut1 + 1
```
#### Related Problems
- `Kth element of 2 sorted arrays` uses the exact same partition logic.

---

### 2. Kth Element of 2 Sorted Arrays
`[HARD]` `[TRICK]` `#binary-search-on-partition`

#### Problem Statement
Given two sorted arrays, find the k-th smallest element in their merged, sorted form.

#### Implementation Overview
This uses the same logic as the Median problem. The goal is to find a partition such that `k` elements are in the combined left half.
1.  Binary search for a `cut1` in the smaller array.
2.  Calculate `cut2 = k - cut1`.
3.  Check the partition validity with `left1 <= right2` and `left2 <= right1`.
4.  If valid, the answer is `max(left1, left2)`. Adjust the search space otherwise.

---

### 3. Minimize Max Distance to Gas Station
`[HARD]` `[TRICK]` `#binary-search-on-answer` `#continuous-space`

#### Problem Statement
Given sorted `stations` positions and `k` new stations to place, minimize the maximum distance between any two adjacent stations.

#### Implementation Overview
This is a "BS on Answers" on a continuous (floating-point) space.
1.  **Search Space:** The answer (max distance `d`) is between `0` and `stations[n-1] - stations[0]`.
2.  **Predicate `is_possible(d)`:** Can we place `k` or fewer stations to satisfy a max distance of `d`? For each existing gap, calculate stations needed: `ceil(gap_len / d) - 1`. Sum these up. If `total_required <= k`, return `true`.
3.  **Binary Search:** Run the loop for a fixed number of iterations (e.g., 100) or until `high - low` is tiny. If `is_possible(mid)`, try for a smaller distance: `ans = mid`, `high = mid`. Else, `low = mid`.

---

### 4. Matrix Median
`[HARD]` `#binary-search-on-answer`

#### Problem Statement
Given a row-wise sorted matrix `A`, find the median of all its elements.

#### Implementation Overview
The median is the element with `(R*C)/2` elements smaller than or equal to it. This is a "BS on Answers" problem.
1.  **Search Space:** The answer is between the min and max possible values in the matrix.
2.  **Predicate `count_less_equal(val)`:** Count how many elements in the matrix are `<= val`. Since rows are sorted, use binary search (`upper_bound`) on each row to find this count in O(R * logC) time.
3.  **Binary Search:** If `count_less_equal(mid) <= (R*C)/2`, `mid` is too small, so `low = mid + 1`. Else, `mid` is a potential answer, so `ans = mid`, `high = mid - 1`.

---

### 5. Kth Missing Positive Number
`[EASY]` `[TRICK]` `#binary-search` `#observation`

#### Problem Statement
Given a sorted array of positive integers `arr` and an integer `k`, find the `k`-th positive integer that is missing from this array.

#### Implementation Overview
The key observation is that for any index `i`, the number of missing elements up to that point is `arr[i] - (i + 1)`.
1.  **Search Space:** Search on the indices `low = 0`, `high = n - 1`.
2.  **Binary Search Logic:** Find `mid`. Calculate `missing_count = arr[mid] - (mid + 1)`.
    -   If `missing_count < k`, the `k`-th missing number is to the right. `low = mid + 1`.
    -   If `missing_count >= k`, the `k`-th missing number is at or to the left. `high = mid - 1`.
3.  **Result:** The loop finds the tipping point. The answer is `k + low`.
