---

### 1. Sort LL
`[MEDIUM]` `#divide-and-conquer` `#merge-sort` `#linked-list`

#### Problem Statement
Given the `head` of a linked list, return the list after sorting it in ascending order.

#### Implementation Overview
The most suitable sorting algorithm for linked lists is **Merge Sort**, due to its efficiency and the fact that it doesn't rely on random access. The process is a classic divide-and-conquer strategy.

1.  **Base Case**: If the list has 0 or 1 nodes, it is already sorted. Return `head`.
2.  **Divide**:
    -   Split the linked list into two halves.
    -   Find the middle of the list using the slow/fast pointer technique.
    -   The `slow` pointer will mark the end of the first half.
    -   Sever the link between the two halves (`middle_predecessor.next = None`).
3.  **Conquer**:
    -   Recursively call `sortList()` on both the left half (from `head`) and the right half (from `middle`).
4.  **Merge**:
    -   Merge the two sorted halves into a single sorted list. This is done by creating a new list and iteratively picking the smaller element from the two half-lists until both are exhausted.

#### Python Code Snippet
```python
def sort_list(head):
    if not head or not head.next:
        return head

    # 1. Split the list into two halves
    middle = get_middle(head)
    next_to_middle = middle.next
    middle.next = None # Sever the link

    # 2. Recursively sort the two halves
    left = sort_list(head)
    right = sort_list(next_to_middle)

    # 3. Merge the sorted halves
    sorted_list = sorted_merge(left, right)
    return sorted_list

def get_middle(head):
    if not head:
        return head
    slow, fast = head, head.next
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    return slow

def sorted_merge(a, b):
    result = None
    if not a: return b
    if not b: return a

    if a.data <= b.data:
        result = a
        result.next = sorted_merge(a.next, b)
    else:
        result = b
        result.next = sorted_merge(a, b.next)
    return result

# A non-recursive merge function is often more practical
def sorted_merge_iterative(a, b):
    dummy = Node(0)
    tail = dummy

    while a and b:
        if a.data <= b.data:
            tail.next = a
            a = a.next
        else:
            tail.next = b
            b = b.next
        tail = tail.next

    if a:
        tail.next = a
    elif b:
        tail.next = b

    return dummy.next
```

#### Tricks/Gotchas
- **Finding Middle for Splitting**: Be careful when finding the middle. You need the node *before* the middle of the list to sever the link. The `get_middle` function provided here finds the true middle (or first of two), so the split happens correctly.
- **Merge Logic**: The merge step is critical. An iterative merge with a dummy node is often cleaner and avoids recursion depth issues.
- **Time/Space Complexity**: Merge sort for a linked list is `O(N log N)` time and `O(log N)` space due to the recursion stack.

#### Related Problems
- Middle of a LinkedList
- Merge Two Sorted Lists (a sub-problem of this)

---

### 2. Reverse LL in group of given size K
`[HARD]` `#reversal` `#linked-list` `#recursive`

#### Problem Statement
Given a linked list, reverse the nodes of the list `k` at a time and return the modified list. `k` is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of `k`, then the left-out nodes, in the end, should remain as they are.

#### Implementation Overview
This is a classic and complex recursion problem. The idea is to reverse the first `k` nodes, and then recursively call the function on the rest of the list.

1.  **Base Case**: If the list is empty, or there are fewer than `k` nodes left, we don't need to do anything. Return `head`. A helper function can first count the nodes to ensure there are at least `k`.
2.  **Reverse First `k` Nodes**:
    -   Use the standard iterative method to reverse the first `k` nodes of the current segment.
    -   You'll need three pointers: `prev`, `current`, and `next_node`.
    -   Keep a count to stop after `k` reversals.
3.  **Recursive Connection**:
    -   After reversing the first `k` nodes, the original `head` of this segment is now the *tail* of the reversed segment.
    -   The `prev` pointer from the iterative reversal is the new *head* of this segment.
    -   The key step is to connect the tail of this reversed segment (`head`) to the result of the recursive call on the rest of the list. So, `head.next = reverseKGroup(next_node, k)`, where `next_node` is the `(k+1)th` node.
4.  **Return**: Return `prev`, which is the new head of the fully processed list segment.

#### Python Code Snippet
```python
def reverse_k_group(head, k):
    # Check if we need to reverse the group
    curr = head
    count = 0
    while curr and count < k:
        curr = curr.next
        count += 1

    # If we have k nodes, reverse them
    if count == k:
        # Reverse the first k nodes
        prev = None
        curr = head
        for _ in range(k):
            next_node = curr.next
            curr.next = prev
            prev = curr
            curr = next_node

        # head is now the tail of the reversed group.
        # Connect it to the result of the recursion on the rest of the list.
        if curr is not None:
            head.next = reverse_k_group(curr, k)

        return prev # prev is the new head of this group

    # If we don't have k nodes, leave them as is
    return head
```

#### Tricks/Gotchas
- **Recursion is Key**: While an iterative solution is possible, it's much more complex to manage the pointers. Recursion naturally handles the "connect this group to the next" logic.
- **Pre-check for `k` nodes**: Before attempting to reverse, it's crucial to check if there are at least `k` nodes remaining. This handles the final, smaller-than-k group.

#### Related Problems
- Reverse a LinkedList [Iterative]

---

### 3. Rotate a LL
`[MEDIUM]` `#rearrangement` `#linked-list`

#### Problem Statement
Given the `head` of a linked list, rotate the list to the right by `k` places, where `k` is non-negative.

#### Implementation Overview
Rotating the list by `k` places means taking the last `k` nodes and moving them to the front.
1.  **Handle Edge Cases**: If the list is empty, has one node, or `k` is 0, no rotation is needed.
2.  **Find Length and Tail**: Traverse the list to find its length (`len`) and the last node (`tail`).
3.  **Connect Tail to Head**: Make the list circular by setting `tail.next = head`.
4.  **Calculate Effective Rotations**: The number of rotations might be larger than the list length. The effective number of rotations is `k = k % len`.
5.  **Find the New Tail**: The new tail of the list will be the node at position `len - k - 1`. We need to find the node *before* the new head. The new head is at position `len - k`.
6.  **Traverse to New Tail**: Traverse `len - k - 1` steps from the head to find the new tail.
7.  **Break the Circle**:
    -   The new head is `new_tail.next`.
    -   Break the circular link by setting `new_tail.next = None`.
8.  Return the `new_head`.

#### Python Code Snippet
```python
def rotate_right(head, k):
    if not head or not head.next or k == 0:
        return head

    # 1. Find length and tail
    length = 1
    tail = head
    while tail.next:
        tail = tail.next
        length += 1

    # 2. Handle k >= length
    k = k % length
    if k == 0:
        return head

    # 3. Find the new tail (node at len - k - 1)
    new_tail = head
    for _ in range(length - k - 1):
        new_tail = new_tail.next

    # 4. Find new head and break the circle
    new_head = new_tail.next
    new_tail.next = None

    # 5. Connect original tail to original head
    tail.next = head

    return new_head
```

#### Tricks/Gotchas
- **Modulo `k`**: Don't forget to take `k % length` to handle large rotation values efficiently.
- **Finding the Break Point**: The hardest part is correctly identifying the node that will become the new tail. It's the `(len - k)`-th node from the beginning, so its predecessor is at `len - k - 1`.

#### Related Problems
- Rotate Array

---

### 4. Flattening of LL
`[HARD]` `#linked-list` `#recursion` `#merge`

#### Problem Statement
You are given a linked list where each node represents a sub-linked-list and contains two pointers: `next` (pointing to the next node in the main list) and `bottom` (pointing to the head of the sub-linked-list). Each sub-linked-list is sorted in ascending order. Flatten the list into a single linked list sorted in ascending order.

#### Implementation Overview
This problem can be solved elegantly using recursion and a merge strategy, similar to Merge Sort.
1.  **Base Case**: If the `head` is `None` or `head.next` is `None`, the list is already "flattened," so return `head`.
2.  **Recursive Step**:
    -   Recursively call `flatten()` on the rest of the main list: `flatten(head.next)`. This will return a single, fully flattened and sorted list starting from the node that was originally `head.next`.
    -   Now you have two sorted lists: the `head`'s `bottom` list and the flattened list returned by the recursive call.
3.  **Merge**:
    -   Merge the `head` list (which is just `head` itself, as we'll follow its `bottom` pointers) with the `flattened_rest` list.
    -   Use the standard `sorted_merge` logic (from Merge Sort) to combine these two lists into a single sorted list.
4.  Return the head of the newly merged list.

#### Python Code Snippet
```python
# Node class for this problem
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None
        self.bottom = None

def sorted_merge(a, b):
    if not a: return b
    if not b: return a

    result = None
    if a.data <= b.data:
        result = a
        result.bottom = sorted_merge(a.bottom, b)
    else:
        result = b
        result.bottom = sorted_merge(a, b.bottom)
    result.next = None # Main list's next pointers are irrelevant now
    return result

def flatten(head):
    # Base case
    if not head or not head.next:
        return head

    # Recursively flatten the list starting from the next node
    head.next = flatten(head.next)

    # Now merge the current list (headed by `head`) with the flattened rest
    head = sorted_merge(head, head.next)

    return head
```

#### Tricks/Gotchas
- **Pointers**: The key is to realize you are merging lists connected by the `bottom` pointer, not the `next` pointer. The `next` pointers are only used for the initial traversal.
- **Recursive Merge**: The problem is a perfect fit for a "merge two sorted lists" pattern, applied recursively down the main list's `next` pointers.

#### Related Problems
- Sort LL
- Merge Two Sorted Lists

---

### 5. Clone a Linked List with random and next pointer
`[HARD]` `#linked-list` `#hashmap` `#inplace`

#### Problem Statement
Given a linked list where each node has a `next` pointer and a `random` pointer that can point to any node in the list or `null`, create a deep copy of the list.

#### Implementation Overview
There are two main approaches. The HashMap approach is more intuitive, but a clever in-place approach is more optimal in terms of space.

**Method 1: Using a HashMap**
1.  **First Pass (Create Nodes)**: Traverse the original list. For each node, create a new `Node` with the same data and store the mapping in a HashMap: `map[original_node] = new_node`.
2.  **Second Pass (Set Pointers)**: Traverse the original list again. For each `original_node`:
    -   Get its corresponding `new_node` from the map.
    -   Set the pointers on the `new_node`:
        -   `new_node.next = map[original_node.next]`
        -   `new_node.random = map[original_node.random]`
    -   Handle `null` pointers carefully.
3.  Return the head of the new list, which is `map[original_head]`.

**Method 2: In-place with Interweaving (O(1) Space)**
1.  **First Pass (Interweave Nodes)**: Traverse the original list. For each node, create its clone and insert the clone *between* the original node and its `next`.
    -   `original -> clone -> original.next`
2.  **Second Pass (Set Random Pointers)**: Traverse the interwoven list. For each `original_node`:
    -   Its `random` pointer is `original.random`.
    -   The `random` pointer for its clone should be `original.random.next` (which is the clone of the random target).
    -   So, `clone.random = original.random.next`.
3.  **Third Pass (Separate Lists)**: Traverse the interwoven list again to separate the original and cloned lists by restoring the original `next` pointers.

#### Python Code Snippet (Method 2)
```python
class NodeWithRandom:
    def __init__(self, x, next_node=None, random_node=None):
        self.val = int(x)
        self.next = next_node
        self.random = random_node

def clone_random_list(head):
    if not head:
        return None

    # 1. Interweave new nodes
    curr = head
    while curr:
        new_node = NodeWithRandom(curr.val, curr.next)
        curr.next = new_node
        curr = new_node.next

    # 2. Set random pointers
    curr = head
    while curr:
        if curr.random:
            curr.next.random = curr.random.next
        curr = curr.next.next

    # 3. Separate the lists
    old_head = head
    new_head = head.next
    clone_curr = new_head
    while old_head:
        old_head.next = clone_curr.next
        old_head = old_head.next
        if old_head:
            clone_curr.next = old_head.next
            clone_curr = clone_curr.next

    return new_head
```

#### Tricks/Gotchas
- **In-place Logic**: The interweaving method is clever but requires careful pointer manipulation across three distinct passes.
- **HashMap Simplicity**: The HashMap approach is much easier to reason about and implement correctly, even though it uses O(N) extra space. It's often the preferred solution in an interview unless O(1) space is explicitly required.

#### Related Problems
- (This problem is fairly unique)
