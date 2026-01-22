# WeSplit 🧾

*[Project 1](https://www.hackingwithswift.com/100/swiftui/16)* from the *[100 Days of SwiftUI course](https://www.hackingwithswift.com/books/ios-swiftui)* by *[Hacking With Swift](https://www.hackingwithswift.com/)*

>A clean and efficient check-splitting app designed for seamless expense sharing. It automatically handles tip calculations, formats currency based on the user's locale, and provides an instant breakdown of the total cost per person.
>

---

## Functionality 🧩
- 💰 Automatic local currency formatting (Locale-aware)
- 👥 Dynamic bill splitting with user-friendly picker
- 📈 Custom tip selection (0–100%) via separate navigation screen
- 🔢 Real-time calculation of total and per-person amounts
- ⌨️ Smart keyboard management using FocusState

---

## Screenshots

<div align="center">
  <img src="./Screenshots/1.png" alt="Main screen: calculation" width="325">
  <img src="./Screenshots/2.png" alt="Tip percentage view" width="325">
  <img src="./Screenshots/3.png" alt="Challenge task" width="325">
</div>

---

## Progress 

<div align="center">
  
**Day 16**

*[Overview](https://www.hackingwithswift.com/100/swiftui/16)*

**Day 17**

*[Implementation](https://www.hackingwithswift.com/100/swiftui/17)*

**Day 18**

*[Challenges](https://www.hackingwithswift.com/100/swiftui/18)*

</div>

---

## Challenges

*Instructions taken from [here](https://www.hackingwithswift.com/books/ios-swiftui/wesplit-wrap-up)*

| <div align="center">Challenge</div> | <div align="center">Status</div> |
|:---|:---:|
| 1. Add a header to the third section, saying “Amount per person”. | ✅ |
| 2. Add another section showing the total amount for the check – i.e., the original amount plus tip value, without dividing by the number of people. | ✅ |
| 3. Change the tip percentage picker to show a new screen rather than using a segmented control, and give it a wider range of options – everything from 0% to 100%. Tip: use the range `0..<101` for your range rather than a fixed array. | ✅ |

---

## Installation

1. Clone this repository:  
   ```bash
   git clone https://github.com/gurman-man/100-days-of-swiftUI.git
   ```
2. Open `Projects/01-WeSplit/WeSplit.xcodeproj` in Xcode
3. Run on the simulator or your device

