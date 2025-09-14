# Pattern 5: Advanced Binary Search

This pattern covers the most complex applications of binary search. These problems often involve searching for a "partition" or "cut" within the data rather than a specific value, or performing a search on a continuous (floating-point) answer space. These are among the hardest binary search problems.

---

### 1. Median of 2 Sorted Arrays
`[HARD]` `#binary-search-on-partition`

#### Problem Statement
Given two sorted arrays `nums1` and `nums2` of size `m` and `n` respectively, return the median of the two combined sorted arrays. The overall run time complexity should be O(log (m+n)).

*Example:*
- **Input:** `nums1 = [1,3]`, `nums2 = [2]`
- **Output:** `2.0`
- **Input:** `nums1 = [1,2]`, `nums2 = [3,4]`
- **Output:** `2.5`

#### Implementation Overview
This is solved by **binary searching on a potential partition**. The goal is to find a "cut" in the smaller array that, with a corresponding cut in the larger array, partitions the combined elements into a valid left and right half. A valid partition means every element in the combined left half is less than or equal to every element in the combined right half.
1.  **Setup:** Ensure `nums1` is the smaller array to limit the search space `[0, m]`.
2.  **Binary Search on Partitions:**
    -   Pick a `cut1` in `nums1`. The corresponding `cut2` in `nums2` is determined by the total number of elements needed in the combined left half: `(m + n + 1) // 2`.
    -   Identify the four boundary elements: `left1`, `right1`, `left2`, `right2`. These are the elements immediately to the left and right of each cut. Handle edge cases where a cut is at the beginning or end of an array.
    -   **Check for Correctness:** A valid partition is found if `left1 <= right2` AND `left2 <= right1`.
    -   **Adjust Search:** If `left1 > right2`, our cut in `nums1` is too far right (`high = cut1 - 1`). If `left2 > right1`, our cut is too far left (`low = cut1 + 1`).
    -   If the partition is valid, the median can be calculated from `max(left1, left2)` (for odd total length) or `(max(left1, left2) + min(right1, right2)) / 2` (for even total length).

#### Python Code Snippet
```python
def find_median_sorted_arrays(nums1, nums2):
    if len(nums1) > len(nums2):
        nums1, nums2 = nums2, nums1

    m, n = len(nums1), len(nums2)
    low, high = 0, m
    total_len_half = (m + n + 1) // 2

    while low <= high:
        cut1 = low + (high - low) // 2
        cut2 = total_len_half - cut1

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
    return 0.0 # Should not be reached
```
#### Related Problems
- `Kth element of 2 sorted arrays` uses the exact same partition logic.

---

### 2. Kth Element of 2 Sorted Arrays
`[HARD]` `#binary-search-on-partition`

#### Problem Statement
Given two sorted arrays, `arr1` and `arr2` of size `m` and `n` respectively, find the k-th smallest element in their merged, sorted form.

*Example:*
- **Input:** `arr1 = [2, 3, 6, 7, 9]`, `arr2 = [1, 4, 8, 10]`, `k = 5`
- **Output:** `6`

#### Implementation Overview
This uses the same partition logic as the Median problem. The goal is to find a partition such that exactly `k` elements are in the combined left half. The k-th element will then be `max(left1, left2)`.
1.  Binary search for a `cut1` in the smaller array.
2.  Calculate `cut2 = k - cut1`. Handle edge cases where `k` might be larger than one of the array lengths.
3.  Check the partition validity with `left1 <= right2` and `left2 <= right1`.
4.  If valid, the answer is `max(left1, left2)`. Adjust the search space otherwise.

#### Python Code Snippet
```python
def kth_element(arr1, arr2, k):
    if len(arr1) > len(arr2):
        arr1, arr2 = arr2, arr1

    m, n = len(arr1), len(arr2)
    # Adjust search space for k
    low = max(0, k - n)
    high = min(k, m)

    while low <= high:
        cut1 = low + (high - low) // 2
        cut2 = k - cut1

        l1 = arr1[cut1 - 1] if cut1 > 0 else float('-inf')
        l2 = arr2[cut2 - 1] if cut2 > 0 else float('-inf')
        r1 = arr1[cut1] if cut1 < m else float('inf')
        r2 = arr2[cut2] if cut2 < n else float('inf')

        if l1 <= r2 and l2 <= r1:
            return max(l1, l2)
        elif l1 > r2:
            high = cut1 - 1
        else:
            low = cut1 + 1
    return -1 # Should not be reached
```

---

### 3. Minimize Max Distance to Gas Station
`[HARD]` `#binary-search-on-answer` `#continuous-space`

#### Problem Statement
Given a sorted array `stations` of positions on a number line and an integer `k` representing the number of new gas stations to add, find the smallest possible value of the maximum distance between any two adjacent stations after adding `k` new stations.

*Example:*
- **Input:** `stations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`, `k = 9`
- **Output:** `0.5`

#### Implementation Overview
This is a "BS on Answers" on a continuous (floating-point) search space.
1.  **Search Space:** The answer (max distance `d`) is between `0` and the largest initial gap, `stations[n-1] - stations[0]`.
2.  **Predicate `is_possible(d)`:** Can we place `k` or fewer stations to ensure no gap is larger than `d`?
    - For each existing gap between stations, calculate how many new stations are needed: `stations_needed = floor(gap_len / d)`. If `gap_len` is a multiple of `d`, you need one less. A simpler way is `ceil(gap_len / d) - 1`.
    - Sum these up. If `total_stations_needed <= k`, it's possible.
3.  **Binary Search:** Run the loop for a fixed number of iterations (e.g., 100) or until `high - low` is very small. If `is_possible(mid)`, `mid` is a potential answer, so try for an even smaller distance: `ans = mid`, `high = mid`. Else, the distance is too small: `low = mid`.

#### Python Code Snippet
```python
import math
def min_max_gas_dist(stations, k):
    low = 0
    high = stations[-1] - stations[0]

    def is_possible(dist):
        stations_needed = 0
        for i in range(len(stations) - 1):
            gap = stations[i+1] - stations[i]
            stations_needed += math.floor(gap / dist)
        return stations_needed <= k

    # Search for a very small precision
    while high - low > 1e-6:
        mid = (low + high) / 2.0
        if is_possible(mid):
            high = mid
        else:
            low = mid

    return high
```

---

### 4. Matrix Median
`[HARD]` `#binary-search-on-answer`

#### Problem Statement
Given a row-wise sorted matrix `A` of size `R x C`, find the median of all its elements. The median is the middle element if the total number of elements is odd, or the average of the two middle elements otherwise. For this problem, we consider the `(N/2)`-th element where `N = R*C`.

*Example:*
- **Input:** `A = [[1, 3, 5], [2, 6, 9], [3, 6, 9]]`
- **Output:** `5` (Sorted array is `[1,2,3,3,5,6,6,9,9]`, median is 5)

#### Implementation Overview
The median is the element `x` such that the count of elements less than or equal to `x` is `(R*C)/2 + 1`. We can binary search for this element.
1.  **Search Space:** The answer must be between the minimum and maximum possible values in the matrix (e.g., 1 and 10^9 based on constraints).
2.  **Predicate `count_less_equal(val)`:** Count how many elements in the entire matrix are less than or equal to `val`.
    - Since each row is sorted, use binary search (`upper_bound`) on each row to find this count. `upper_bound(row, val)` gives the index of the first element greater than `val`, which is also the count of elements `<= val`.
    - The total time for the predicate is O(R * log C).
3.  **Binary Search:** If `count_less_equal(mid) < required_count`, `mid` is too small, so `low = mid + 1`. Else, `mid` is a potential answer, so we store it and search for a smaller one: `ans = mid`, `high = mid - 1`.

#### Python Code Snippet
```python
def matrix_median(matrix):
    m, n = len(matrix), len(matrix[0])
    low, high = 1, 10**9 # Based on typical constraints
    required_count = (m * n) // 2 + 1

    def count_less_equal(val):
        count = 0
        for r in range(m):
            # Find upper_bound in the row
            l, h = 0, n - 1
            row_count = 0
            while l <= h:
                md = l + (h - l) // 2
                if matrix[r][md] <= val:
                    row_count = md + 1
                    l = md + 1
                else:
                    h = md - 1
            count += row_count
        return count

    ans = -1
    while low <= high:
        mid = low + (high - low) // 2
        if count_less_equal(mid) >= required_count:
            ans = mid
            high = mid - 1
        else:
            low = mid + 1

    return ans
```

---

### 5. Kth Missing Positive Number
`[EASY]` `#binary-search` `#observation`

#### Problem Statement
Given a sorted array of positive integers `arr` and an integer `k`, find the `k`-th positive integer that is missing from this array.

*Example:*
- **Input:** `arr = [2,3,4,7,11]`, `k = 5`
- **Output:** `9` (Missing numbers are 1, 5, 6, 8, 9, 10... The 5th one is 9).

#### Implementation Overview
The key observation is that for any index `i`, the number of missing positive integers up to that point is `arr[i] - (i + 1)`.
1.  **Search Space:** We binary search on the indices of the array, `low = 0`, `high = n - 1`.
2.  **Binary Search Logic:** Calculate `mid`. The number of missing values before `arr[mid]` is `missing_count = arr[mid] - (mid + 1)`.
    -   If `missing_count < k`, the `k`-th missing number must be to the right of `mid`. `low = mid + 1`.
    -   If `missing_count >= k`, the `k`-th missing number is at or to the left of `mid`. `high = mid - 1`.
3.  **Result:** The loop finds the tipping point. The `high` pointer will land on the last element where `missing_count < k`. The answer is `high + 1 + k` or simply `low + k`.

#### Python Code Snippet
```python
def find_kth_positive(arr, k):
    low, high = 0, len(arr) - 1
    while low <= high:
        mid = low + (high - low) // 2
        missing_count = arr[mid] - (mid + 1)
        if missing_count < k:
            low = mid + 1
        else:
            high = mid - 1
    # The k-th missing number is k positions after the `high`-th element's expected position
    # Or more simply, it's k positions after the start of the `low` partition.
    return low + k
```
