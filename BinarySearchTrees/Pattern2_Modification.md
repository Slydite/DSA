# Pattern 2: Modification of BST Structure

This pattern covers problems that involve altering the structure of the Binary Search Tree. This includes adding new nodes (insertion), removing existing nodes (deletion), and constructing a BST from a given traversal sequence. These operations must be performed carefully to maintain the fundamental properties of the BST at all times.

---

### 6. Insert a given Node in Binary Search Tree
`[EASY]` `#bst` `#traversal` `#modification`

#### Problem Statement
Given the root of a Binary Search Tree and a value to insert, insert the value into the BST. Return the root of the BST after the insertion. It is guaranteed that the new value does not exist in the original BST.

*Example:*
- **Input:** `root = [4,2,7,1,3]`, `val = 5`
- **Output:** `[4,2,7,1,3,5]`

#### Implementation Overview
The process of insertion involves finding the correct empty spot for the new value while respecting the BST properties.
1.  **Handle Empty Tree:** If the `root` is `null`, the new node becomes the root of the tree.
2.  **Find Insertion Point:** Start a traversal from the `root`.
3.  At each `current` node, compare the `val` to be inserted with `current.val`.
    -   If `val < current.val`, the new node belongs in the left subtree. Move to the left child.
    -   If `val > current.val`, the new node belongs in the right subtree. Move to the right child.
4.  Continue this traversal until you find a `null` link. This is where the new node should be attached.
5.  If you moved left from a `parent` node and `parent.left` is `null`, attach the new node as `parent.left`. Otherwise, if you moved right and `parent.right` is `null`, attach it as `parent.right`.

#### Python Code Snippet (Recursive)
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def insert_into_bst(root: TreeNode, val: int) -> TreeNode:
    if not root:
        return TreeNode(val)

    if val < root.val:
        root.left = insert_into_bst(root.left, val)
    else: # val > root.val
        root.right = insert_into_bst(root.right, val)

    return root
```

#### Tricks/Gotchas
- **Return Value:** The recursive solution elegantly handles attaching the new node by returning it to be assigned to the parent's `left` or `right` pointer.
- **In-place:** The operation modifies the existing tree structure.

#### Related Problems
- 7. Delete a Node in Binary Search Tree

---

### 7. Delete a Node in Binary Search Tree
`[MEDIUM]` `#bst` `#traversal` `#modification`

#### Problem Statement
Given a root node of a BST and a key, delete the node with the given key in the BST. Return the root of the BST.

#### Implementation Overview
Deletion is the most complex modification operation. It involves finding the node and then handling three cases based on its children.
1.  **Find the Node:** First, search for the node with the given `key`. If not found, do nothing.
2.  **Handle Deletion Cases:**
    -   **Case 1: The node is a leaf (no children).** This is the simplest case. Simply remove the node by setting its parent's corresponding child pointer to `null`.
    -   **Case 2: The node has one child.** Replace the node with its single child. In the parent node, link the parent directly to the grandchild.
    -   **Case 3: The node has two children.** This is the tricky case. To maintain the BST property, we must replace the node's value with either its **in-order successor** (the smallest value in its right subtree) or its **in-order predecessor** (the largest value in its left subtree).
        a. Let's use the in-order successor. Find the minimum value in the node's right subtree.
        b. Copy this successor's value into the node we want to delete.
        c. Now, the tree has a duplicate value. Recursively call the delete function to remove the successor node from the right subtree. This recursive deletion is guaranteed to fall into Case 1 or Case 2, which are simpler to handle.

#### Python Code Snippet
```python
def find_min_val_node(node: TreeNode) -> TreeNode:
    current = node
    while current and current.left:
        current = current.left
    return current

def delete_node(root: TreeNode, key: int) -> TreeNode:
    if not root:
        return None

    if key < root.val:
        root.left = delete_node(root.left, key)
    elif key > root.val:
        root.right = delete_node(root.right, key)
    else: # key == root.val, this is the node to be deleted
        # Case 1 & 2: Node with 0 or 1 child
        if not root.left:
            return root.right
        elif not root.right:
            return root.left

        # Case 3: Node with two children
        # Find the in-order successor (smallest in the right subtree)
        successor = find_min_val_node(root.right)
        # Copy the successor's content to this node
        root.val = successor.val
        # Delete the in-order successor from the right subtree
        root.right = delete_node(root.right, successor.val)

    return root
```

#### Tricks/Gotchas
- **Recursive Deletion:** The elegance of the solution for Case 3 lies in reducing the problem to a simpler case by recursively deleting the successor.

#### Related Problems
- 3. Find Min/Max in BST
- 6. Insert a given Node in Binary Search Tree

---

### 11. Construct a BST from a preorder traversal
`[MEDIUM]` `#bst` `#construction` `#preorder`

#### Problem Statement
Given an array of integers `preorder`, which represents the preorder traversal of a BST, construct the tree and return its root.

*Example:*
- **Input:** `preorder = [8, 5, 1, 7, 10, 12]`
- **Output:** The root of the BST: `[8,5,10,1,7,null,12]`

#### Implementation Overview
The first element in a preorder traversal is always the root of the tree/subtree. The subsequent elements are then split into the left subtree (all values smaller than the root) and the right subtree (all values larger than the root).
A naive O(N^2) solution involves inserting each element into a BST one by one. The optimal O(N) solution uses bounds to place each node correctly.

1.  We use a global index `i` to keep track of the current element in the `preorder` array.
2.  We define a recursive helper function `build(lower_bound, upper_bound)`.
3.  The `root` of the current `build` call is `preorder[i]`. We must check if this value is within the `(lower_bound, upper_bound)` range. If not, we can't place it here, so we return `null`.
4.  If the value is valid, create a new `TreeNode`. Increment the global index `i`.
5.  Recursively build the left subtree. The new bounds for the left child are `(lower_bound, node.val)`.
6.  Recursively build the right subtree. The new bounds for the right child are `(node.val, upper_bound)`.
7.  The initial call is `build(float('-inf'), float('inf'))`.

#### Python Code Snippet
```python
class Solution:
    def bstFromPreorder(self, preorder: list[int]) -> TreeNode:
        self.i = 0

        def build(lower_bound, upper_bound):
            if self.i >= len(preorder):
                return None

            val = preorder[self.i]
            # Check if the current value is within the valid range for this position
            if not (lower_bound < val < upper_bound):
                return None

            # This value is the root of the current subtree
            self.i += 1
            node = TreeNode(val)

            # The left child's upper bound is the current node's value
            node.left = build(lower_bound, val)
            # The right child's lower bound is the current node's value
            node.right = build(val, upper_bound)

            return node

        return build(float('-inf'), float('inf'))

```

#### Tricks/Gotchas
- **State Management:** The key to the O(N) solution is managing the state efficiently. Using a global index for the `preorder` array and passing `min/max` bounds recursively avoids re-scanning the array.

#### Related Problems
- 9. Check if a tree is a BST or BT
