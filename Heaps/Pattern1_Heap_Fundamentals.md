# Pattern 1: Heap Fundamentals

This pattern covers the essential concepts and implementations of heaps (specifically binary heaps), which are the most common underlying structure for Priority Queues. Understanding these fundamentals is crucial before tackling more complex heap-based problems.

---

### 1. Introduction to Priority Queues using Binary Heaps
`[FUNDAMENTAL]` `[EASY]` `#concept` `#data-structure`

#### Concept Overview
A **Priority Queue** is an abstract data type that operates like a regular queue but with an added "priority" for each element. When you dequeue an element, the one with the highest priority is removed first. This is different from a standard queue's First-In-First-Out (FIFO) logic.

While several data structures can implement a priority queue (e.g., an array or linked list), the most efficient and common choice is a **Binary Heap**.

A **Binary Heap** is a complete binary tree that satisfies the heap property:
1.  **Min-Heap Property:** The value of each parent node is less than or equal to the value of its children. This means the root node always holds the minimum value.
2.  **Max-Heap Property:** The value of each parent node is greater than or equal to the value of its children. This means the root node always holds the maximum value.

Heaps provide an excellent balance of performance for the two main priority queue operations:
-   **Insertion (Enqueue):** O(log n)
-   **Deletion (Dequeue):** O(log n)
-   **Peek (Get Max/Min):** O(1)

Heaps are typically represented using an array to save space and improve cache performance. For a node at index `i`:
-   Its left child is at index `2*i + 1`.
-   Its right child is at index `2*i + 2`.
-   Its parent is at index `floor((i-1)/2)`.

---

### 2. Min Heap and Max Heap Implementation
`[FUNDAMENTAL]` `[MEDIUM]` `#implementation` `#min-heap` `#max-heap`

#### Problem Statement
Implement both a Min-Heap and a Max-Heap data structure that support insertion and extraction of the root element.

#### Implementation Overview
In Python, the `heapq` module provides a direct implementation of a Min-Heap.
-   **Min-Heap:** Use `heapq.heappush` to insert and `heapq.heappop` to extract the minimum element.
-   **Max-Heap:** Since `heapq` is only a min-heap, the standard trick is to **insert the negation** of the values. When you extract a value, you negate it again to get the original maximum value.

#### Python Code Snippet
```python
import heapq

# Min-Heap Example
min_heap = []
heapq.heappush(min_heap, 3)
heapq.heappush(min_heap, 1)
heapq.heappush(min_heap, 4)
# To extract the smallest element (1):
smallest = heapq.heappop(min_heap) # smallest is 1
# The heap is now [3, 4]

# Max-Heap Example (using negation)
max_heap = []
heapq.heappush(max_heap, -3) # Store -3 for 3
heapq.heappush(max_heap, -1) # Store -1 for 1
heapq.heappush(max_heap, -4) # Store -4 for 4
# To extract the largest element (4):
largest = -heapq.heappop(max_heap) # largest is 4
# The heap is now [-3, -1] (representing [3, 1])
```

#### Tricks/Gotchas
-   Remember that Python's `heapq` operates on a list in-place.
-   The negation trick is a clean and efficient way to simulate a max-heap without writing a custom heap class from scratch.

---

### 3. Check if an array represents a min-heap or not
`[EASY]` `#heap-property` `#validation`

#### Problem Statement
Given an array, determine if it represents a valid Min-Heap.

#### Implementation Overview
The core idea is to iterate through all **non-leaf nodes** and check if they satisfy the Min-Heap property. A node is a leaf if its index `i` is `i >= n/2`, where `n` is the array size. Therefore, we only need to check nodes from index `0` to `(n/2) - 1`.

For each parent node at index `i`:
1.  Calculate the indices of its left (`2*i + 1`) and right (`2*i + 2`) children.
2.  If the left child exists and its value is smaller than the parent's, it's not a min-heap.
3.  If the right child exists and its value is smaller than the parent's, it's not a min-heap.
4.  If all parent nodes satisfy the property, the array is a valid min-heap.

This approach is O(n) because we visit each node at most once.

#### Related Problems
-   Convert min Heap to max Heap

---

### 4. Convert min Heap to max Heap
`[MEDIUM]` `#heapify` `#conversion`

#### Problem Statement
Given an array representing a Min-Heap, convert it in-place to a Max-Heap.

#### Implementation Overview
A Min-Heap does not satisfy the Max-Heap property (and vice versa). Therefore, converting it requires rebuilding the heap structure. You cannot simply negate values as the array is already given.

The standard algorithm to build a heap from an arbitrary array is to run a `heapify` process on all non-leaf nodes in reverse order.
1.  Identify the last non-leaf node. Its index is `(n/2) - 1`, where `n` is the array size.
2.  Iterate from this node backwards up to the root (index 0).
3.  In each iteration, call a `max_heapify` function on the current node. The `max_heapify` function ensures that the subtree rooted at the given node is a max-heap. It does this by "sifting down" the node to its correct position.

This process works because by starting from the last non-leaf node, we ensure that when we `heapify` a node, its subtrees are already valid heaps. The overall complexity is O(n).

#### Tricks/Gotchas
-   The key insight is that you don't need to touch the leaf nodes, as they are already trivial heaps of size 1.
-   The build-heap process must be done "bottom-up" (from the last non-leaf node to the root). A top-down approach will not work correctly.
