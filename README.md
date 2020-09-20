# 🎁Shop

Shop is an example e-commerce app with a modern architecture and view layout implementation. It's made to showcase the following things (some of which are still in progress):

- A complex e-commerce (network client-focused) app with both SwiftUI and UIKit
- A highly dynamic and backend-driven home screen that's almost entirely customizable through the server
- Migration piecemeal from UIKit to SwiftUI
- A variety of architectures common to iOS apps with a particular focus on SwiftUI-friendly ones
- Testing with Combine and SwiftUI
- Dynamic type and other accessibility features
- Localization and formatters

## Starting the example server

I made a simple Node.js app to run on localhost so the app can use actual network requests. Follow the instructions below to get it running on your environment.

```sh
$ sudo vim /etc/hosts
# Add this: 127.0.0.1	localhost
$ npm install # Install npm and node if not installed
$ node app.js
```

## Architectures

Though by no means fully correct or complete, here are the commits where I tried out a bunch of common architectures before settling on The Composable Architecture (TCA).

- [MVVM](https://github.com/yhkaplan/Shop/tree/5d423ff86c49df825b81f03a96c4ec4e44a25047)
- [Redux](https://github.com/yhkaplan/Shop/tree/37311931bfa1f3ae02484a4f73ff1d7146c7e2aa)
    - [+ Router](https://github.com/yhkaplan/Shop/tree/184fbdeafcfb22149ed2f364483b0b94d079fbe7)
- [Composable Architecture](https://github.com/yhkaplan/Shop/tree/6274c9b6bc4af734a4ebed8dd66e27047e05be55)
- [Flux](https://github.com/yhkaplan/Shop/tree/464d386aead877bface171e4b3dc195cfeb89820)
- [VIPER](https://github.com/yhkaplan/Shop/tree/a1174f751885d781460499dda794fd22883fba7c)

## Contributing

This app is my personal playground to experiment with new APIs, but feel free to contibute!

## Inspiration

I referred to these sources for information on architecture:

<details>
<summary>Reference</summary>

### General
- https://medium.com/eureka-engineering/thought-about-arch-for-swiftui-1b0496d8094
- https://qiita.com/shiz/items/510f9095c82a0f610102
### CLEAN/VIPER
- https://nalexn.github.io/clean-architecture-swiftui/
- https://www.raywenderlich.com/8440907-getting-started-with-the-viper-architecture-pattern
- https://theswiftdev.com/how-to-build-swiftui-apps-using-viper/
### MVVM
- https://www.davidahouse.com/2020-05-25-thoughts-on-app-architecture-with-swiftui/
- https://quickbirdstudios.com/blog/swiftui-architecture-redux-mvvm/
- https://www.vadimbulavin.com/modern-mvvm-ios-app-architecture-with-combine-and-swiftui/
- https://benoitpasquier.com/swiftui-what-has-changed-in-mvvm-pattern-swift/
- [Example](https://github.com/kitasuke/SwiftUI-MVVM)
### Redux
- https://stackoverflow.com/a/32920459
- https://swiftwithmajid.com/2019/09/18/redux-like-state-container-in-swiftui/
- https://tech.mercari.com/entry/2019/12/11/150000
- https://basememara.com/building-scalable-swiftui-architecture-app/
- [Example](https://github.com/StevenLambion/SwiftDux)
- https://benoitpasquier.com/integrate-redux-in-mvvm-architecture/
- https://medium.com/commencis/using-redux-with-mvvm-on-ios-18212454d676
- [Example](https://github.com/kitasuke/SwiftUI-Redux)
### Flux
- http://blog.benjamin-encz.de/post/real-world-flux-ios/
- https://jobandtalent.engineering/ios-architecture-an-state-container-based-approach-4f1a9b00b82e
- https://github.com/bq/mini-swift
- https://swiftandpizza.com/flux-in-swift/
- https://qiita.com/tamayuru/items/3afb0bb9dac7033adef0
- [Example](https://github.com/kitasuke/SwiftUI-Flux)
- [Flux という設計思想](https://app.codegrid.net/entry/react-ex-1)
- [漫画で説明する Flux](https://medium.com/sotayamashita/%E6%BC%AB%E7%94%BB%E3%81%A7%E8%AA%AC%E6%98%8E%E3%81%99%E3%82%8B-flux-1a219e50232b)
- [React & Flux入門](https://qiita.com/sl2/items/ff7a07c00f545d245a5c)
- [iOS meets Flux](https://qiita.com/kumabook/items/808c7aab3eb4320c5776)
- [SwiftFlux](https://qiita.com/yonekawa/items/c8a53d534084850963a3)

</details>

## Credits
- [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) and [Point-Free](https://www.pointfree.co/) for their wonderful architecture framework
- [CombineExt](https://github.com/CombineCommunity/CombineExt)
- [Hacking With Swift](https://www.hackingwithswift.com/quick-start/swiftui) for about 90% of the results that turn up in Google searchs on SwiftUI

## License

Licensed under MIT license. See [LICENSE](LICENSE) for more info.
