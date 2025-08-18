# Pattern 3: Heaps for Greedy Algorithms & Merging

This pattern explores two powerful applications of heaps: as a core component in greedy algorithms and as the primary tool for K-way merging. In greedy problems, a heap helps in efficiently selecting the best local choice at each step. In merging, a heap keeps track of the smallest (or largest) items from multiple sorted sources.

---

### 1. Connect n ropes with minimal cost
`[MEDIUM]` `#greedy` `#min-heap`

#### Problem Statement
You are given `n` ropes of different lengths. The cost to connect two ropes is equal to their sum. Your task is to connect the ropes into a single rope with the minimum possible cost.

#### Implementation Overview
This is a classic greedy problem. To minimize the total cost, you should always connect the two shortest available ropes at each step. A **Min-Heap** is the perfect data structure for this.
1.  Add all rope lengths to a min-heap.
2.  Loop until only one rope (the final combined rope) remains in the heap:
    a. Extract the two smallest ropes from the heap (`rope1`, `rope2`).
    b. Calculate the cost to connect them (`cost = rope1 + rope2`). Add this to the total cost.
    c. Add the new, combined rope length (`cost`) back into the min-heap.
3.  The accumulated total cost is the minimum possible cost.

By always combining the two shortest ropes, we ensure that smaller lengths are added together earlier, contributing less to the cumulative sums in later stages.

---

### 2. Task Scheduler
`[MEDIUM]` `#greedy` `#max-heap` `#frequency`

#### Problem Statement
Given a list of tasks and a non-negative integer `n` representing the cooldown period between two same tasks, find the least number of CPU intervals required to complete all tasks.

#### Implementation Overview
The greedy strategy is to execute the most frequent task first. A **Max-Heap** can be used to keep track of the frequencies of tasks.
1.  Count the frequency of each task using a hash map.
2.  Push all frequencies into a max-heap (a min-heap with negated values in Python).
3.  The main loop processes tasks in chunks of size `n+1`. In each chunk:
    a. Pop up to `n+1` tasks from the max-heap (or until the heap is empty). Store them in a temporary list.
    b. Decrement the frequency of these tasks.
    c. Add the number of tasks processed in this chunk to the total time.
    d. Push the tasks with remaining frequency > 0 back onto the max-heap.
4.  If the heap becomes empty, but we processed fewer than `n+1` tasks in the last chunk, we don't need to add the full `n+1` idle slots. The total time is the final answer.

---

### 3. Hands of Straights
`[MEDIUM]` `#greedy` `#hashmap`

#### Problem Statement
Given an array of integers `hand` and an integer `groupSize`, return `true` if the `hand` can be rearranged into groups of `groupSize` consecutive cards.

#### Implementation Overview
A greedy approach works here. We should always try to form a sequence starting with the smallest available card. A Min-Heap helps fetch the smallest card efficiently.
1.  First, check if the hand size is divisible by `groupSize`. If not, return `false`.
2.  Count the frequencies of each card using a hash map.
3.  Push all unique card numbers into a min-heap.
4.  Loop while the min-heap is not empty:
    a. Pop the smallest card (`start_card`) from the heap. This will be the start of a new potential group.
    b. If this card's count in the hash map is zero (it was used up by a previous group), continue.
    c. For `groupSize` cards starting from `start_card`, check if each consecutive card exists in the hash map with a positive count.
    d. If any card is missing, it's impossible to form the sequence, so return `false`.
    e. If the sequence is valid, decrement the count of each card in the hash map.
5.  If the loop completes, all cards have been successfully grouped. Return `true`.

---

### 4. Sort K Sorted Array / Merge M Sorted Lists
`[EASY]` `#k-way-merge` `#min-heap`

#### Problem Statement
You are given `k` sorted arrays (or lists). Merge them into a single sorted array.

#### Implementation Overview
This is the canonical **K-way Merge** problem. A Min-Heap is used to efficiently track the smallest element across all `k` arrays.
1.  Initialize a min-heap.
2.  Push the first element from each of the `k` arrays onto the heap. Store it as a tuple: `(value, array_index, element_index)`.
3.  Initialize an empty result array.
4.  While the heap is not empty:
    a. Pop the smallest element tuple `(val, arr_idx, elem_idx)` from the heap.
    b. Add `val` to the result array.
    c. Check if the array from which `val` came has more elements.
    d. If it does, push the next element `(next_val, arr_idx, elem_idx + 1)` from that array onto the heap.
5.  The result array is the final merged and sorted list.

This approach has a time complexity of O(N log K), where N is the total number of elements and K is the number of arrays.

---

### 5. Design Twitter
`[MEDIUM]` `#system-design` `#k-way-merge` `#max-heap`

#### Problem Statement
Design a simplified version of Twitter where users can post tweets, follow/unfollow other users, and see the 10 most recent tweets in their news feed. The news feed should include their own tweets.

#### Implementation Overview
The most complex part is `getNewsFeed(userId)`. This is a K-way merge problem. A user's news feed is a merge of their own recent tweets and the recent tweets of everyone they follow, sorted by time.
-   **Data Structures:**
    -   `user_tweets`: A map from `userId` to a list of their `(timestamp, tweetId)`s.
    -   `user_follows`: A map from `userId` to a set of `userId`s they follow.
-   **`getNewsFeed(userId)` Logic:**
    1.  Get the list of users to fetch tweets from (the user themselves and everyone they follow).
    2.  Use a **Max-Heap** to find the 10 most recent tweets. For each user in the list, get their most recent tweet.
    3.  Push tuples `(timestamp, tweetId, user_id, tweet_index_in_user_list)` for the latest tweet from each followed user onto the max-heap.
    4.  Loop 10 times (or until the heap is empty):
        a. Pop the tweet with the max timestamp from the heap. Add it to the result.
        b. From the user whose tweet was just popped, get their next most recent tweet and push it onto the heap.

This is effectively merging K sorted lists (the tweet lists of each user) to find the top 10 overall.
