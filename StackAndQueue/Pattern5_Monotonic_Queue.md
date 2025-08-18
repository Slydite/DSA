# Pattern 5: Monotonic Queue (Sliding Window Maximum/Minimum)

A Monotonic Queue (or Deque) is a specialized data structure that maintains its elements in a sorted order. It's the go-to pattern for solving problems that involve finding the maximum or minimum value within a sliding window of a fixed size. By cleverly adding and removing elements from both ends of a deque, we can ensure that the maximum/minimum element in the current window is always at the front of the deque, allowing for O(1) access.

The overall time complexity for processing an entire array is O(n) because each element is added to and removed from the deque at most once.

---

### 1. Sliding Window Maximum
`[HARD]` `#monotonic-queue` `#deque` `#sliding-window`

#### Problem Statement
You are given an array of integers `nums` and an integer `k` representing the size of the sliding window. There is a sliding window which moves from the very left of the array to the very right. You can only see the `k` numbers in the window. Each time the sliding window moves right by one position, return the maximum value in the current window.

#### Implementation Overview
We use a deque (double-ended queue) to store indices of elements in the current window. The deque will be kept in decreasing order of the values at those indices.

1.  Initialize an empty deque and a result array.
2.  Iterate through the array `nums` from left to right with index `i`.
3.  **Maintain the Monotonic Property**: Before adding the new element's index, remove all indices from the **rear** of the deque that correspond to values smaller than `nums[i]`. This ensures the deque remains sorted by value.
4.  **Add New Element**: Add the current index `i` to the rear of the deque.
5.  **Remove Out-of-Bounds Elements**: If the index at the **front** of the deque is no longer in the current window (i.e., `dq[0] <= i - k`), remove it.
6.  **Record Result**: Once the window is full (i.e., `i >= k - 1`), the maximum element for the current window is `nums[dq[0]]`. Append this to the result array.

#### Python Code Snippet
```python
from collections import deque

def maxSlidingWindow(nums, k):
    if not nums or k == 0:
        return []

    result = []
    dq = deque() # Stores indices of elements

    for i in range(len(nums)):
        # 1. Remove indices from the front that are out of the current window
        if dq and dq[0] <= i - k:
            dq.popleft()

        # 2. Maintain monotonic decreasing property
        # Remove elements from the back of the deque that are smaller than or equal to the current element
        while dq and nums[dq[-1]] <= nums[i]:
            dq.pop()

        # 3. Add current element's index to the back
        dq.append(i)

        # 4. Add the max (which is at the front) to results once the window is full
        if i >= k - 1:
            result.append(nums[dq[0]])

    return result
```

#### Tricks/Gotchas
- The deque should store **indices**, not values. Storing indices makes it easy to know when an element has fallen out of the sliding window's range.
- When maintaining the monotonic property, if the problem requires the *first* maximum, you'd pop elements `<` the current. If it allows any maximum (including later ones), popping `<=` is also correct and sometimes simpler. The choice affects how duplicates are handled.
