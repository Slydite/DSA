# Pattern 1: Foundational Operations & Traversal

This pattern covers the fundamental properties and traversal algorithms of a Binary Search Tree (BST). Understanding these core concepts is essential, as nearly all other BST problems are built upon them. The key idea in this pattern is leveraging the BST property—left subtree nodes are smaller, right subtree nodes are larger—to efficiently navigate and search the tree in O(H) time, where H is the height of the tree.

---

### 1. Introduction to Binary Search Tree
`[FUNDAMENTAL]` `[EASY]` `#bst` `#theory`

#### Problem Statement
Understand and define the properties of a Binary Search Tree.

#### Implementation Overview
A Binary Search Tree is a node-based binary tree data structure which has the following properties:
1.  **Left Subtree Property:** The value of every node in a node's left subtree is strictly less than the node's value.
2.  **Right Subtree Property:** The value of every node in a node's right subtree is strictly greater than the node's value.
3.  **Recursive Structure:** Both the left and right subtrees must also be binary search trees.
4.  **No Duplicates:** Typically, BSTs do not contain duplicate values. (This can vary by implementation, but is a common assumption).

These properties ensure that an in-order traversal of a BST will yield its values in sorted order.

**Time Complexity:**
-   **Balanced BST:** In a balanced BST (like an AVL or Red-Black Tree), the height `H` is proportional to `log(N)`, where `N` is the number of nodes. Operations like search, insert, and delete have an average and worst-case time complexity of **O(log N)**.
-   **Unbalanced BST:** In the worst case (e.g., a skewed tree where each node has only one child), the tree degenerates into a linked list. The height `H` becomes `N`. Operations in this case have a worst-case time complexity of **O(N)**.

#### Related Problems
- All other problems in this topic.

---

### 2. Search in a Binary Search Tree
`[FUNDAMENTAL]` `[EASY]` `#bst` `#traversal`

#### Problem Statement
Given the root of a BST and a target value, find the node in the tree that has the given value. If such a node does not exist, return `null`.

*Example:*
- **Input:** `root = [4,2,7,1,3]`, `val = 2`
- **Output:** The node with value 2.

#### Implementation Overview
The search operation efficiently uses the BST property to discard half of the tree at each step.
1.  Start with the `root` node.
2.  Compare the `target` value with the current node's value.
3.  - If `target == current.val`, the node is found. Return the current node.
    - If `target < current.val`, the target must be in the left subtree. Move to the left child: `current = current.left`.
    - If `target > current.val`, the target must be in the right subtree. Move to the right child: `current = current.right`.
4.  Repeat this process. If `current` becomes `null`, it means the value is not in the tree.

This can be implemented both iteratively (with a `while` loop) and recursively.

#### Python Code Snippet (Iterative)
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def search_bst(root: TreeNode, val: int) -> TreeNode:
    current = root
    while current:
        if val == current.val:
            return current
        elif val < current.val:
            current = current.left
        else:
            current = current.right
    return None
```

#### Tricks/Gotchas
- **Efficiency:** The search is very fast (O(log N) on a balanced tree) because we eliminate a large portion of the search space at every step.

#### Related Problems
- 6. Insert a given Node in Binary Search Tree
- 7. Delete a Node in Binary Search Tree

---

### 3. Find Min/Max in BST
`[FUNDAMENTAL]` `[MEDIUM]` `#bst` `#traversal`

#### Problem Statement
Given the root of a BST, find the minimum and maximum value nodes in the tree.

#### Implementation Overview
The BST properties provide a simple path to the minimum and maximum elements.
-   **Minimum Value:** The smallest value is always the terminal node of the path that goes left from the root as much as possible. To find it, start at the root and repeatedly move to the left child until you reach a node with no left child. This node is the minimum.
-   **Maximum Value:** Symmetrically, the largest value is the rightmost node. To find it, start at the root and repeatedly move to the right child until you reach a node with no right child.

#### Python Code Snippet
```python
def find_min(root: TreeNode) -> TreeNode:
    if not root:
        return None
    current = root
    while current.left:
        current = current.left
    return current

def find_max(root: TreeNode) -> TreeNode:
    if not root:
        return None
    current = root
    while current.right:
        current = current.right
    return current
```

#### Tricks/Gotchas
- **Empty Tree:** Always handle the case where the input `root` is `null`.

#### Related Problems
- 7. Delete a Node in Binary Search Tree (uses `find_min` to find the inorder successor).

---

### 4. Ceil in a Binary Search Tree
`[EASY]` `#bst` `#traversal`

#### Problem Statement
Given the root of a BST and a key, find the "ceil" of the key. The ceil is the smallest value in the tree that is greater than or equal to the key. If no such value exists, return -1.

#### Implementation Overview
This is a modified search. We traverse the tree, keeping track of the best possible `ceil` value found so far.
1.  Initialize `ceil = -1` (or `null`).
2.  Start a traversal from the `root`.
3.  - If `current.val == key`, we have found the exact value. This is the ceil. Return `current.val`.
    - If `key < current.val`, the current node is a *potential* answer for the ceil. We record it (`ceil = current.val`) and then move to the left subtree (`current = current.left`) to see if we can find an even smaller value that is still greater than the key.
    - If `key > current.val`, the current node is too small to be the ceil. The ceil must be in the right subtree, so we move right (`current = current.right`) without updating our `ceil` variable.
4.  The loop terminates when `current` is `null`. The last recorded `ceil` value is the answer.

#### Python Code Snippet
```python
def find_ceil(root: TreeNode, key: int) -> int:
    ceil = -1
    current = root
    while current:
        if current.val == key:
            return key

        if key < current.val:
            ceil = current.val # Potential answer
            current = current.left # Try to find a smaller ceil
        else:
            current = current.right # Current node is too small

    return ceil
```

#### Tricks/Gotchas
- **Candidate Selection:** The key is to only update your `ceil` candidate when you find a node larger than the key, and then immediately try to find a "better" (smaller) candidate in its left subtree.

#### Related Problems
- 5. Floor in a Binary Search Tree

---

### 5. Floor in a Binary Search Tree
`[EASY]` `#bst` `#traversal`

#### Problem Statement
Given the root of a BST and a key, find the "floor" of the key. The floor is the largest value in the tree that is less than or equal to the key. If no such value exists, return -1.

#### Implementation Overview
The logic is symmetric to finding the ceil. We traverse the tree, keeping track of the best `floor` value found so far.
1.  Initialize `floor = -1` (or `null`).
2.  Start a traversal from the `root`.
3.  - If `current.val == key`, we have found the exact value. This is the floor. Return `current.val`.
    - If `key < current.val`, the current node is too large to be the floor. The floor must be in the left subtree, so we move left (`current = current.left`).
    - If `key > current.val`, the current node is a *potential* answer. We record it (`floor = current.val`) and then move to the right subtree (`current = current.right`) to see if we can find a "better" (larger) floor.
4.  The loop terminates when `current` is `null`. The last recorded `floor` value is the answer.

#### Python Code Snippet
```python
def find_floor(root: TreeNode, key: int) -> int:
    floor = -1
    current = root
    while current:
        if current.val == key:
            return key

        if key < current.val:
            current = current.left # Current node is too large
        else:
            floor = current.val # Potential answer
            current = current.right # Try to find a larger floor

    return floor
```

#### Tricks/Gotchas
- **Symmetric Logic:** This problem is a mirror image of finding the ceil. Understand one, and you understand the other.

#### Related Problems
- 4. Ceil in a Binary Search Tree

---

### 10. LCA in Binary Search Tree
`[MEDIUM]` `#bst` `#traversal` `#lca`

#### Problem Statement
Given a Binary Search Tree and two nodes `p` and `q`, find the Lowest Common Ancestor (LCA) of the two nodes. The LCA is defined as the lowest node in the tree that has both `p` and `q` as descendants.

#### Implementation Overview
Unlike in a regular binary tree, we can find the LCA in a BST very efficiently without recursion on both subtrees, using the BST property.
1.  Start a traversal from the `root`.
2.  At each `current` node, compare its value with the values of `p` and `q`.
    -   If both `p.val` and `q.val` are greater than `current.val`, it means both nodes are in the right subtree. The LCA must also be in the right subtree, so we move right: `current = current.right`.
    -   If both `p.val` and `q.val` are less than `current.val`, it means both nodes are in the left subtree. The LCA must also be in the left subtree, so we move left: `current = current.left`.
    -   If neither of the above conditions is true, it means the `current` node's value lies between `p.val` and `q.val` (or is equal to one of them). This is the "split point" where the paths to `p` and `q` diverge. Therefore, the `current` node is the LCA.

#### Python Code Snippet
```python
def lowest_common_ancestor(root: TreeNode, p: TreeNode, q: TreeNode) -> TreeNode:
    current = root
    while current:
        if p.val > current.val and q.val > current.val:
            current = current.right
        elif p.val < current.val and q.val < current.val:
            current = current.left
        else:
            # Found the split point, this is the LCA
            return current
    return None
```

#### Tricks/Gotchas
- **Efficiency:** This approach has a time complexity of O(H), where H is the height of the tree. This is much better than the standard binary tree LCA algorithm.

#### Related Problems
- None in this list.
