# Pattern 5: Advanced Binary Search

This pattern covers the most complex applications of binary search. These problems often involve searching for a "partition" or "cut" within the data rather than a specific value, or performing a search on a continuous (floating-point) answer space. These are among the hardest binary search problems.

---

### 1. Median of 2 Sorted Arrays / Kth Element of 2 Sorted Arrays
`[HARD]` `[TRICK]` `#binary-search-on-partition`

#### Problem Statement
- **Median:** Given two sorted arrays `nums1` and `nums2`, return the median of the two combined sorted arrays. The overall run time complexity should be O(log (m+n)).
- **Kth Element:** Given two sorted arrays, find the k-th smallest element in their merged, sorted form.

#### Implementation Overview
These two problems are solved with the same core algorithm: **binary search on a potential partition**. The goal is to find a "cut" in the smaller array that, along with a corresponding cut in the larger array, partitions the combined elements into a left half and a right half, where all elements in the left are less than or equal to all elements in the right.

1.  **Setup:** Ensure `nums1` is the smaller array to limit the search space. The binary search will be on the possible cut points in `nums1`. The search space for the cut is `[0, len(nums1)]`.
2.  **Binary Search on Partitions:**
    -   In each step, pick a potential cut in `nums1`, let's call it `cut1`.
    -   The corresponding cut in `nums2`, `cut2`, is determined by the need to have a fixed number of elements in the combined left partition: `cut2 = (m+n+1)/2 - cut1`.
    -   **Identify Partition Elements:** From these cuts, identify the four key elements:
        -   `left1`: The rightmost element in the left partition of `nums1`.
        -   `right1`: The leftmost element in the right partition of `nums1`.
        -   `left2`: The rightmost element in the left partition of `nums2`.
        -   `right2`: The leftmost element in the right partition of `nums2`.
        (Handle edge cases where a partition is empty by using +/- infinity).
    -   **Check for Correctness:** A valid partition is found if `left1 <= right2` AND `left2 <= right1`.
    -   **Adjust Search:**
        -   If the partition is valid, we have found the answer. The median is `(max(left1, left2) + min(right1, right2)) / 2` (for even total length) or `max(left1, left2)` (for odd total length). For the Kth element problem, the answer is `max(left1, left2)`.
        -   If `left1 > right2`, our cut in `nums1` is too far to the right. We need to move it left: `high = cut1 - 1`.
        -   If `left2 > right1`, our cut in `nums1` is too far to the left. We need to move it right: `low = cut1 + 1`.

#### Python Code Snippet (Median of 2 Sorted Arrays)
```python
def find_median_sorted_arrays(nums1, nums2):
    if len(nums1) > len(nums2):
        nums1, nums2 = nums2, nums1 # Ensure nums1 is smaller

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
            # Correct partition found
            if (m + n) % 2 == 0:
                return (max(left1, left2) + min(right1, right2)) / 2.0
            else:
                return max(left1, left2)
        elif left1 > right2:
            high = cut1 - 1 # Move cut in nums1 to the left
        else:
            low = cut1 + 1 # Move cut in nums1 to the right
```

---

### 2. Minimize Max Distance to Gas Station
`[HARD]` `[TRICK]` `#binary-search-on-answer` `#continuous-space`

#### Problem Statement
You are given a sorted array `stations` representing positions on a number line. You have `k` new gas stations to place. Find the arrangement that minimizes the maximum distance between any two adjacent stations.

#### Implementation Overview
This is a "BS on Answers" problem, but the answer space is continuous (a floating-point number), not discrete.
1.  **Search Space:** The answer (max distance `d`) can range from `0` to the largest initial distance between two stations. `low = 0`, `high = stations[n-1] - stations[0]`.
2.  **Predicate `is_possible(d)`:**
    -   Given a maximum allowed distance `d`, can we place `k` or fewer new stations to satisfy it?
    -   Iterate through the existing gaps between stations. For a gap of size `gap_len`, the number of new stations needed is `ceil(gap_len / d) - 1`.
    -   Sum these required stations. If `total_required_stations <= k`, return `true`.
3.  **Binary Search:**
    -   This is a search on a continuous space. We can't use the standard `low <= high` integer template. Instead, we run the loop for a fixed number of iterations (e.g., 100) or until `high - low` is smaller than a tiny epsilon (e.g., `1e-6`) to guarantee precision.
    -   If `is_possible(mid)` is true, `mid` is a possible answer. We try for a smaller distance: `ans = mid`, `high = mid`.
    -   If false, `mid` is too small a distance. We need to allow a larger distance: `low = mid`.

---

### 3. Matrix Median
`[HARD]` `#binary-search-on-answer`

#### Problem Statement
Given a row-wise sorted matrix `A` of size `R x C`, find the median of the matrix.

#### Implementation Overview
The median is the element that would be at the center if the whole matrix were flattened and sorted. The number of elements less than or equal to the median is `(R*C)/2`. This gives us a clue for "BS on Answers".
1.  **Search Space:** The answer (the median value) must be between the minimum and maximum possible values in the matrix. Let `low = 1`, `high = 1e9` (or find the actual min/max).
2.  **Predicate `count_less_equal(val)`:**
    -   This function counts how many elements in the entire matrix are less than or equal to `val`.
    -   Since each row is sorted, we can do this efficiently. For each row, use binary search (`upper_bound`) to find the number of elements `<= val`.
    -   Sum these counts across all rows.
3.  **Binary Search:**
    -   If `count_less_equal(mid) <= (R*C)/2`, it means `mid` is too small to be the median. We need to look for a larger value: `low = mid + 1`.
    -   If `count_less_equal(mid) > (R*C)/2`, `mid` could be the median. We store it and try for a smaller value: `ans = mid`, `high = mid - 1`.

---

### 4. Kth Missing Positive Number
`[EASY]` `[TRICK]` `#binary-search` `#observation`

#### Problem Statement
Given a sorted array of positive integers `arr` and an integer `k`, find the `k`-th positive integer that is missing from this array.

**Example:** `arr = [2,3,4,7,11]`, `k = 5`. The missing numbers are `1, 5, 6, 8, 9, 10, ...`. The 5th missing number is `9`.

#### Implementation Overview
The key observation is that for any index `i`, the number of positive integers missing before or at that index is `arr[i] - (i + 1)`. For example, if `arr[0] = 2`, `2 - (0+1) = 1` number is missing before it (the number 1). If `arr[3] = 7`, `7 - (3+1) = 3` numbers are missing (`1, 5, 6`).

We can use binary search to find the correct "spot" in the array where the k-th missing number would be.
1.  **Search Space:** We search on the indices of the array, `low = 0`, `high = n - 1`.
2.  **Binary Search Logic:**
    -   Calculate `mid`. Find the number of missing elements up to `mid`: `missing_count = arr[mid] - (mid + 1)`.
    -   If `missing_count < k`, the `k`-th missing number must be to the right of `mid`, as not enough numbers are missing yet. So, `low = mid + 1`.
    -   If `missing_count >= k`, the `k`-th missing number could be at or to the left of `mid`. So, `high = mid - 1`.
3.  **Result:** The loop terminates when `low` points to the first index where the number of missing elements is `>= k`. The `high` pointer will be just to the left of this. The number of missing elements up to `high` is `arr[high] - (high + 1)`. The `k`-th missing number is `k` plus the number of elements *not* missing up to that point, which is `high + 1`. So, the answer is `k + high + 1`, which simplifies to `k + low`.

---

### 4. Kth Missing Positive Number
`[EASY]` `[TRICK]` `#binary-search` `#observation`

#### Problem Statement
Given a sorted array of positive integers `arr` and an integer `k`, find the `k`-th positive integer that is missing from this array.

**Example:** `arr = [2,3,4,7,11]`, `k = 5`. The missing numbers are `1, 5, 6, 8, 9, 10, ...`. The 5th missing number is `9`.

#### Implementation Overview
The key observation is that for any index `i`, the number of positive integers missing before or at that index is `arr[i] - (i + 1)`. For example, if `arr[0] = 2`, `2 - (0+1) = 1` number is missing (the number 1). If `arr[3] = 7`, `7 - (3+1) = 3` numbers are missing (`1, 5, 6`).

We can use binary search to find the "tipping point" where the number of missing elements becomes `>= k`.
1.  **Search Space:** We search on the indices of the array, `low = 0`, `high = n - 1`.
2.  **Binary Search Logic:**
    -   Calculate `mid`. Find the number of missing elements up to `mid`: `missing_count = arr[mid] - (mid + 1)`.
    -   If `missing_count < k`, the `k`-th missing number must be to the right of `mid`, as not enough numbers are missing yet. So, `low = mid + 1`.
    -   If `missing_count >= k`, the `k`-th missing number could be at or to the left of `mid`. So, `high = mid - 1`.
3.  **Result:** The loop terminates when `low` points to the first index where the number of missing elements is `>= k`. The `high` pointer will be just to the left of this. The number of missing elements up to `high` is `arr[high] - (high + 1)`. The `k`-th missing number is `k` plus the number of elements *not* missing up to that point, which is `high + 1`. So, the answer is `k + high + 1`, which simplifies to `k + low`.
