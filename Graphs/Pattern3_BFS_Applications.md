# Pattern 3: Breadth-First Search (BFS) Applications

Breadth-First Search explores a graph level by level, making it the perfect tool for finding the shortest path in unweighted graphs. It uses a queue to manage a "frontier" of nodes to visit. This pattern covers problems where BFS's level-order traversal is the key to an efficient solution, including multi-source and distance-finding problems.

---

### 1. Rotten Oranges
`[MEDIUM]` `#bfs` `#grid-traversal` `#multi-source-bfs`

#### Problem Statement
You are given an `m x n` grid where each cell can be `0` (empty), `1` (fresh orange), or `2` (rotten orange). Every minute, any fresh orange that is 4-directionally adjacent to a rotten orange becomes rotten. Return the minimum number of minutes that must elapse until no cell has a fresh orange. If this is impossible, return -1.

#### Implementation Overview
This is a classic multi-source BFS problem. The "levels" of the BFS correspond to minutes.
1.  Initialize a queue and add the coordinates of all initially rotten oranges (`2`).
2.  Count the total number of fresh oranges.
3.  Perform a level-order BFS. In each iteration (representing one minute), process all nodes currently in the queue.
4.  For each rotten orange dequeued, explore its 4-directional neighbors. If a neighbor is a fresh orange (`1`), turn it rotten (`2`), decrement the `fresh_oranges` count, and enqueue it.
5.  The BFS ends when the queue is empty. If `fresh_oranges` is 0, return the number of minutes elapsed. Otherwise, return -1.

#### Python Code Snippet
```python
from collections import deque

def orangesRotting(grid):
    q = deque()
    fresh_oranges = 0
    rows, cols = len(grid), len(grid[0])

    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == 1:
                fresh_oranges += 1
            elif grid[r][c] == 2:
                q.append((r, c, 0)) # (row, col, minutes)

    minutes = 0
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]

    while q:
        r, c, minutes = q.popleft()
        for dr, dc in directions:
            nr, nc = r + dr, c + dc
            if 0 <= nr < rows and 0 <= nc < cols and grid[nr][nc] == 1:
                grid[nr][nc] = 2
                fresh_oranges -= 1
                q.append((nr, nc, minutes + 1))

    return minutes if fresh_oranges == 0 else -1
```

---

### 2. 0/1 Matrix (Distance to Nearest 0)
`[MEDIUM]` `#bfs` `#grid-traversal` `#multi-source-bfs`

#### Problem Statement
Given an `m x n` binary matrix `mat`, return the distance of the nearest `0` for each cell. The distance between two adjacent cells is 1.

#### Implementation Overview
This is another multi-source BFS. We want to find the shortest distance from every cell to a `0`. We can rephrase this as finding the shortest distance from every `0` to all other cells.
1.  Initialize a `distance` matrix of the same size, with `0` for the `0`-cells and `-1` (or `infinity`) for `1`-cells to mark them as unvisited.
2.  Initialize a queue and add the coordinates of all `0`-cells.
3.  Perform a standard multi-source BFS. For each cell dequeued, explore its neighbors. If a neighbor is unvisited, update its distance and enqueue it.
4.  The final `distance` matrix is the answer.

---

### 3. Number of Enclaves
`[MEDIUM]` `#bfs` `#grid-traversal`

#### Problem Statement
You are given an `m x n` binary matrix `grid`, where `1` represents a land cell and `0` represents a water cell. An "enclave" is an island of land cells that cannot reach the boundary of the grid. Return the number of land cells in all enclaves.

#### Implementation Overview
This is the same logic as "Surrounded Regions". We find all land cells that are *not* part of an enclave and "remove" them.
1.  Find all land cells (`1`s) on the four borders of the grid.
2.  Start a multi-source BFS from all these border land cells.
3.  The BFS will visit and effectively mark all land cells that *can* reach the boundary (e.g., by changing their value from `1` to `2`).
4.  After the BFS is complete, iterate through the grid and count the number of remaining `1`s. These are the enclaved cells.

---

### 4. Cycle Detection in Undirected Graph (BFS)
`[MEDIUM]` `#bfs` `#cycle-detection`

#### Implementation Overview
We can detect a cycle using BFS and tracking parent nodes.
1.  Use a `visited` array. The queue will store pairs: `(node, parent)`.
2.  Start a BFS from an unvisited node, adding `(start_node, -1)` to the queue.
3.  While the queue is not empty:
    - Dequeue `(node, parent)`.
    - For each `neighbor` of `node`:
        - If `neighbor` is not visited, mark it as visited and enqueue `(neighbor, node)`.
        - If `neighbor` *is* visited, but it is *not* the `parent`, we have found an edge to an already visited node that is not the one we just came from. This forms a cycle. Return `true`.
4.  If the BFS for a component completes, continue to the next. If all are processed, return `false`.

---

### 5. Bipartite Graph (BFS)
`[MEDIUM]` `#bfs` `#graph-coloring`

#### Problem Statement
Determine if a graph is **bipartite**.

#### Implementation Overview
Using BFS for two-coloring:
1.  Create a `color` array, initialized to -1 (no color).
2.  Iterate through all vertices. If a vertex `i` is uncolored:
    - Start a BFS from `i`. Color `color[i] = 0` and add to queue.
    - While the queue is not empty:
        - Dequeue `node`.
        - For each `neighbor`:
            - If `neighbor` is uncolored, color it with the opposite color (`1 - color[node]`) and enqueue it.
            - If `neighbor` *is* colored and has the *same* color as `node`, there's a conflict. Return `false`.
3.  If all components are processed without conflict, return `true`.
