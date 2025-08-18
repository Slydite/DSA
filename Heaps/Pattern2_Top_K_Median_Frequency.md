# Pattern 2: Top 'K' / Median / Frequency Problems

This pattern focuses on using heaps to solve problems related to finding the "Kth" element, tracking elements based on frequency, or maintaining the median of a dataset. The core idea is that a heap is extremely efficient at keeping track of the smallest or largest elements in a collection without needing to fully sort it.

---

### 1. Kth Largest Element in an Array
`[MEDIUM]` `#top-k` `#min-heap`

#### Problem Statement
Find the Kth largest element in an unsorted array. Note that it is the Kth largest element in the sorted order, not the Kth distinct element.

#### Implementation Overview
The most efficient heap-based solution uses a **Min-Heap** of size K.
1.  Iterate through the elements of the array.
2.  For each element, push it onto the min-heap.
3.  If the heap's size exceeds K, pop the smallest element. This is key: the heap maintains the K largest elements seen so far at all times.
4.  After iterating through all elements, the root of the min-heap (the smallest element among the top K) is the Kth largest element in the array.

This approach has a time complexity of O(N log K), which is better than sorting the entire array (O(N log N)) if K is much smaller than N.

#### Python Code Snippet
```python
import heapq

def findKthLargest(nums, k):
    min_heap = []
    for num in nums:
        heapq.heappush(min_heap, num)
        if len(min_heap) > k:
            heapq.heappop(min_heap)
    return min_heap[0]
```

#### Related Problems
-   Kth Smallest Element in an Array
-   Kth Largest Element in a Stream

---

### 2. Kth Smallest Element in an Array
`[EASY]` `#top-k` `#max-heap`

#### Problem Statement
Find the Kth smallest element in an unsorted array.

#### Implementation Overview
This is the mirror image of finding the Kth largest element. The optimal heap-based solution uses a **Max-Heap** of size K.
1.  Iterate through the elements.
2.  Push the negation of each element onto a min-heap (simulating a max-heap).
3.  If the heap's size exceeds K, pop the "smallest" element (which is the largest in magnitude, i.e., the largest original number).
4.  After the loop, the root of the heap is the negation of the Kth smallest element.

This keeps the K smallest elements in the heap at all times. The complexity is also O(N log K).

---

### 3. Kth Largest Element in a Stream
`[EASY]` `#top-k` `#stream`

#### Problem Statement
Design a class to find the Kth largest element in a stream of numbers. The class should have a constructor that takes `k` and an initial array of numbers, and a method `add` that adds a new number to the stream and returns the current Kth largest element.

#### Implementation Overview
This problem is a direct application of the "Kth Largest" pattern. The class will maintain a **Min-Heap** of size K internally.
-   **Constructor:** Initialize the min-heap with the initial numbers. Crucially, ensure the heap size is trimmed down to K to establish the baseline.
-   **`add(val)` method:**
    1. Push the new value `val` onto the heap.
    2. If the heap size is now greater than K, pop the smallest element.
    3. The root of the heap is always the current Kth largest element, so return it.

---

### 4. Find Median from Data Stream
`[HARD]` `#two-heaps` `#median` `#stream`

#### Problem Statement
Design a data structure that supports adding numbers from a data stream and allows finding the median of all elements seen so far.

#### Implementation Overview
The key to solving this in O(log n) per insertion is to use **two heaps**:
1.  A **Max-Heap (`small_half`)** to store the smaller half of the numbers.
2.  A **Min-Heap (`large_half`)** to store the larger half of the numbers.

**Balancing Logic:**
-   The heaps should be kept at roughly the same size. The `max_heap` can have at most one more element than the `min_heap`.
-   When adding a new number, push it onto the `max_heap`. Then, to maintain the heap properties, pop the largest element from `small_half` and push it onto `large_half`.
-   If `large_half` becomes larger than `small_half`, pop the smallest from `large_half` and push it back to `small_half`.

**Median Calculation:**
-   If the total number of elements is odd, the median is the top of the `max_heap` (`small_half`).
-   If the total is even, the median is the average of the tops of both heaps.

#### Tricks/Gotchas
-   Remember to use negation for the max-heap in Python.
-   Careful handling of the heap balancing logic is critical to ensure correctness.

---

### 5. K Most Frequent Elements
`[MEDIUM]` `#top-k` `#frequency` `#hashmap`

#### Problem Statement
Given an array of integers, return the `k` most frequent elements.

#### Implementation Overview
This is a two-stage problem:
1.  **Frequency Counting:** Use a Hash Map (dictionary in Python) to count the frequency of each number in the input array. This takes O(N) time.
2.  **Finding Top K:** Use a **Min-Heap** of size K to find the K elements with the highest frequencies.
    -   Iterate through the (element, frequency) pairs in your hash map.
    -   Push `(frequency, element)` tuples onto the min-heap.
    -   If the heap size exceeds K, pop the element with the smallest frequency.
    -   After iterating, the heap will contain the K most frequent elements. Extract them to build the final result.

The heap operations take O(M log K) time, where M is the number of unique elements.

---

### 6. Maximum Sum Combination
`[MEDIUM]` `#top-k` `#merging`

#### Problem Statement
Given two arrays `A` and `B` of equal size, find the `k` largest sum combinations, where a sum combination is `A[i] + B[j]`.

#### Implementation Overview
A brute-force approach of generating all N*N sums and sorting is too slow (O(N^2 log(N^2))). A better approach uses a heap to intelligently explore the combinations.
1.  Sort both arrays `A` and `B` in ascending order.
2.  The largest possible sum is `A[n-1] + B[n-1]`.
3.  Use a **Max-Heap** to store tuples of `(sum, index_A, index_B)`.
4.  Initialize the heap with the largest sum: `(A[n-1] + B[n-1], n-1, n-1)`.
5.  Use a set to keep track of visited `(index_A, index_B)` pairs to avoid duplicates.
6.  Loop `k` times:
    a. Pop the max sum from the heap. Add it to the result.
    b. From the popped `(sum, i, j)`, generate two new candidates to push to the heap (if not visited):
       - `(A[i-1] + B[j], i-1, j)`
       - `(A[i] + B[j-1], i, j-1)`

This ensures you are always exploring from the largest available sums downwards.

---

### 7. Replace each array element by its corresponding rank
`[EASY]` `#ranking` `#sorting`

#### Problem Statement
Given an array of integers, replace each element with its rank. The rank is 1-based. If two elements are equal, they should have the same rank.

#### Implementation Overview
While not a classic heap problem, a heap can be used as a sorting mechanism. The most direct solution involves sorting.
1.  Create a copy of the original array.
2.  Sort the copy in ascending order. Using a heap to sort (Heapsort) is one way to do this.
3.  Create a hash map (`rank_map`) to store the rank of each unique element.
4.  Iterate through the sorted copy. For each unique element, assign it a rank (e.g., first unique element gets rank 1, second gets rank 2, etc.). Store this in `rank_map`.
5.  Iterate through the **original array** and use `rank_map` to look up the rank for each element, creating the result array.

This ensures that ties are handled correctly and the original array order is respected for the output. The complexity is dominated by the sorting step, O(N log N).
