# Pattern 2: Depth-First Search (DFS) Applications

Depth-First Search is a powerful graph traversal algorithm that explores as far as possible along each branch before backtracking. Its recursive nature makes it particularly well-suited for a variety of problems involving connectivity, path-finding, and cycle detection. This pattern covers common problems that are naturally solved using DFS.

---

### 1. Number of Provinces / Connected Components in Matrix
`[MEDIUM]` `#dfs` `#grid-traversal` `#connectivity`

#### Problem Statement
Given an `n x n` matrix `isConnected` where `isConnected[i][j] = 1` if the `i`th city and the `j`th city are directly connected, return the total number of **provinces**. A province is a group of directly or indirectly connected cities.

#### Implementation Overview
This is a classic "Connected Components" problem on a graph represented by an adjacency matrix.
1.  Create a `visited` array of size `n`.
2.  Initialize a `provinces` count to 0.
3.  Iterate through each city `i` from `0` to `n-1`.
4.  If city `i` has not been visited:
    - Increment `provinces` count (we've found a new component).
    - Start a DFS traversal from city `i`. The DFS will explore all connected cities, marking them as visited.
5.  The final `provinces` count is the answer.

#### Python Code Snippet
```python
def findCircleNum(isConnected):
    n = len(isConnected)
    visited = [False] * n
    provinces = 0

    def dfs(city):
        visited[city] = True
        for neighbor in range(n):
            if isConnected[city][neighbor] == 1 and not visited[neighbor]:
                dfs(neighbor)

    for i in range(n):
        if not visited[i]:
            provinces += 1
            dfs(i)

    return provinces
```

---

### 2. Flood Fill
`[EASY]` `#dfs` `#grid-traversal`

#### Problem Statement
Given an `m x n` grid `image`, a starting pixel `(sr, sc)`, and a `newColor`, "flood fill" the image by changing the color of the starting pixel and all connected pixels of the same color to the `newColor`.

#### Implementation Overview
This is a direct application of DFS on a grid.
1.  Store the `startColor` of the pixel `image[sr][sc]`. If `startColor` is already `newColor`, do nothing.
2.  Start a DFS from `(sr, sc)`.
3.  The DFS function `dfs(r, c)` will:
    - Check for boundary conditions and if the current pixel has the `startColor`.
    - If valid, change the pixel's color to `newColor` to mark it as visited and prevent re-processing.
    - Recursively call DFS for its 4-directional neighbors.

---

### 3. Surrounded Regions (O's and X's)
`[MEDIUM]` `#dfs` `#grid-traversal`

#### Problem Statement
Given an `m x n` matrix `board` containing `'X'` and `'O'`, capture all regions of `'O'`s that are surrounded by `'X'`s. An `'O'` is *not* surrounded if it is on the border or connected to an `'O'` on the border.

#### Implementation Overview
The trick is to find the `'O'`s that should *not* be captured.
1.  Any `'O'` on the border, and any `'O'` connected to a border `'O'`, cannot be captured.
2.  Iterate through the four borders. If you find an `'O'`, start a DFS from there.
3.  This DFS finds all connected `'O'`s and marks them with a temporary character (e.g., `'E'` for "escaped").
4.  After checking all borders, iterate through the entire grid:
    - If a cell is `'O'`, it's surrounded. Flip it to `'X'`.
    - If a cell is `'E'`, it's un-surrounded. Flip it back to `'O'`.

---

### 4. Number of Distinct Islands
`[MEDIUM]` `#dfs` `#grid-traversal` `#hash-set`

#### Problem Statement
Given a binary matrix `grid`, return the number of *distinct* islands. Two islands are distinct if their shapes are different.

#### Implementation Overview
We need a canonical representation ("signature") for each island's shape.
1.  Create a `set` to store the signatures.
2.  Iterate through the grid. When you find an unvisited `1`:
    - Start a DFS from this cell `(r0, c0)`.
    - The DFS function will record the path taken relative to the starting cell. For example, `dfs(r, c)` records a path by appending directions ('U', 'D', 'L', 'R') for each recursive call.
    - `dfs(r, c, current_path)`: append direction, then call `dfs(neighbor_r, neighbor_c, new_path)`.
3.  After an island is traversed, add the resulting path string (the signature) to the set.
4.  The final answer is the size of the set.

---

### 5. Cycle Detection in Undirected Graph (DFS)
`[MEDIUM]` `#dfs` `#cycle-detection`

#### Implementation Overview
For an undirected graph, a cycle exists if a DFS traversal encounters a visited node that is not its immediate parent.
1.  The DFS function takes the current `node` and its `parent`. `dfs(node, parent)`.
2.  Mark `node` as visited.
3.  For each `neighbor` of `node`:
    - If `neighbor` is not visited, recursively call `dfs(neighbor, node)`. If it returns `true`, a cycle was found.
    - If `neighbor` *is* visited, but it is *not* the `parent`, we have found a back edge. This indicates a cycle. Return `true`.
4.  If the loop finishes, no cycle was found from this path.

---

### 6. Bipartite Graph (DFS)
`[MEDIUM]` `#dfs` `#graph-coloring`

#### Problem Statement
Determine if a graph is **bipartite** (can be colored with two colors so that no two adjacent nodes have the same color).

#### Implementation Overview
1.  Create a `color` array, initialized to -1 (no color).
2.  Iterate through all vertices. If a vertex is uncolored, start a DFS.
3.  `dfs(node, c)`:
    - Color `node` with color `c`.
    - For each `neighbor`:
        - If `neighbor` is uncolored, recursively call `dfs(neighbor, 1 - c)`. If this returns `false`, propagate the failure.
        - If `neighbor` *is* colored and its color is the *same* as `c`, there is a conflict. Return `false`.
4.  If the DFS completes without conflict, return `true`.

---

### 7. Cycle Detection in Directed Graph (DFS)
`[MEDIUM]` `#dfs` `#cycle-detection`

#### Implementation Overview
For a directed graph, we must track nodes in the *current recursion path*.
1.  Use two boolean arrays: `visited` (global) and `recursionStack` (or `pathVisited`).
2.  `dfs(node)`:
    - Mark `node` as `visited` and `recursionStack` as `true`.
    - For each `neighbor`:
        - If `neighbor` is not `visited`, recursively call `dfs(neighbor)`. If it returns `true`, propagate `true`.
        - If `neighbor` *is* in the `recursionStack`, we have found a back edge to a node in the current path. This is a cycle. Return `true`.
3.  Before returning, mark `recursionStack` for `node` as `false` (backtracking).
4.  Return `false` if no cycles are found from this path.
