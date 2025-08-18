---

### 1. Isomorphic Strings
`[EASY]` `#string` `#hashmap` `#mapping`

#### Problem Statement
Given two strings `s` and `t`, determine if they are isomorphic. Two strings `s` and `t` are isomorphic if the characters in `s` can be replaced to get `t`. All occurrences of a character must be replaced with another character while preserving the order of characters. No two characters may map to the same character, but a character may map to itself.

Example: `s = "egg"`, `t = "add"` are isomorphic. `s = "foo"`, `t = "bar"` are not.

#### Implementation Overview
The core of this problem is to track the character mappings from `s` to `t`. A hash map is perfect for this.
1.  **Length Check**: If the strings have different lengths, they cannot be isomorphic.
2.  **Initialize Mappings**: Create two hash maps:
    -   `s_to_t_map`: To store mappings from characters in `s` to characters in `t`.
    -   `t_to_s_map`: To ensure that no two characters from `s` map to the same character in `t`.
3.  **Iterate and Check Mappings**: Traverse both strings from left to right using an index `i`.
    -   Let `char_s = s[i]` and `char_t = t[i]`.
    -   **Check `s -> t` mapping**:
        -   If `char_s` is already in `s_to_t_map`, check if its mapping is `char_t`. If not, they are not isomorphic.
        -   If `char_s` is not in the map, this is a new mapping.
    -   **Check `t -> s` mapping**:
        -   If `char_t` is already in `t_to_s_map`, check if its mapping is `char_s`. If not, it means a different character from `s` already maps to `char_t`, which is invalid.
    -   **Create New Mapping**: If all checks pass for a new pair, add the mapping to both maps: `s_to_t_map[char_s] = char_t` and `t_to_s_map[char_t] = char_s`.
4.  If the loop completes without returning `false`, the strings are isomorphic.

#### Python Code Snippet
```python
def is_isomorphic(s: str, t: str) -> bool:
    """
    Determines if two strings are isomorphic.
    """
    if len(s) != len(t):
        return False

    s_to_t_map = {}
    t_to_s_map = {}

    for char_s, char_t in zip(s, t):
        # Check forward and backward mappings
        if (char_s in s_to_t_map and s_to_t_map[char_s] != char_t) or \
           (char_t in t_to_s_map and t_to_s_map[char_t] != char_s):
            return False

        # Create the mapping
        s_to_t_map[char_s] = char_t
        t_to_s_map[char_t] = char_s

    return True
```

#### Tricks/Gotchas
- **Bidirectional Mapping**: It's not enough to just check the `s -> t` mapping. You must also ensure a character in `t` is not mapped to by multiple characters in `s`. Using a second map (or a set of used `t` characters) is crucial for this.
- `zip()`: The `zip()` function in Python is a very clean way to iterate through two sequences in parallel.

#### Related Problems
- Check if two strings are anagram of each other

---

### 2. Check if two strings are anagram of each other
`[MEDIUM]` `[EASY]` `#string` `#hashmap` `#sorting`

#### Problem Statement
Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`, and `false` otherwise. An anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

Example: `s = "anagram"`, `t = "nagaram"` is true. `s = "rat"`, `t = "car"` is false.

#### Implementation Overview
There are two primary approaches to solve this problem.

**Method 1: Sorting**
1.  **Length Check**: If the lengths of `s` and `t` are different, they cannot be anagrams.
2.  **Sort and Compare**: Convert both strings to character arrays, sort them, and then compare the sorted arrays. If they are identical, the strings are anagrams.

**Method 2: Character Frequency Count (HashMap)**
This method is generally more efficient as sorting takes `O(N log N)`.
1.  **Length Check**: Same as above.
2.  **Count Frequencies**: Create a hash map (or an array of size 26 for lowercase English letters) to store the frequency of each character in the first string, `s`.
3.  **Decrement Frequencies**: Iterate through the second string, `t`. For each character, decrement its count in the hash map.
4.  **Check for Negatives**: If at any point a character's count in the map becomes negative (or you encounter a character not in the map), it means `t` has more of that character than `s`, so they are not anagrams.
5.  **Final Check**: After the loop, if all counts in the map are zero, the strings are anagrams.

#### Python Code Snippet (Frequency Count Method)
```python
from collections import Counter

def is_anagram(s: str, t: str) -> bool:
    """
    Checks if two strings are anagrams using a frequency counter.
    """
    if len(s) != len(t):
        return False

    # The Counter object creates a hash map of character frequencies.
    # Comparing two Counter objects checks for equality of keys and values.
    return Counter(s) == Counter(t)

# Sorting method for comparison
def is_anagram_sorting(s: str, t: str) -> bool:
    if len(s) != len(t):
        return False
    return sorted(s) == sorted(t)
```

#### Tricks/Gotchas
- **Unicode vs. ASCII**: If the strings can contain Unicode characters, a hash map is more robust than a fixed-size array for frequency counting.
- **Efficiency**: The frequency counting method is typically `O(N)` time and `O(k)` space (where `k` is the number of unique characters, or constant for ASCII), which is better than the `O(N log N)` time complexity of the sorting approach.

#### Related Problems
- Isomorphic Strings
- Group Anagrams (a more advanced version)

---

### 3. Sort Characters by Frequency
`[EASY]` `#string` `#hashmap` `#sorting` `#frequency`

#### Problem Statement
Given a string `s`, sort it in decreasing order based on the frequency of its characters. The frequency of a character is the number of times it appears in the string. If two characters have the same frequency, their relative order doesn't matter.

Example: `s = "tree"` -> `"eert"` or `"eetr"`. `s = "cccaaa"` -> `"cccaaa"` or `"aaaccc"`.

#### Implementation Overview
This problem requires counting character frequencies and then sorting based on those frequencies.

1.  **Count Frequencies**: Use a hash map (like `collections.Counter` in Python) to count the frequency of each character in the input string `s`.
2.  **Sort by Frequency**: Sort the characters based on their frequencies in descending order. A common way to do this is to get the items from the frequency map and use a custom sorting key.
3.  **Build the Result String**: Iterate through the sorted characters. For each character, append it to the result string a number of times equal to its frequency.

#### Python Code Snippet
```python
from collections import Counter

def frequency_sort(s: str) -> str:
    """
    Sorts a string in decreasing order based on character frequency.
    """
    # 1. Count character frequencies
    counts = Counter(s)

    # 2. Sort characters by frequency in descending order
    # The key for sorting is the frequency (x[1])
    sorted_chars = sorted(counts.items(), key=lambda item: item[1], reverse=True)

    # 3. Build the result string
    result = []
    for char, freq in sorted_chars:
        result.append(char * freq)

    return "".join(result)

# Alternative using a Bucket Sort-like approach (often more efficient)
def frequency_sort_bucket(s: str) -> str:
    counts = Counter(s)
    max_freq = max(counts.values(), default=0)

    # Create buckets for each frequency
    buckets = [[] for _ in range(max_freq + 1)]
    for char, freq in counts.items():
        buckets[freq].append(char)

    # Build string from buckets, from highest frequency to lowest
    result = []
    for i in range(max_freq, 0, -1):
        for char in buckets[i]:
            result.append(char * i)

    return "".join(result)
```

#### Tricks/Gotchas
- **Sorting Stability**: The problem statement says the order of characters with the same frequency doesn't matter, so a stable sort is not required.
- **Bucket Sort**: For a string of length `n`, bucket sort can be more efficient than a general-purpose sort. The time complexity is O(n) because the number of frequencies and characters is tied to `n`, avoiding the O(k log k) for sorting `k` unique characters.

#### Related Problems
- Check if two strings are anagram of each other
