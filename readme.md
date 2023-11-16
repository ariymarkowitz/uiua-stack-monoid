# stackmonoid.ua

This is an implementation of a stack monoid for the programming language [Uiua](https://www.uiua.org).

A stack monoid is a data structure consisting of a series of 'pushes' and 'pops'.
A stack monoid is not itself a stack - rather, it is a sequence of operations
to apply to a stack.

In this implementation, a stack monoid is represented by an array of boxed pairs
`[□a, □b]`, where `a` is a Boolean value equal to 1 if the entry is a push, and `b` is
the value associated to the push or pop.

Each entry of a stack monoid has an associated depth - a push increases the depth,
while a pop decreases the depth. By convention, the first element has depth 0.

A forest is a stack monoid in which every push has an associated pop.

A tree is a forest in which the last element pops the first element.
The stack monoid of a tree graph corresponds to an Euler walk, which is a walk
that visits every vertex exactly once.
To see the connection between stack monoids and trees, note that a collection of
brackets (like '(()())()(())') is a representation of a stack monoid, where each
left bracket is a push and each right bracket is a pop.

A leaf is a 'push' that is followed by a 'pop'. This corresponds to a leaf in a tree graph.

## Monadic Functions

### `IsPush`
Test if an element is a push.
`≡IsPush` gets a Boolean mask of pushes in a stack monoid.

### `Value`
Get the value of an element.
`≡Value` gets all of the values in a stack monoid.
Because the pop values are usually empty, you probably want to use
`≡Value▽≡IsPush.`

### `Leaves`
Get a boolean mask of the leaves of a stack monoid.

### `Depths`
Get a list of depths of a stack monoid.
The first element has depth 0. Every push increments the depth, and every pop
decrements the depth.
In a forest, all pushes have depth >= 0, and all pops have depth >= -1.
In a tree, the last element (and only the last element) is a pop with depth -1.

### `Pairs`
Get the list of indices of push and pop pairs.

### `Tree`
Get the subtree containing the first element.
`Tree Grow!⇡ [3 2]` is equal to `Tree Grow!⇡ [3]`.
The subforest corresponding to the string of brackets `(())()(` is `(())`, which
is the substring enclosed by the initial opening bracket.

### `Forest`
Get the largest subforest containing the first element.
The subforest corresponding to the string of brackets `(())()(` is `(())()`, which
is the largest substring in which all brackets are matched.

## Dyadic functions

### `Closure`
Get the pop matching the push at the given index.

## Monadic modifiers

### `Grow!`
Recusively grow a forest.
The input function takes a stack value and returns an array of child stack values.
An initial array of values is required.
Example: `Grow!⇡ [3 2]` outputs a stack monoid with two roots of values 3 and 2, and the children of an element with
value n is every integer in the range [0 ... n-1].


### `Flow!`
Reduce along every path, keeping intermediate values in a stack monoid. The input function takes 2 arguments, with
the accumulated value first. The modifier also requires an initial value.
Example: `Flow!+ 0` gives the cumulative sum of every element of a stack monoid.

### `Collect!`
Reduce along every path, returning the leaf values in an array. The input function takes 2 arguments, with
the accumulated value first. The modifier also requires an initial value.

## Examples

### Get all subsets of [0 ... n-1]
```
Subsets ← ⊐≡Value▽≡IsPush. Flow!⊂[] Grow!⇡ ⇡
Subsets 4
```

### Find the unmatched open brace
```
Braces ← "()(()())(()()"
⧻Forest ∵[□∘] ⊗∶")(" Braces
Alternative solutions:
⊢⇌⊚⌕¯1 Depths ∵[□∘] ⊗∶")(" Braces
⊢⊚¬⍘⊚♭Pairs ∵[□∘] ⊗∶")(" Braces
```
