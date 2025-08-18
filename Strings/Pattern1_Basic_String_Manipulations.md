---

### 1. Reverse Words in a String
`[EASY]` `#string` `#two-pointers` `#reversal`

#### Problem Statement
Given an input string `s`, reverse the order of the words. A word is defined as a sequence of non-space characters. The words in `s` will be separated by at least one space. The returned string should only have a single space separating words and should not have leading or trailing spaces.

*Also covers Palindrome Check, as reversing a string is a key part of checking for palindromes.*

#### Implementation Overview
A common approach is to split the string into words, reverse the list of words, and then join them back together.

1.  **Trim and Split**: Remove any leading/trailing whitespace from the input string and then split it into a list of words using spaces as delimiters. Most languages have built-in functions that handle multiple spaces between words automatically during the split.
2.  **Reverse**: Reverse the resulting list of words.
3.  **Join**: Join the words in the reversed list back into a single string, with a single space between each word.

For a **Palindrome Check**, you would compare the original string (after cleaning it of non-alphanumeric characters and converting to lowercase) with its reversed version.

#### Python Code Snippet
```python
def reverse_words(s: str) -> str:
    """
    Reverses the order of words in a string.
    """
    # 1. Split the string into words, handling multiple spaces
    words = s.split()

    # 2. Reverse the list of words
    reversed_words = words[::-1]

    # 3. Join them back with a single space
    return " ".join(reversed_words)

def is_palindrome(s: str) -> bool:
    """
    Checks if a string is a palindrome after cleaning.
    """
    # Clean the string: keep only alphanumeric chars and convert to lowercase
    cleaned_s = "".join(filter(str.isalnum, s)).lower()
    # Check if the cleaned string is equal to its reverse
    return cleaned_s == cleaned_s[::-1]
```

#### Tricks/Gotchas
- **Whitespace**: Be mindful of leading, trailing, and multiple spaces between words. Using built-in `split()` and `join()` methods usually handles this gracefully.
- **In-place Reversal**: A more complex, in-place approach involves reversing the entire string first, and then reversing each word individually. This is an O(1) space solution.

#### Related Problems
- Rotate a LL
- check whether one string is a rotation of another

---

### 2. Check if one string is a rotation of another
`[MEDIUM]` `#string` `#concatenation`

#### Problem Statement
Given two strings, `s1` and `s2`, return `true` if `s2` is a rotation of `s1`, and `false` otherwise. For example, `"waterbottle"` is a rotation of `"erbottlewat"`.

#### Implementation Overview
This problem has a famously clever and simple solution.
1.  **Length Check**: If the lengths of `s1` and `s2` are not equal, it's impossible for `s2` to be a rotation of `s1`. Return `false`.
2.  **Concatenation**: Create a new string `s3` by concatenating `s1` with itself (`s1 + s1`).
3.  **Substring Check**: If `s2` is a rotation of `s1`, then `s2` must be a substring of `s3`. Check if `s2` exists within `s3`.

For example, if `s1 = "waterbottle"` and `s2 = "erbottlewat"`:
- `s3 = "waterbottlewaterbottle"`
- `s2` is clearly a substring of `s3`.

#### Python Code Snippet
```python
def is_rotation(s1: str, s2: str) -> bool:
    """
    Checks if s2 is a rotation of s1.
    """
    # 1. Check if lengths are equal and non-zero
    if len(s1) != len(s2) or not s1:
        return False

    # 2. Concatenate s1 with itself
    s1s1 = s1 + s1

    # 3. Check if s2 is a substring of the concatenated string
    return s2 in s1s1
```

#### Tricks/Gotchas
- **Empty Strings**: The logic should handle empty strings as a valid case if the problem defines it as such. The provided snippet returns `False` for empty strings.
- **Efficiency**: This approach is efficient, relying on optimized built-in substring search algorithms.

#### Related Problems
- Reverse words in a given string

---

### 3. Largest Odd Number in String
`[EASY]` `#string` `#greedy`

#### Problem Statement
You are given a string `num`, representing a large integer. Return the largest-valued odd integer (as a string) that is a non-empty substring of `num`, or an empty string `""` if no odd integer exists.

#### Implementation Overview
A greedy approach is the most effective here. The largest odd number will always be a prefix of the original number that ends in the last odd digit.
1.  **Iterate from the End**: Traverse the string `num` from right to left.
2.  **Find First Odd Digit**: The first digit you encounter that is odd (i.e., '1', '3', '5', '7', '9') will be the last digit of the largest possible odd number substring.
3.  **Return the Prefix**: Once you find the first odd digit from the right at index `i`, the substring from the beginning of the string up to and including that digit (`num[0...i]`) is the answer.
4.  **No Odd Digits**: If you traverse the entire string and find no odd digits, it means no odd number can be formed. Return `""`.

#### Python Code Snippet
```python
def largest_odd_number(num: str) -> str:
    """
    Finds the largest odd number that is a substring of num.
    """
    for i in range(len(num) - 1, -1, -1):
        # Check if the digit is odd
        if int(num[i]) % 2 != 0:
            # If it is, the substring from the start to this digit is the answer
            return num[:i+1]

    # If no odd digit is found
    return ""
```

#### Tricks/Gotchas
- **String to Integer Conversion**: Remember to convert the character digit to an integer before checking if it's odd.
- **Greedy Choice**: The greedy choice of finding the rightmost odd digit works because any longer substring ending in an earlier odd digit would be a smaller number (since we want the longest possible prefix).

#### Related Problems
- (Relatively simple and unique)

---

### 4. Reverse Every Word in A String
`[EASY]` `#string` `#reversal`

#### Problem Statement
Given a string `s`, reverse each word in the string. The order of the words and the whitespace should be preserved.

Example: `s = "Let's take LeetCode contest"` becomes `s = "s'teL ekat edoCteeL tsetnoc"`.

#### Implementation Overview
This is a direct application of string manipulation.
1.  **Split the String**: Split the input string `s` into a list of words. The delimiter should be a space.
2.  **Reverse Each Word**: Iterate through the list of words. For each word, reverse it. A simple way to do this in Python is with slicing `word[::-1]`.
3.  **Join the Words**: Join the list of reversed words back into a single string, using a space as the separator.

#### Python Code Snippet
```python
def reverse_each_word(s: str) -> str:
    """
    Reverses each word in a string while preserving word order.
    """
    # 1. Split the string into words
    words = s.split(' ')

    # 2. Reverse each word
    reversed_words = [word[::-1] for word in words]

    # 3. Join them back with spaces
    return " ".join(reversed_words)
```

#### Tricks/Gotchas
- **`split(' ')` vs `split()`**: Using `split(' ')` preserves multiple spaces (they become empty strings in the list), whereas `split()` (with no arguments) intelligently handles multiple spaces and collapses them. For this problem, preserving whitespace might be important, so `split(' ')` is often the correct choice, though the example doesn't feature multiple spaces. The provided solution assumes single spaces.
- **Efficiency**: This approach is very efficient, typically running in O(N) time where N is the length of the string.

#### Related Problems
- Reverse words in a given string
