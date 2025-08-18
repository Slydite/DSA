# Pattern 2: The Two-Pointer Technique

The two-pointer technique is one of the most common and powerful patterns for solving array and list problems. It involves using two integer pointers that either move toward each other from opposite ends of the array, or move in the same direction at different speeds. This pattern is highly efficient, often leading to O(N) time and O(1) space solutions.

---

### 1. 2Sum / 3Sum / 4Sum
`[MEDIUM]` `[HARD]` `[FUNDAMENTAL]`
- **Problem:** Find a pair, triplet, or quadruplet of numbers that sum up to a target value.
- **Overview (2Sum):** Sort the array. Use two pointers, `left` at the start and `right` at the end. If `sum > target`, decrement `right`. If `sum < target`, increment `left`.
- **Overview (3Sum/4Sum):** These are extensions of 2Sum. For 3Sum, sort the array, then iterate with a main pointer `i`. For each `arr[i]`, perform the 2Sum algorithm on the rest of the array with `target - arr[i]`. 4Sum extends this with another outer loop. Careful handling of duplicates is crucial.

---

### 2. Sort an Array of 0's, 1's, and 2's
`[MEDIUM]` `[FUNDAMENTAL]`
- **Problem:** Given an array of 0s, 1s, and 2s, sort it in-place.
- **Overview (Dutch National Flag Algorithm):** This is a classic three-pointer problem.
    - Use `low`, `mid`, and `high` pointers.
    - The goal is to shrink the `mid` (unsorted) section.
    - If `arr[mid] == 0`, swap with `arr[low]` and increment both `low` and `mid`.
    - If `arr[mid] == 1`, just increment `mid`.
    - If `arr[mid] == 2`, swap with `arr[high]` and decrement `high`.

---

### 3. Merge Overlapping Subintervals
`[MEDIUM]`
- **Problem:** Given a collection of intervals, merge all overlapping intervals.
- **Overview:**
    1. Sort the intervals based on their start times.
    2. Iterate through the sorted intervals, maintaining a `merged` list.
    3. If the current interval overlaps with the last one in the `merged` list, update the end of the last interval.
    4. Otherwise, add the current interval to the `merged` list.
- **Note:** While not a classic two-pointer problem, the core logic of iterating through a sorted list and comparing adjacent/last-processed items is very similar in spirit.

---

### 4. Remove Duplicates from Sorted Array
`[EASY]` `[FUNDAMENTAL]`
- **Problem:** Given a sorted array, remove duplicates in-place such that each unique element appears once. Return the number of unique elements.
- **Overview:** Use a "slow" pointer `i` for the position of the next unique element and a "fast" pointer `j` to scan the array. If `arr[j]` is different from `arr[i]`, increment `i` and copy `arr[j]` to `arr[i]`.

---

### 5. Rearrange Array in Alternating Positive & Negative Items
`[MEDIUM]` `[TRICK]`
- **Problem:** Rearrange an array so that positive and negative numbers appear alternately.
- **Overview (Equal Numbers):** If the number of positive and negative elements is the same, you can use an auxiliary array and two pointers (`pos_idx = 0`, `neg_idx = 1`) to place positive numbers at even indices and negative numbers at odd indices in O(N) time and O(N) space. The in-place O(N) time solution is much more complex.

---

### 6. Merge Two Sorted Arrays Without Extra Space
`[HARD]` `[TRICK]`
- **Problem:** Merge two sorted arrays, `arr1` (size n) and `arr2` (size m), in-place, such that the first `n` sorted elements are in `arr1` and the next `m` are in `arr2`.
- **Overview (Gap Method):** The optimal O((n+m)log(n+m)) approach uses the Gap Method (inspired by Shell Sort). It repeatedly loops through the conceptual merged array with a shrinking `gap`, swapping elements that are `gap` distance apart until the gap becomes 1 and a final pass is made.
- **Overview (Pointer/Insertion Hybrid):** A simpler O(n*m) approach uses a pointer on `arr1` and compares with `arr2[0]`. If `arr1[i] > arr2[0]`, they are swapped, and `arr2` is re-sorted.
