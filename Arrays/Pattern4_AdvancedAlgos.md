# Pattern 4: Advanced Algorithms & Sorting Applications

This pattern covers problems where the optimal solution isn't based on a simple traversal or pointer technique, but rather on a specific, named algorithm or a clever modification of a standard one like Merge Sort. These often have a non-obvious "trick" and are important to learn and recognize.

## Sub-pattern: Moore's Voting Algorithm

This algorithm is used to find majority elements in an array in O(N) time and O(1) space. It works by treating elements as "votes" that can cancel each other out.

### 1. Majority Element (> n/2 times)
`[EASY]` `[FUNDAMENTAL]`
- **Problem:** Find the element that appears more than `n/2` times.
- **Overview:** Use a `candidate` and a `count`. Iterate through the array. If `count` is 0, set a new `candidate`. If the current element matches the candidate, increment count, otherwise decrement. The final candidate is the answer.

### 2. Majority Element II (> n/3 times)
`[MEDIUM]` `[TRICK]`
- **Problem:** Find all elements that appear more than `n/3` times.
- **Overview:** The logic is extended. At most two such elements can exist.
    1.  Use two candidates and two counters to find two potential majority elements in one pass.
    2.  Perform a second pass to verify if the counts of these two candidates are actually greater than `n/3`.

## Sub-pattern: Next Permutation

### 3. Next Permutation
`[MEDIUM]` `[HARD]` `[TRICK]`
- **Problem:** Given an array of numbers, rearrange it into the next lexicographically greater permutation.
- **Overview (Standard Algorithm):**
    1.  **Find break-point:** From the right, find the first index `i` where `arr[i] < arr[i+1]`.
    2.  **Find swap element:** From the right, find the first index `j` where `arr[j] > arr[i]`.
    3.  **Swap:** Swap `arr[i]` and `arr[j]`.
    4.  **Reverse:** Reverse the subarray to the right of `i` (from `i+1` to the end).
    - If no break-point is found, the array is the last permutation; reverse the whole thing.

## Sub-pattern: Modified Merge Sort

This pattern involves modifying the `merge` step of the Merge Sort algorithm to count pairs that satisfy certain conditions between the left and right halves of the array.

### 4. Count Inversions
`[HARD]` `[TRICK]`
- **Problem:** Count pairs of indices `(i, j)` such that `i < j` and `arr[i] > arr[j]`.
- **Overview:** During the merge step of two sorted halves, if you are about to take an element from the right half (`right[j]`) because it's smaller than the current element in the left half (`left[i]`), it means `right[j]` is also smaller than *all remaining elements* in the left half. You add this number of remaining elements to your count.

### 5. Reverse Pairs
`[HARD]` `[TRICK]`
- **Problem:** Count pairs of indices `(i, j)` such that `i < j` and `nums[i] > 2 * nums[j]`.
- **Overview:** This is very similar to Count Inversions. In the `merge` function, *before* you start the actual merge-and-sort part, you use two pointers to count the pairs that satisfy the `nums[i] > 2 * nums[j]` condition between the left and right halves. Then, you proceed with the normal merge operation.
