# Pattern 6: Advanced Data Structure Design

This pattern covers problems that require designing custom data structures, often by combining stacks, queues, linked lists, and hash maps. These problems test a deeper understanding of data structure trade-offs and are common in interviews for senior roles.

---

### 1. Implement Min Stack
`[MEDIUM]` `#stack` `#design`

#### Problem Statement
Design a stack that supports `push`, `pop`, `top`, and `getMin` in constant time. `getMin` should retrieve the minimum element in the stack.

#### Implementation Overview
The challenge is to get the minimum element in O(1) time. A standard stack doesn't provide this. The solution is to use an auxiliary data structure to keep track of the minimums.

**Method: Storing (value, current_min) pairs**
- Use a single stack that stores pairs: `(value, min_at_this_level)`.
- When pushing `x`, the new minimum is `min(x, current_min)`. Push the pair `(x, new_min)` onto the stack.
- This approach is clean and ensures that for any state of the stack, the minimum is available at the top.

#### Python Code Snippet
```python
class MinStack:
    def __init__(self):
        # Stack stores pairs of (value, current_minimum)
        self.stack = []

    def push(self, val: int) -> None:
        if not self.stack:
            # If stack is empty, the min is the value itself
            self.stack.append((val, val))
        else:
            # The new min is the smaller of the new value and the previous min
            current_min = self.stack[-1][1]
            new_min = min(val, current_min)
            self.stack.append((val, new_min))

    def pop(self) -> None:
        if self.stack:
            self.stack.pop()

    def top(self) -> int:
        if self.stack:
            return self.stack[-1][0] # Return the value
        return -1

    def getMin(self) -> int:
        if self.stack:
            return self.stack[-1][1] # Return the min
        return -1
```

---

### 2. The Celebrity Problem
`[HARD]` `#stack` `#graph` `#two-pointers`

#### Problem Statement
In a party of `N` people, a celebrity is someone who is known by everyone but knows no one. You are given a function `knows(a, b)` which returns `true` if `a` knows `b`. Find the potential celebrity.

#### Implementation Overview
This problem can be modeled as a directed graph where an edge `a -> b` means `a` knows `b`. A celebrity is a "sink" node with in-degree `N-1` and out-degree `0`. A brute-force check is O(N^2). We can do better.

**Method: Using a Stack (O(N) time, O(N) space)**
1.  Push all people (indices `0` to `N-1`) onto a stack.
2.  While the stack has more than one person:
    - Pop two people, `A` and `B`.
    - If `knows(A, B)`, then `A` cannot be a celebrity (they know someone). Push `B` back onto the stack as a potential candidate.
    - If `!knows(A, B)`, then `B` cannot be a celebrity (A doesn't know them). Push `A` back.
3.  The single person remaining in the stack is the *only potential candidate*.
4.  **Verify the candidate**: Iterate through all other people to confirm the candidate knows no one and is known by everyone. This final check takes O(N) time.

---

### 3. LRU Cache (Least Recently Used)
`[HARD]` `#design` `#hash-map` `#doubly-linked-list`

#### Problem Statement
Design a data structure for an LRU cache. It should support `get(key)` and `put(key, value)` operations in O(1) time. When the cache is full, a `put` operation should evict the least recently used item.

#### Implementation Overview
This is a classic design problem that requires O(1) time complexity for both `get` and `put`. The optimal solution combines a hash map and a doubly linked list.
1.  **Hash Map (`dict` in Python)**: Stores `key -> Node` pairs. This provides O(1) access to any node in the list.
2.  **Doubly Linked List**: Stores the nodes themselves. The list is ordered by recency. The most recently used item is at the head, and the least recently used item is at the tail.

**Operations:**
- **`get(key)`**: Look up the node in the hash map. If found, move the node to the head of the linked list (marks it as most recently used) and return its value.
- **`put(key, value)`**: If the key exists, update its value and move the node to the head. If not, create a new node. If the cache is full, remove the tail node from the list and hash map. Finally, add the new node to the head of the list and to the hash map.

#### Python Code Snippet
```python
class Node:
    def __init__(self, key, val):
        self.key, self.val = key, val
        self.prev = self.next = None

class LRUCache:
    def __init__(self, capacity: int):
        self.cap = capacity
        self.cache = {} # map key to node
        # head is Most Recently Used, tail is Least Recently Used
        self.head, self.tail = Node(0, 0), Node(0, 0)
        self.head.next, self.tail.prev = self.tail, self.head

    def _remove(self, node):
        prev, nxt = node.prev, node.next
        prev.next, nxt.prev = nxt, prev

    def _add_to_head(self, node):
        node.prev, node.next = self.head, self.head.next
        self.head.next.prev = node
        self.head.next = node

    def get(self, key: int) -> int:
        if key in self.cache:
            node = self.cache[key]
            self._remove(node)
            self._add_to_head(node)
            return node.val
        return -1

    def put(self, key: int, value: int) -> None:
        if key in self.cache:
            self._remove(self.cache[key])

        node = Node(key, value)
        self.cache[key] = node
        self._add_to_head(node)

        if len(self.cache) > self.cap:
            lru = self.tail.prev
            self._remove(lru)
            del self.cache[lru.key]
```

---

### 4. LFU Cache (Least Frequently Used)
`[HARD]` `#design` `#hash-map` `#doubly-linked-list`

#### Problem Statement
Design a data structure for an LFU cache. It supports `get` and `put`. When the cache is full, it evicts the least frequently used item. If there's a tie in frequency, the least *recently* used item among them is evicted.

#### Implementation Overview
This is significantly more complex than LRU. It requires tracking frequency counts in addition to recency. An optimal solution uses:
1.  **A key-to-node hash map**: Maps a key to its node `(key, value, freq)`.
2.  **A frequency-to-list hash map**: Maps a frequency count to a Doubly Linked List (acting as an LRU list) of nodes that have that frequency.
3.  A variable `min_freq` to track the current lowest frequency, for O(1) eviction.

**Operations:**
- When a node is accessed (via `get` or `put`):
  - Its frequency increases by 1.
  - It must be moved from the LRU list at `freq` to the head of the LRU list at `freq + 1`.
  - Update `min_freq` if the list at the old `min_freq` becomes empty.
- **Eviction**: When the cache is full, use `min_freq` to find the correct LRU list. Remove the node at the tail of that list.
