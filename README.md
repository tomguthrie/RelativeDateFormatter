# RelativeDateFormatter

Mail.app style relative date formatter.

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
`NSDateFormatter` they are expensive to initialize.

### Swift

```swift
let date = ...
let formatter = RelativeDateFormatter()
let relativeString = formatter.stringForDate(date)
```

### Objective-C

```objective-c
NSDate *date = ...;
TFGRelativeDateFormatter *formatter = [[TFGRelativeDateFormatter alloc] init];
NSString *relativeString = [formatter stringForDate:date];
```

## Contact

[Thomas Guthrie](https://github.com/tomguthrie)
[@tomguthrie](https://twitter.com/tomguthrie)

## License

RelativeDateFormatter is released under the [MIT License](LICENSE.md).
