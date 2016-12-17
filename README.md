# RelativeDateFormatter

Mail.app style relative date formatter. A reimplementation of
[TFGRelativeDateFormatter](https://github.com/tomguthrie/TFGRelativeDateFormatter)
written in Swift.

## Examples

|           | en_GB      | en_US     |
|-----------|:----------:|:---------:|
| Same Day  | 13:45      | 1:45 PM   |
| Yesterday | Yesterday  | Yesterday |
| Same Week | Monday     | Monday    |
| Same Year | 15 Mar     | Mar 15    |
| Last Year | 22/04/2013 | 4/22/13   |

## Usage

`RelativeDateFormatter` instances should be cached where possible, similar to
`DateFormatter` they are expensive to initialize.

### Swift

```swift
let date = ...
let formatter = RelativeDateFormatter()
let relativeString = formatter.string(from: date)
```

Or, for a string relative to some other date:

```swift
let date = ...
let otherDate = ...
let formatter = RelativeDateFormatter()
let relativeString = formatter.string(from: date, relativeTo: otherDate)
```

## Contact

[Thomas Guthrie](https://github.com/tomguthrie)
[@tomguthrie](https://twitter.com/tomguthrie)

## License

RelativeDateFormatter is released under the [MIT License](LICENSE).
