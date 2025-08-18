# Pattern 3: Subarray & Hashing Problems

This pattern covers a large and important group of array problems. It includes finding or counting contiguous subarrays with certain properties, and problems where a `HashSet` or `HashMap` provides an optimal solution by enabling O(1) lookups.

## Sub-pattern: Kadane's Algorithm & Variations

This is for finding the maximum (or minimum) sum/product of a contiguous subarray.

### 1. Kadane's Algorithm: Maximum Subarray Sum
`[MEDIUM]` `[FUNDAMENTAL]`
- **Problem:** Find the contiguous subarray with the largest sum.
- **Overview:** A classic dynamic programming approach. Iterate through the array, maintaining a `current_max` sum ending at the current position and an overall `global_max`. If `current_max` becomes negative, reset it to 0.
- **Extension:** To print the subarray, add variables to track the start and end indices of the `global_max` subarray.

### 2. Maximum Product Subarray
`[MEDIUM]`
- **Problem:** Find the contiguous subarray with the largest product.
- **Overview:** This is a variation of Kadane's. The trick is that a negative number can become part of the max product if it's multiplied by another negative. Therefore, you must keep track of both the `max_product_ending_here` and the `min_product_ending_here` at each step.

## Sub-pattern: Sliding Window (for Positive Arrays)

This technique uses two pointers (`left` and `right`) to maintain a "window" and is highly efficient for problems on contiguous subarrays with **non-negative** numbers.

### 3. Longest Subarray with Given Sum K (Positives)
`[MEDIUM]`
- **Problem:** Given an array of non-negative integers, find the length of the longest subarray with a sum equal to `k`.
- **Overview:** Expand the window by moving `right`. If `sum > k`, shrink the window by moving `left`. If `sum == k`, record the length.

### 4. Maximum Consecutive Ones
`[EASY]`
- **Problem:** Find the maximum number of consecutive `1`s in a binary array.
- **Overview:** A simple sliding window or a single pass. Keep a running `count` of ones. If you see a zero, reset the count. Keep track of the maximum count seen.

## Sub-pattern: Prefix Sum & Hashing (for Positive & Negative Arrays)

This is a powerful technique for subarray sum problems that include negative numbers. It relies on the idea that if `sum(0..j) - sum(0..i-1) = k`, then `sum(0..i-1) = sum(0..j) - k`. We use a HashMap to store prefix sums.

### 5. Longest/Largest Subarray with Sum K / 0
`[MEDIUM]`
- **Problem:** Find the length of the longest subarray with a sum equal to `k` (or 0). Works for arrays with negatives.
- **Overview:** Use a HashMap to store `(prefix_sum, first_index)`. Iterate through the array, calculating the running `prefix_sum`. Check if `prefix_sum - k` exists in the map. If it does, you've found a valid subarray.

### 6. Count Subarrays with Given Sum K
`[MEDIUM]`
- **Problem:** Find the total number of subarrays whose sum equals `k`.
- **Overview:** This is a frequency-based variation. Use a HashMap to store `(prefix_sum, frequency)`. When you find that `prefix_sum - k` exists in the map, you add its frequency to your total count.

### 7. Count Number of Subarrays with Given XOR K
`[HARD]` `[TRICK]`
- **Problem:** Find the total number of subarrays with a bitwise XOR of all elements equal to `k`.
- **Overview:** This is identical in structure to "Count Subarrays with Given Sum K," but you use the XOR operator instead of addition. The logic `prefix_xor[i-1] = prefix_xor[j] ^ k` holds.

## Sub-pattern: Set-Based Hashing

### 8. Find the Union of Two Arrays
`[EASY]`
- **Problem:** Find the unique elements present in either of two unsorted arrays.
- **Overview:** Add all elements from both arrays into a `HashSet`. The set automatically handles uniqueness.

### 9. Longest Consecutive Sequence
`[MEDIUM]` `[TRICK]`
- **Problem:** Find the length of the longest sequence of consecutive numbers in an unsorted array.
- **Overview:**
    1. Add all numbers to a `HashSet` for O(1) lookup.
    2. Iterate through the numbers. For each number, if it's the start of a sequence (i.e., `num - 1` is NOT in the set), start a `while` loop to count how long the sequence is by checking for `num + 1`, `num + 2`, etc. in the set. This avoids redundant checks and achieves O(N) time.
