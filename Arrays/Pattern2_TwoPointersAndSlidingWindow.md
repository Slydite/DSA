# Pattern 2: Two-Pointers & Sliding Window

The two-pointer technique is one of the most common and powerful patterns for solving array problems. It involves using two integer pointers that either move toward each other, move in the same direction at different speeds, or define a "window" that slides over the data. This pattern often leads to O(N) time and O(1) space solutions.

---

### 1. 2Sum / 3Sum / 4Sum
`[MEDIUM]` `[HARD]` `[FUNDAMENTAL]` `#two-pointers` `#sorting`

#### Problem Statement
- **2Sum:** Given a sorted array and a target, find if a pair of numbers sums to the target.
- **3Sum:** Find all unique triplets that sum to zero.
- **4Sum:** Find all unique quadruplets that sum to a target.

#### Implementation Overview
1.  **2Sum:** Sort the array. Use `left` and `right` pointers at opposite ends. If `sum > target`, decrement `right`. If `sum < target`, increment `left`.
2.  **3Sum:** Sort the array. Iterate with a main pointer `i`. For each `arr[i]`, perform the **2Sum** algorithm on the rest of the array with a target of `-arr[i]`. Skip duplicates to ensure unique triplets.
3.  **4Sum:** Extend 3Sum with another outer loop. Use two pointers `i` and `j`, and for each pair, perform **2Sum** on the remainder. Aggressive duplicate handling is key.

#### Related Problems
- All three problems are direct extensions of each other.

---

### 2. Sort an Array of 0's, 1's, and 2's
`[MEDIUM]` `[FUNDAMENTAL]` `#two-pointers` `#dutch-national-flag`

#### Problem Statement
Given an array containing only 0s, 1s, and 2s, sort it in-place.

#### Implementation Overview
This is solved with the Dutch National Flag Algorithm, using three pointers: `low`, `mid`, and `high`.
1.  Initialize `low = 0`, `mid = 0`, `high = n - 1`.
2.  The goal is to shrink the `mid` (unknown) section.
3.  Iterate while `mid <= high`:
    -   If `arr[mid] == 0`: Swap with `arr[low]`, then increment both `low` and `mid`.
    -   If `arr[mid] == 1`: Increment `mid`.
    -   If `arr[mid] == 2`: Swap with `arr[high]`, then decrement `high`.

#### Python Code Snippet
```python
def sort_colors(nums):
    low, mid, high = 0, 0, len(nums) - 1

    # Process the array until the mid pointer crosses the high pointer
    while mid <= high:
        if nums[mid] == 0:
            # If a 0 is found, swap it with the element at the low pointer
            nums[low], nums[mid] = nums[mid], nums[low]
            low += 1
            mid += 1
        elif nums[mid] == 1:
            # If a 1 is found, it's in the correct place, move to the next element
            mid += 1
        else: # nums[mid] == 2
            # If a 2 is found, swap it with the element at the high pointer
            nums[mid], nums[high] = nums[high], nums[mid]
            high -= 1
            # Note: mid is NOT incremented here, as the new nums[mid] needs to be processed
```

---

### 3. Merge Overlapping Subintervals
`[MEDIUM]` `[FUNDAMENTAL]` `#sorting` `#greedy`

#### Problem Statement
Given a collection of intervals `[[start, end]]`, merge all overlapping intervals.

#### Implementation Overview
1.  **Sort:** Sort the intervals based on their `start` times. This is the most critical step.
2.  **Initialize:** Create a `merged` list and add the first interval to it.
3.  **Iterate and Merge:** For each subsequent interval, if it overlaps with the last interval in `merged`, update the end of the last interval. Otherwise, add the new interval to the list.

#### Python Code Snippet
```python
def merge_intervals(intervals):
    if not intervals:
        return []

    # Sort intervals based on the start time
    intervals.sort(key=lambda x: x[0])

    merged = [intervals[0]]
    for i in range(1, len(intervals)):
        last_merged = merged[-1]
        current = intervals[i]

        # Check for overlap
        if current[0] <= last_merged[1]:
            # Merge by updating the end of the last interval in the result
            last_merged[1] = max(last_merged[1], current[1])
        else:
            # No overlap, add the current interval
            merged.append(current)

    return merged
```

---

### 4. Longest Subarray with Given Sum K (Positives)
`[MEDIUM]` `#sliding-window` `#two-pointers`

#### Problem Statement
Given an array of **non-negative** integers and a value `k`, find the length of the longest subarray with a sum equal to `k`.

#### Implementation Overview
This is a classic application of the sliding window technique.
1.  Initialize `left = 0`, `right = 0`, `current_sum = 0`, `max_len = 0`.
2.  Use a loop to move the `right` pointer, expanding the window. Add `nums[right]` to `current_sum`.
3.  Use an inner `while` loop: if `current_sum > k`, move the `left` pointer to shrink the window until the sum is no longer too large.
4.  If `current_sum == k`, you have a valid window. Check its length against `max_len`.

#### Related Problems
- This approach only works for non-negative numbers. For arrays with negatives, see **Pattern 3: Hashing Techniques**.

---

### 5. Spiral Matrix Traversal
`[MEDIUM]` `#multi-pointer` `#simulation` `#shrinking-boundaries`

#### Problem Statement
Given an `m x n` matrix, return all its elements in spiral order.

#### Implementation Overview
This is a simulation problem using four pointers to define the boundaries of the current layer: `top`, `bottom`, `left`, and `right`.
1.  Initialize the four boundary pointers.
2.  Loop as long as `top <= bottom` and `left <= right`. In each iteration:
    -   Traverse right along the `top` row, then increment `top`.
    -   Traverse down along the `right` column, then decrement `right`.
    -   Traverse left along the `bottom` row (if boundaries are valid), then decrement `bottom`.
    -   Traverse up along the `left` column (if boundaries are valid), then increment `left`.
The boundary validity checks (`top <= bottom` and `left <= right`) are crucial for non-square matrices.
