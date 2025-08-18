# Pattern 3: Disjoint Set Union (DSU)

Disjoint Set Union (DSU), also known as Union-Find, is a data structure that keeps track of a set of elements partitioned into a number of disjoint (non-overlapping) subsets. It provides two primary operations:
- **`find(i)`**: Determines which subset an element `i` is in. This can be used for determining if two elements are in the same subset.
- **`union(i, j)`**: Joins the two subsets that contain elements `i` and `j` into a single subset.

DSU is highly efficient, with nearly constant-time operations on average when implemented with two key optimizations: **Path Compression** and **Union by Rank/Size**. It's the perfect tool for problems involving dynamic connectivity and partitioning.

---

### 1. DSU Implementation (Union by Rank/Size & Path Compression)
`[HARD]` `#dsu` `#union-find`

#### Implementation Overview
A DSU is typically implemented with an array, `parent`, where `parent[i]` stores the parent of element `i`. The root of a set has itself as its parent.

- **`find(i)` with Path Compression**: To find the root of `i`, we traverse up the parent pointers. Path compression optimizes this by making every node on the find path point directly to the root. This flattens the tree structure for future lookups.
  ```python
  def find(i):
      if parent[i] == i:
          return i
      parent[i] = find(parent[i]) # Path compression
      return parent[i]
  ```

- **`union(i, j)` by Rank or Size**: When merging two sets, a naive approach can lead to tall, skinny trees, making `find` operations slow. We use a heuristic to keep the trees balanced.
  - **Union by Rank**: The rank is an upper bound on the tree's height. Always attach the root of the shorter tree to the root of the taller tree.
  - **Union by Size**: Track the size of each set. Always attach the root of the smaller tree to the root of the larger tree. This is often simpler and just as effective.

#### Python Code Snippet (Union by Size)
```python
class DSU:
    def __init__(self, n):
        self.parent = list(range(n))
        self.size = [1] * n

    def find(self, i):
        if self.parent[i] == i:
            return i
        self.parent[i] = self.find(self.parent[i])
        return self.parent[i]

    def union(self, i, j):
        root_i = self.find(i)
        root_j = self.find(j)
        if root_i != root_j:
            # Union by size
            if self.size[root_i] < self.size[root_j]:
                root_i, root_j = root_j, root_i # Ensure root_i is larger
            self.parent[root_j] = root_i
            self.size[root_i] += self.size[root_j]
            return True # Union was performed
        return False # Already in the same set
```

---

### 2. Applications of DSU

#### Number of Operations to Make Network Connected
- **Problem**: Given `n` computers and a list of connections, find the minimum number of new cables needed to connect all computers.
- **DSU Solution**: Each computer is an element in the DSU. Process each existing connection `(u, v)` with a `union(u, v)`. The number of connected components is the number of sets whose root is their own parent. If we have `k` components, we need `k-1` cables to connect them. We also need to ensure we have enough existing cables (`len(connections) >= n - 1`).

#### Accounts Merge
- **Problem**: Given accounts with a name and a list of emails, merge accounts that share a common email.
- **DSU Solution**: Create a DSU with `n` elements (for `n` accounts). Use a map from each email to the index of the account it belongs to. Iterate through accounts; for each email, `union` the current account index with the index of the account that first owned that email. After all unions, group emails by their final root parent.

#### Most Stones Removed with Same Rows or Columns
- **Problem**: On a 2D plane, you can remove a stone if it shares a row or column with another stone. What is the largest number of stones you can remove?
- **DSU Solution**: All stones in a "connected component" can be removed except one. The problem becomes finding `total_stones - num_components`. A component is a set of stones connected by sharing rows or columns. The trick is to union stones based on rows and columns. A common mapping is to have DSU elements `0..10000` for rows and `10001..20001` for columns. For a stone at `(r, c)`, `union(r, c + 10001)`.

#### Number of Islands II
- **Problem**: Given an empty grid and a list of positions where land will be added, report the number of islands after each addition.
- **DSU Solution**: A DSU is perfect for this dynamic problem.
  - DSU elements represent grid cells, mapped from 2D to 1D (`r * cols + c`).
  - When a `1` is added at `(r, c)`, initially increment the island count.
  - Check its four neighbors. If a neighbor is also a `1`, perform a `union`. If the `union` merges two different components, decrement the island count.

#### Making a Large Island
- **Problem**: In a grid of `0`s and `1`s, you can change at most one `0` to a `1`. What is the size of the largest island you can form?
- **DSU Solution**:
  1.  **First Pass**: Iterate through the grid. For every `1`, perform DSU `union` with its adjacent `1`s to form the initial islands. The DSU's `size` array now stores the size of each component.
  2.  **Second Pass**: Iterate through the grid again. For every `0`:
     - Consider changing this `0` to a `1`. This could merge up to four neighboring islands.
     - Find the distinct neighboring components (by their roots).
     - The potential new island size is `1` (for the new `1`) plus the sum of the sizes of these distinct neighboring components. Keep track of the maximum size found.
