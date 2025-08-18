# Pattern 4: Advanced & Named Algorithms

This pattern covers problems where the optimal solution relies on a specific, non-trivial algorithm that is important to learn and recognize by name. This category also includes clever modifications of standard algorithms like Merge Sort.

---

### 1. Next Permutation
`[MEDIUM]` `[HARD]` `[TRICK]` `#inplace` `#lexicographical`

#### Problem Statement
Given an array of numbers, rearrange it into the next lexicographically greater permutation. If not possible, rearrange it to the smallest permutation (sorted ascending).

**Example:** `[1,2,3]` -> `[1,3,2]`. `[3,2,1]` -> `[1,2,3]`.

#### Implementation Overview
1.  **Find break-point `i`:** From the right, find the first index `i` where `arr[i] < arr[i+1]`. If no such index exists, the whole array is the last permutation; reverse it and return.
2.  **Find swap element `j`:** From the right, find the first index `j` where `arr[j] > arr[i]`.
3.  **Swap:** Swap `arr[i]` and `arr[j]`.
4.  **Reverse:** Reverse the suffix of the array to the right of `i` (from `i+1` to the end).

#### Python Code Snippet
```python
def next_permutation(nums):
    n = len(nums)
    # Step 1: Find the break-point
    i = n - 2
    while i >= 0 and nums[i] >= nums[i+1]:
        i -= 1

    if i >= 0:
        # Step 2: Find the element to swap with
        j = n - 1
        while nums[j] <= nums[i]:
            j -= 1
        # Step 3: Swap
        nums[i], nums[j] = nums[j], nums[i]

    # Step 4: Reverse the suffix
    left, right = i + 1, n - 1
    while left < right:
        nums[left], nums[right] = nums[right], nums[left]
        left += 1
        right -= 1
```

---

### 2. Moore's Voting Algorithm
`[EASY]` `[MEDIUM]` `[TRICK]` `#voting-algorithm`

#### Problem Statement
- **> n/2:** Find the element that appears more than `n/2` times.
- **> n/3:** Find all elements that appear more than `n/3` times.

#### Implementation Overview (> n/3)
At most two elements can appear > n/3 times.
1.  **First Pass (Find Candidates):** Use two candidates (`c1`, `c2`) and two counters (`v1`, `v2`). Iterate through the array, assigning candidates when counts are zero, incrementing for matches, and decrementing both for mismatches.
2.  **Second Pass (Verification):** The first pass only gives *potential* candidates. Reset counts to zero and iterate again to get the true counts of `c1` and `c2`. Add any candidate to the result if its verified count is `> n/3`.

---

### 3. Count Inversions / Reverse Pairs
`[HARD]` `[TRICK]` `#divide-and-conquer` `#merge-sort`

#### Problem Statement
- **Count Inversions:** Count pairs `(i, j)` where `i < j` and `arr[i] > arr[j]`.
- **Reverse Pairs:** Count pairs `(i, j)` where `i < j` and `nums[i] > 2 * nums[j]`.

#### Implementation Overview
Both are solved by modifying the `merge` step of a Merge Sort.
1.  Use the standard recursive merge sort structure.
2.  **For Count Inversions:** During the merge of two sorted halves, if `left[i] > right[j]`, you've found `mid - i + 1` new inversions. Add this to your total.
3.  **For Reverse Pairs:** In the `merge` function, *before* the merge-sort part, use two pointers to count pairs that satisfy `nums[i] > 2 * nums[j]` between the halves. Then, perform the normal merge.

#### Python Code Snippet (Count Inversions)
```python
def merge_sort_and_count(arr, temp, left, right):
    count = 0
    if left < right:
        mid = (left + right) // 2
        count += merge_sort_and_count(arr, temp, left, mid)
        count += merge_sort_and_count(arr, temp, mid + 1, right)
        count += merge_and_count(arr, temp, left, mid, right)
    return count

def merge_and_count(arr, temp, left, mid, right):
    i = left
    j = mid + 1
    k = left
    count = 0

    while i <= mid and j <= right:
        if arr[i] <= arr[j]:
            temp[k] = arr[i]
            i += 1
        else:
            # Inversion found
            temp[k] = arr[j]
            count += (mid - i + 1)
            j += 1
        k += 1

    # Copy remaining elements
    while i <= mid: temp[k] = arr[i]; i += 1; k += 1
    while j <= right: temp[k] = arr[j]; j += 1; k += 1

    # Copy sorted subarray back to original
    for i in range(left, right + 1):
        arr[i] = temp[i]

    return count
```
---

### 4. Maximum Product Subarray
`[MEDIUM]` `#dynamic-programming`

#### Problem Statement
Find the contiguous subarray with the largest product.

#### Implementation Overview
This is a variation of Kadane's, but it's more complex because of negative numbers. You must track both the maximum and minimum product ending at each position.
1.  Initialize `max_prod`, `min_prod`, and `result` to the first element.
2.  Iterate from the second element. For each `num`:
    -   If `num` is negative, a max can become a min and vice-versa. Swap `max_prod` and `min_prod`.
    -   `max_prod = max(num, max_prod * num)`.
    -   `min_prod = min(num, min_prod * num)`.
    -   Update `result = max(result, max_prod)`.

---

### 5. Merge Two Sorted Arrays Without Extra Space
`[HARD]` `[TRICK]` `#gap-algorithm`

#### Problem Statement
Merge two sorted arrays, `arr1` (size n) and `arr2` (size m), in-place, such that the first `n` sorted elements are in `arr1` and the rest in `arr2`.

#### Implementation Overview (Gap Method)
This optimal O((n+m)log(n+m)) approach is inspired by Shell Sort.
1.  Initialize `gap = ceil((n + m) / 2)`.
2.  Loop while `gap > 0`.
    -   Use two pointers, `i = 0` and `j = gap`.
    -   Iterate while `j < n + m`, comparing and swapping elements at `i` and `j`. The pointers may be in `arr1`, `arr2`, or one in each, requiring careful index management.
    -   After the inner loop, update the gap: `gap = ceil(gap / 2)`.
3.  The loop terminates when `gap` becomes 1 and the final pass is complete.
