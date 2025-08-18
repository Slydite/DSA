# Pattern 3: In-order Traversal Applications

A defining property of a Binary Search Tree is that a standard in-order traversal (Left, Root, Right) visits the nodes in ascending sorted order. This pattern covers a wide range of problems that are solved by leveraging this property. The solution often involves performing an in-order traversal and either analyzing the sequence of nodes as they are visited or processing the resulting sorted list.

---

### 8. Find K-th smallest/largest element in BST
`[MEDIUM]` `#bst` `#inorder-traversal`

#### Problem Statement
Given the root of a BST and an integer `k`, find the `k`-th smallest element in the tree.

*Example:*
- **Input:** `root = [3,1,4,null,2]`, `k = 1`
- **Output:** `1`

#### Implementation Overview
The most straightforward solution uses an in-order traversal. Since the traversal visits nodes in sorted order, the `k`-th node visited will be the `k`-th smallest element.

1.  **In-order Traversal:** Perform a recursive or iterative in-order traversal.
2.  **Maintain a Counter:** Use a counter variable, initialized to `k`.
3.  In the traversal, after visiting the left subtree but before visiting the root, decrement the counter.
4.  If the counter becomes `0`, the current node is the `k`-th smallest element. Store this node's value and stop the traversal.
5.  If the counter is not yet `0`, proceed to visit the right subtree.

To find the **k-th largest** element, you can either:
a.  Find the `(N-k+1)`-th smallest element, where `N` is the total number of nodes.
b.  Perform a reverse in-order traversal (Right, Root, Left) and find the `k`-th element.

#### Python Code Snippet (K-th Smallest)
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def kthSmallest(self, root: TreeNode, k: int) -> int:
        self.k = k
        self.result = -1
        self.inorder_traverse(root)
        return self.result

    def inorder_traverse(self, node: TreeNode):
        if not node or self.k == 0:
            return

        # Traverse left
        self.inorder_traverse(node.left)

        # Process root
        if self.k > 0:
            self.k -= 1
            if self.k == 0:
                self.result = node.val
                return

        # Traverse right
        self.inorder_traverse(node.right)
```

#### Tricks/Gotchas
- **Early Exit:** The traversal can be stopped as soon as the `k`-th element is found to save computation.

#### Related Problems
- 12. Inorder Successor/Predecessor in BST

---

### 9. Check if a tree is a BST or BT
`[MEDIUM]` `#bst` `#inorder-traversal` `#validation`

#### Problem Statement
Given the root of a binary tree, determine if it is a valid Binary Search Tree (BST).

#### Implementation Overview
There are two common methods to validate a BST.

**1. In-order Traversal and Check Sortedness:**
The simplest concept is to perform an in-order traversal and collect all the node values into a list. After the traversal is complete, check if the list is strictly sorted. While easy to understand, this requires O(N) extra space for the list. A space-optimized version of this approach keeps track of only the `previous` node visited during the in-order traversal and checks if `current.val > previous.val` at each step.

**2. Recursive with Valid Range (Min/Max):**
A more robust and often preferred method is a recursive approach that validates each node against a `(min_val, max_val)` range.
1.  Define a recursive helper function `is_valid(node, lower_bound, upper_bound)`.
2.  The initial call will be `is_valid(root, -infinity, +infinity)`.
3.  For a `node` to be valid, its value must be strictly between `lower_bound` and `upper_bound`.
4.  When recurring on the `node.left`, the valid range for the left child becomes `(lower_bound, node.val)`. The upper bound is now the parent's value.
5.  When recurring on the `node.right`, the valid range for the right child becomes `(node.val, upper_bound)`. The lower bound is now the parent's value.
6.  If any node violates its range, the tree is not a valid BST.

#### Python Code Snippet (Min/Max Range)
```python
def is_valid_bst(root: TreeNode) -> bool:

    def validate(node, low=float('-inf'), high=float('inf')):
        if not node:
            return True # An empty tree is a valid BST

        # The current node's value must be within the bounds
        if not (low < node.val < high):
            return False

        # The left subtree's upper bound is node.val
        # The right subtree's lower bound is node.val
        return (validate(node.left, low, node.val) and
                validate(node.right, node.val, high))

    return validate(root)
```

#### Tricks/Gotchas
- **Strict Inequality:** The definition of a BST usually requires strict inequalities (`<` and `>`), not `<=` or `>=`. Be clear on this constraint.

#### Related Problems
- 11. Construct a BST from a preorder traversal
- 15. Recover BST | Correct BST with two nodes swapped

---

### 12. Inorder Successor/Predecessor in BST
`[MEDIUM]` `#bst` `#inorder-traversal`

#### Problem Statement
Given a node `p` in a BST, find its in-order successor. The successor is the node with the smallest key greater than `p.val`.

#### Implementation Overview
The solution depends on whether the given node `p` has a right subtree.

1.  **If `p` has a right subtree:** The in-order successor is the node with the minimum value in that right subtree. To find this, we simply traverse as far left as possible from `p.right`.
2.  **If `p` has no right subtree:** The successor is an ancestor. We must find the lowest ancestor of `p` for which `p` is in its left subtree. We can find this by traversing down from the `root` of the entire tree.
    -   Start at the `root`.
    -   Initialize a `successor` candidate to `null`.
    -   While traversing towards `p`:
        -   If `p.val < current.val`, the `current` node is a potential successor. Store it (`successor = current`) and move left.
        -   If `p.val > current.val`, the `current` node cannot be the successor. Move right.
    -   The last `successor` candidate recorded is the answer.

The logic for the **in-order predecessor** is symmetric.

#### Python Code Snippet (Successor)
```python
def inorder_successor(root: TreeNode, p: TreeNode) -> TreeNode:
    # Case 1: Node has a right subtree
    if p.right:
        current = p.right
        while current.left:
            current = current.left
        return current

    # Case 2: Node has no right subtree
    successor = None
    current = root
    while current:
        if p.val < current.val:
            successor = current # Potential successor
            current = current.left
        elif p.val > current.val:
            current = current.right
        else: # We found p
            break

    return successor
```

#### Tricks/Gotchas
- **Two Distinct Cases:** The logic is completely different depending on the existence of a right subtree. Both must be handled.

#### Related Problems
- 8. Find K-th smallest/largest element in BST

---

### 14. Two Sum In BST
`[MEDIUM]` `#bst` `#inorder-traversal` `#two-pointers`

#### Problem Statement
Given the root of a BST and a target number `k`, return `true` if there exist two elements in the BST such that their sum is equal to `k`, or `false` otherwise.

#### Implementation Overview
**Approach 1: In-order Traversal + Two Pointers (O(N) time, O(N) space)**
1.  Perform an in-order traversal of the BST to get a sorted list of its node values.
2.  Use the standard two-pointer technique on this sorted list to find if a pair sums to `k`.
    -   Initialize `left = 0` and `right = len(list) - 1`.
    -   If `sum > k`, decrement `right`. If `sum < k`, increment `left`. If `sum == k`, return `true`.

**Approach 2: Using a BST Iterator (O(N) time, O(H) space)**
This approach avoids storing the entire tree in a list.
1.  Implement a `BSTIterator` class that supports `next()` (for forward in-order traversal) and `prev()` (for reverse in-order traversal). This is typically done using a stack.
2.  Create two iterators, one for `next` and one for `prev`.
3.  Use these iterators to simulate the two-pointer approach directly on the tree structure.

#### Python Code Snippet (Approach 1)
```python
def find_target(root: TreeNode, k: int) -> bool:

    def inorder(node):
        if not node:
            return []
        return inorder(node.left) + [node.val] + inorder(node.right)

    sorted_list = inorder(root)

    left, right = 0, len(sorted_list) - 1
    while left < right:
        current_sum = sorted_list[left] + sorted_list[right]
        if current_sum == k:
            return True
        elif current_sum < k:
            left += 1
        else:
            right -= 1

    return False
```

#### Tricks/Gotchas
- **Space-Time Tradeoff:** The first approach is simple but uses O(N) space. The second is more complex to implement but optimal in space (O(H)).

#### Related Problems
- (Arrays) 15. 2Sum Problem

---

### 15. Recover BST | Correct BST with two nodes swapped
`[HARD]` `#bst` `#inorder-traversal` `#modification`

#### Problem Statement
You are given the `root` of a BST where exactly two nodes have been swapped by mistake. Recover the tree without changing its structure.

*Example:*
- **Input:** `root = [3,1,4,null,null,2]` (3 and 2 are swapped)
- **Output:** `root = [2,1,4,null,null,3]`

#### Implementation Overview
The core insight is that an in-order traversal of the corrupted BST will reveal the swapped nodes. In a correct in-order traversal, `prev.val < current.val` always holds. A swap will create one or two violations of this rule.
1.  Initialize three pointers: `first = None`, `middle = None`, `last = None`, and `prev = TreeNode(float('-inf'))`.
2.  Perform an in-order traversal. At each node, compare `current.val` with `prev.val`.
3.  If `prev.val > current.val`, we've found a "dip" or violation.
    -   If this is the **first violation** we've found (`first` is `None`), it means `prev` is the first out-of-place node. So, `first = prev`. `middle` is set to the `current` node, as it might be the second swapped node (in case the swapped nodes are adjacent).
    -   If this is the **second violation** (`first` is not `None`), it means the `current` node is the second out-of-place node. So, `last = current`.
4.  After the traversal, if `last` is not `None`, it means the swapped nodes were `first` and `last`. Swap their values.
5.  If `last` is `None`, it means the swapped nodes were adjacent in the in-order sequence. The nodes to swap are `first` and `middle`. Swap their values.

#### Python Code Snippet
```python
class Solution:
    def recoverTree(self, root: TreeNode) -> None:
        self.first = None
        self.middle = None
        self.last = None
        self.prev = TreeNode(float('-inf'))

        def inorder(node):
            if not node:
                return

            inorder(node.left)

            # Check for violation
            if self.prev.val > node.val:
                if not self.first:
                    # First violation
                    self.first = self.prev
                    self.middle = node
                else:
                    # Second violation
                    self.last = node

            self.prev = node

            inorder(node.right)

        inorder(root)

        if self.last:
            # Non-adjacent swap
            self.first.val, self.last.val = self.last.val, self.first.val
        else:
            # Adjacent swap
            self.first.val, self.middle.val = self.middle.val, self.first.val
```

#### Tricks/Gotchas
- **Identifying Nodes:** Correctly identifying which nodes to swap based on one or two violations is the main challenge.

#### Related Problems
- 9. Check if a tree is a BST or BT
