# Pattern 3: Disjoint Set Union (DSU) / Union-Find

**Disjoint Set Union (DSU)**, also known as **Union-Find**, is a data structure that tracks a collection of elements partitioned into a number of disjoint (non-overlapping) subsets. It is incredibly efficient for problems involving dynamic connectivity.

**Analogy**: Imagine you have a group of people, and you want to manage their social circles. You want to be able to quickly:
1.  **Find**: Check which social circle a person belongs to.
2.  **Union**: Merge two social circles when two people from different circles become friends.

DSU is the perfect tool for this. It provides two main operations:
- **`find(i)`**: Returns an identifier for the set containing element `i`. This lets us check if two elements are in the same set (`find(i) == find(j)`).
- **`union(i, j)`**: Merges the sets containing elements `i` and `j`.

With optimizations, these operations are nearly constant time on average, making DSU extremely powerful.

---

### The DSU Implementation
A DSU is implemented using an array (`parent`) and two key optimizations: **Path Compression** and **Union by Size/Rank**.

- **Path Compression**: During a `find` operation, after finding the root of the set, we make every node on the path point directly to the root. This dramatically flattens the tree for future lookups.
- **Union by Size (or Rank)**: When merging two sets, we always attach the root of the smaller tree to the root of the larger tree. This keeps the trees from becoming tall and unbalanced, which would slow down `find` operations.

#### Python Code (Union by Size)
This is a standard, reusable DSU class that can be used for all the problems below.

```python
class DSU:
    """A Disjoint Set Union (DSU) data structure with Path Compression and Union by Size."""
    def __init__(self, n: int):
        # Each node is its own parent initially
        self.parent = list(range(n))
        # The size of each set is initially 1
        self.size = [1] * n
        # The number of distinct components
        self.num_components = n

    def find(self, i: int) -> int:
        """Finds the root of the set containing element i, with path compression."""
        if self.parent[i] == i:
            return i
        # Path compression: set parent to the root
        self.parent[i] = self.find(self.parent[i])
        return self.parent[i]

    def union(self, i: int, j: int) -> bool:
        """Merges the sets containing i and j, with union by size."""
        root_i = self.find(i)
        root_j = self.find(j)

        if root_i != root_j:
            # Union by size: attach smaller tree to larger tree
            if self.size[root_i] < self.size[root_j]:
                root_i, root_j = root_j, root_i  # Ensure root_i is the larger set

            self.parent[root_j] = root_i
            self.size[root_i] += self.size[root_j]
            self.num_components -= 1
            return True  # A merge was performed

        return False  # They were already in the same set
```

---

### Applications of DSU

DSU is the ideal tool for any problem that can be modeled as "grouping" or "connecting" items and then asking questions about this connectivity.

---

### 1. Number of Operations to Make Network Connected
- **Problem**: Given `n` computers and a list of `connections`, find the minimum number of new cables needed to connect all computers. If it's not possible, return -1.
- **DSU Logic**:
    - **Elements**: The computers (0 to `n-1`).
    - **Sets**: Connected networks of computers.
- **Algorithm**:
    1. Check if we have enough cables. To connect `n` nodes, you need at least `n-1` edges. If `len(connections) < n - 1`, it's impossible.
    2. Initialize a DSU for `n` computers.
    3. Iterate through existing `connections`, performing a `union` for each pair. The `union` operation will merge the networks.
    4. After processing all connections, the number of remaining sets (`dsu.num_components`) represents the number of separate networks.
    5. To connect `k` networks, you need `k-1` new cables. The answer is `dsu.num_components - 1`.

#### Python Code Snippet
```python
def make_network_connected(n: int, connections: list[list[int]]) -> int:
    if len(connections) < n - 1:
        return -1

    dsu = DSU(n)
    for u, v in connections:
        dsu.union(u, v)

    return dsu.num_components - 1
```

---

### 2. Accounts Merge
- **Problem**: Given user accounts, each with a name and a list of emails, merge accounts that share at least one common email.
- **DSU Logic**:
    - **Elements**: The accounts (indexed 0 to `n-1`).
    - **Sets**: Groups of merged accounts.
- **Algorithm**:
    1. Initialize a DSU for `n` accounts.
    2. Create a hash map `email_to_account_id` to link an email to the first account index that owned it.
    3. **First Pass (Union)**: Iterate through the accounts. For each email in an account:
        - If the email is already in our map, `union` the current account index with the account index stored in the map.
        - If not, map the email to the current account index.
    4. **Second Pass (Group)**: Create a new map `merged_emails` where keys are the root parent of each account group (`dsu.find(i)`), and values are lists of emails.
    5. Iterate through the original accounts again, adding each email to the list corresponding to its account's final root parent.
    6. Format the output by sorting the email lists and prepending the user name.

#### Python Code Snippet
```python
import collections

def accounts_merge(accounts: list[list[str]]) -> list[list[str]]:
    dsu = DSU(len(accounts))
    email_to_account_id = {}

    for i, account in enumerate(accounts):
        for email in account[1:]:
            if email in email_to_account_id:
                dsu.union(i, email_to_account_id[email])
            else:
                email_to_account_id[email] = i

    merged_emails = collections.defaultdict(list)
    for email, account_id in email_to_account_id.items():
        root = dsu.find(account_id)
        merged_emails[root].append(email)

    result = []
    for account_id, emails in merged_emails.items():
        name = accounts[account_id][0]
        result.append([name] + sorted(emails))

    return result
```

---

### 3. Making A Large Island
- **Problem**: In a grid of `0`s and `1`s, you can change at most one `0` to a `1`. Find the size of the largest island you can form.
- **DSU Logic**:
    - **Elements**: Grid cells, mapped from 2D `(r, c)` to 1D `r * cols + c`.
    - **Sets**: Connected islands of `1`s.
- **Algorithm**:
    1. **First Pass (Build Islands)**:
        - Initialize a DSU for `rows * cols` cells.
        - Iterate through the grid. If a cell `(r, c)` is a `1`, `union` it with any of its neighboring cells that are also `1`s.
        - After this pass, the DSU `size` array will hold the size of each island, accessible via its root parent.
    2. **Second Pass (Test Flipping Zeros)**:
        - Initialize `max_size` to the size of the largest existing island.
        - Iterate through the grid again. If a cell `(r, c)` is a `0`:
            - Find its unique neighboring island components. Use a set to store the root parents of its neighbors to avoid double-counting.
            - Calculate the potential new size: `1` (for the flipped `0`) + sum of the sizes of the unique neighboring components.
            - Update `max_size` with this potential new size.
    3. Return `max_size`.

#### Python Code Snippet
```python
def largest_island(grid: list[list[int]]) -> int:
    n = len(grid)
    dsu = DSU(n * n)

    # 1. First pass: Build initial islands
    for r in range(n):
        for c in range(n):
            if grid[r][c] == 1:
                for dr, dc in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
                    nr, nc = r + dr, c + dc
                    if 0 <= nr < n and 0 <= nc < n and grid[nr][nc] == 1:
                        dsu.union(r * n + c, nr * n + nc)

    max_size = max(dsu.size) if dsu.size else 0

    # 2. Second pass: Check every 0
    for r in range(n):
        for c in range(n):
            if grid[r][c] == 0:
                neighbor_roots = set()
                for dr, dc in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
                    nr, nc = r + dr, c + dc
                    if 0 <= nr < n and 0 <= nc < n and grid[nr][nc] == 1:
                        neighbor_roots.add(dsu.find(nr * n + nc))

                current_size = 1
                for root in neighbor_roots:
                    current_size += dsu.size[root]
                max_size = max(max_size, current_size)

    return max_size if max_size > 0 else n * n
```
