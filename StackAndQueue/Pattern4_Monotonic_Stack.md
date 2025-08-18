# Pattern 4: Monotonic Stack

A Monotonic Stack is a powerful technique and a variation of a standard stack where the elements in the stack are always maintained in a specific order (either monotonically increasing or decreasing). This property is used to efficiently solve problems involving finding the "next" or "previous" greater/smaller element in an array.

The general algorithm for a "next greater element" problem using a (decreasing) monotonic stack is:
1. Initialize an empty stack.
2. Iterate through the array (often from right to left).
3. For each element, while the stack is not empty and the element at the top of the stack is less than or equal to the current element, pop from the stack. These popped elements can never be the "next greater" for any future elements to the left.
4. If the stack is now empty, it means there is no greater element to the right; store a default value (e.g., -1). Otherwise, the element at the top of the stack is the next greater element.
5. Push the current element (or its index) onto the stack.

This pattern is extremely versatile and forms the basis for solving many seemingly unrelated hard problems.

---

### 1. Next Greater Element
`[EASY]` `#monotonic-stack` `#array`

#### Problem Statement
Given an array, find the next greater element for each element. The next greater element of `x` is the first element to its right which is greater than `x`. For elements with no greater element, the answer is -1.

#### Implementation Overview
This is the canonical monotonic stack problem. We iterate from right to left:
1.  Use a stack to store elements we have processed. The stack will be kept in decreasing order from top to bottom.
2.  For each element `arr[i]`, we pop from the stack while the top is less than or equal to `arr[i]`.
3.  The element at the top of the stack after popping is the Next Greater Element (NGE). If the stack is empty, there is no NGE.
4.  Push `arr[i]` onto the stack.

#### Python Code Snippet
```python
def next_greater_element(nums):
    n = len(nums)
    result = [-1] * n
    stack = [] # Stack will store elements

    for i in range(n - 1, -1, -1):
        while stack and stack[-1] <= nums[i]:
            stack.pop()

        if stack:
            result[i] = stack[-1]

        stack.append(nums[i])

    return result
```
*Note: Storing indices instead of values is often more flexible and powerful.*

---

### 2. Next Greater Element 2
`[MEDIUM]` `#monotonic-stack` `#array` `#circular`

#### Problem Statement
Same as "Next Greater Element," but the array is circular. This means the search for a greater element wraps around from the end to the beginning.

#### Implementation Overview
To simulate the circular array, we can iterate through the array twice. A simple way is to iterate from `2*n - 1` down to `0`, using the modulo operator (`i % n`) to access the array elements. The rest of the logic is identical to the standard Next Greater Element problem. This effectively gives every element a chance to see all other elements to its "right."

---

### 3. Next Smaller Element
`[EASY]` `#monotonic-stack` `#array`

#### Problem Statement
Given an array, find the next smaller element for each element. The next smaller element of `x` is the first element to its right which is smaller than `x`.

#### Implementation Overview
This is a minor variation of NGE. Instead of a decreasing monotonic stack, we maintain an **increasing** monotonic stack. When processing `arr[i]`, we pop from the stack while the top is greater than or equal to `arr[i]`.

---

### 4. Stock Span Problem
`[MEDIUM]` `#monotonic-stack` `#array`

#### Problem Statement
Given an array of stock prices, the span of the stock's price today is the maximum number of consecutive days (starting from today and going backward) for which the price of the stock was less than or equal to today's price.

#### Implementation Overview
This is a "previous greater element" problem. We iterate from left to right. The stack stores indices of days. For each day `i`, we pop from the stack while the price on the day at `stack.top()` is less than or equal to the price on day `i`. The span is `i - stack.top()` (or `i + 1` if the stack becomes empty).

---

### 5. Largest Rectangle in a Histogram
`[HARD]` `#monotonic-stack` `#array`

#### Problem Statement
Given an array of integers `heights` representing the height of bars in a histogram, find the area of the largest rectangle that can be formed in the histogram.

#### Implementation Overview
This is a classic and powerful application of the monotonic stack. The key idea is that for each bar, the largest rectangle it can be part of is determined by the first shorter bar to its left and the first shorter bar to its right. We can find these using a single pass with an increasing monotonic stack.
1. Use a stack storing indices, with a sentinel value `-1` at the bottom.
2. Iterate through `heights` with index `i`. If `heights[i]` is smaller than the height at the stack's top, it means `i` is the "next smaller element" for the bar at the top.
3. Pop the stack. Let the popped index be `h_idx`. The height is `heights[h_idx]`. The "previous smaller element" is the index now at the top of the stack. The width is `i - stack.top() - 1`.
4. Calculate `area = height * width` and update the maximum. Repeat until the stack top is smaller than `heights[i]`. Then push `i`.
5. After the loop, process any remaining bars in the stack.

#### Python Code Snippet (Single Pass)
```python
def largestRectangleArea(heights):
    stack = [-1] # Sentinel value for boundary calculation
    max_area = 0
    for i, h in enumerate(heights):
        while stack[-1] != -1 and heights[stack[-1]] >= h:
            height = heights[stack.pop()]
            width = i - stack[-1] - 1
            max_area = max(max_area, height * width)
        stack.append(i)

    # Process remaining bars in the stack
    while stack[-1] != -1:
        height = heights[stack.pop()]
        width = len(heights) - stack[-1] - 1
        max_area = max(max_area, height * width)

    return max_area
```

---

### 6. Maximal Rectangle
`[HARD]` `#monotonic-stack` `#dynamic-programming` `#matrix`

#### Problem Statement
Given a 2D binary matrix filled with 0s and 1s, find the largest rectangle containing only 1s and return its area.

#### Implementation Overview
This problem can be reduced to the "Largest Rectangle in a Histogram" problem. We can think of each row of the matrix as the "ground." We build a histogram for each row:
1. Iterate through each row of the matrix.
2. For each row `i`, create a `heights` array. `heights[j]` is the number of consecutive 1s above `matrix[i][j]` (including itself). If `matrix[i][j]` is 0, `heights[j]` is 0. This is a DP state.
3. For each generated `heights` array, apply the "Largest Rectangle in a Histogram" algorithm.
4. The answer is the maximum area found across all rows.

---

### 7. Trapping Rainwater
`[HARD]` `#monotonic-stack` `#two-pointers`

#### Problem Statement
Given an array of non-negative integers representing an elevation map, compute how much water it can trap after raining.

#### Implementation Overview
While a two-pointer approach is common, this can also be solved with a monotonic stack.
1. Use a (decreasing) monotonic stack to store indices of the bars.
2. Iterate through the elevation map. When we find a bar `heights[i]` that is taller than the bar at the top of the stack, it forms a "container" with a bar further left in the stack.
3. Pop the stack (this is the `bottom` of the container). If the stack becomes empty, there's no left wall, so break. The new top of the stack is the `left_boundary`. The current bar `i` is the `right_boundary`.
4. The water trapped is `(min(heights[left_boundary], heights[i]) - heights[bottom]) * (i - left_boundary - 1)`.
5. Accumulate this water and continue.

---

### 8. Sum of Subarray Minimums
`[MEDIUM]` `#monotonic-stack` `#dynamic-programming`

#### Problem Statement
Given an array of integers `arr`, find the sum of `min(b)` for every (contiguous) subarray `b` of `arr`.

#### Implementation Overview
A brute-force approach is O(n^2). A monotonic stack can solve this in O(n). For each element `arr[i]`, we need to find how many subarrays have `arr[i]` as their minimum element.
1. For each `arr[i]`, we need its "previous smaller element" (at index `ple`) and "next smaller element" (at index `nse`). An element `arr[i]` is the minimum in any subarray that starts in `(ple, i]` and ends in `[i, nse)`.
2. The number of such subarrays is `(i - ple) * (nse - i)`.
3. The contribution of `arr[i]` to the total sum is `arr[i] * (i - ple) * (nse - i)`.
4. We can find `ple` and `nse` for all elements using two passes with a monotonic stack. Sum up the contributions for the final answer. (Note: use "smaller or equal" for one of the bounds to handle duplicates correctly).

---

### 9. Sum of Subarray Ranges
`[MEDIUM]` `#monotonic-stack`

#### Problem Statement
Given an array of integers `nums`, the range of a subarray is the difference between the largest and smallest element in the subarray. Return the sum of all subarray ranges.

#### Implementation Overview
This problem can be broken down: `sum(max(subarray) - min(subarray))` = `sum(max(subarray)) - sum(min(subarray))`.
- The `sum(min(subarray))` part is exactly the "Sum of Subarray Minimums" problem.
- The `sum(max(subarray))` part is its dual: "Sum of Subarray Maximums." This can be solved with the same monotonic stack approach, but by finding the "previous greater" and "next greater" elements to count the subarrays where `arr[i]` is the maximum.
- Calculate both sums and return their difference.

---

### 10. Asteroid Collision
`[MEDIUM]` `#stack`

#### Problem Statement
Given an array of integers `asteroids` representing asteroids in a row. For each asteroid, the absolute value is its size, and the sign is its direction (positive right, negative left). Find out the state of the asteroids after all collisions.

#### Implementation Overview
This is a direct simulation problem that is perfectly suited for a stack.
1. Iterate through the asteroids. The stack will hold the asteroids that have survived so far.
2. If the current asteroid `a` is positive, it's moving right, so it won't collide with the right-moving asteroids already in the stack. Push it.
3. If `a` is negative (moving left), it might collide with positive asteroids at the top of the stack.
   - While the stack is not empty, its top is positive, and its top is smaller than `abs(a)`, pop the stack (the smaller asteroid is destroyed).
   - If the stack top is equal to `abs(a)`, pop it and discard `a` (both are destroyed). Then break.
   - If the stack top is greater than `abs(a)`, `a` is destroyed, and we break.
   - If the loop finishes and `a` has survived, push it onto the stack.

---

### 11. Remove K Digits
`[MEDIUM]` `#monotonic-stack` `#greedy`

#### Problem Statement
Given a non-negative integer `num` represented as a string, remove `k` digits from the number so that the new number is the smallest possible.

#### Implementation Overview
This is a greedy problem that can be solved with a monotonic stack. To get the smallest number, we want to keep the digits in increasing order as much as possible from left to right.
1. Iterate through the digits of the number string.
2. Maintain a stack that represents the digits of our result number. The stack will be kept monotonically increasing.
3. For each digit, while `k > 0` and the stack is not empty and the top of the stack is greater than the current digit, pop from the stack and decrement `k`. This removes a larger digit from a more significant position.
4. Push the current digit onto the stack.
5. After the loop, if `k > 0`, it means the remaining digits are in increasing order (e.g., "12345"), so remove the last `k` digits from the stack.
6. Join the digits in the stack to form the result string. Handle leading zeros.

---
*Note: "Number of NGEs to the right" is omitted as it is identical to "Next Greater Element".*
