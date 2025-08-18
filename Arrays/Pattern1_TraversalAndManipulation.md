# Pattern 1: Simple Traversal & Manipulation

This file covers fundamental array problems that can be solved with a single, straightforward pass through the array, simple loops, or a basic greedy choice at each step. These problems form the foundation of array manipulation.

---

### 1. Largest Element in an Array
`[FUNDAMENTAL]`
- **Problem:** Given an array, find the largest element.
- **Overview:** Iterate through the array, keeping track of the maximum element found so far.
- **Time/Space:** O(N) / O(1)

---

### 2. Second Largest Element in an Array
`[FUNDAMENTAL]`
- **Problem:** Find the second largest element without sorting.
- **Overview:** Iterate through the array, maintaining two variables: `largest` and `second_largest`. Update them as you find new larger or second-larger elements. Be mindful of duplicates.

---

### 3. Check if Array is Sorted
`[FUNDAMENTAL]`
- **Problem:** Determine if an array is sorted in non-decreasing order.
- **Overview:** Iterate from the second element and check if `arr[i] < arr[i-1]`. If this is ever true, return false.

---

### 4. Left Rotate an Array by D Places
`[TRICK]`
- **Problem:** Given an array, left rotate it by `d` places.
- **Overview (Reversal Algorithm):** This is the optimal O(N) time, O(1) space solution.
    1. Reverse the first `d` elements (`0` to `d-1`).
    2. Reverse the rest of the elements (`d` to `n-1`).
    3. Reverse the entire array.
- **Note:** A simpler solution is to use a temporary array, but it uses O(d) space.

---

### 5. Move Zeros to End
`[FUNDAMENTAL]`
- **Problem:** Move all zeros to the end of an array while maintaining the relative order of non-zero elements.
- **Overview:** Use a pointer `j` to keep track of where the next non-zero element should go. Iterate through the array with a pointer `i`. If `arr[i]` is not zero, place it at `arr[j]` and increment `j`. After the loop, fill the rest of the array with zeros.

---

### 6. Linear Search
`[FUNDAMENTAL]`
- **Problem:** Given an array and an element, find the index of the element, or -1 if not found.
- **Overview:** Iterate through the array and return the index `i` if `arr[i]` matches the target element.

---

### 7. Leaders in an Array
`[EASY]`
- **Problem:** Find all elements that are greater than or equal to all elements to their right. The rightmost element is always a leader.
- **Overview:** The optimal solution is to scan from right to left. Keep track of the maximum element found so far from the right (`max_from_right`). If the current element is greater than `max_from_right`, it's a leader. Update `max_from_right`.

---

### 8. Stock Buy and Sell
`[EASY]` `[FUNDAMENTAL]`
- **Problem:** Find the maximum profit from buying a stock on one day and selling it on a future day.
- **Overview:** Iterate through the prices, keeping track of the `min_price` seen so far and the `max_profit` found. For each day, calculate the potential profit (`current_price - min_price`) and update `max_profit` if it's higher. Update `min_price` as you go.
