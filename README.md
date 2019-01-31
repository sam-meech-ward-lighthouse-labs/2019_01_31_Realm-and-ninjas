## objective c and swift

Do not import `-Swift.h` into an objective c header file

## CocoaPods

in a podfile, you define which libraries you want. run `pod install` and then you're done.

- `pod init` to create the Podfile. Only do this once per project
- Any time you've modified your Podfile, run `pod install`

#### Git

* sam suggests adding the following to a `.gitignore` file.

```
Pods/
*.xcworkspace
```

## Realm

* realm browser (mac app store)
* sim sim, simpholders, 

https://ios.compass.lighthouselabs.ca/days/w04d4/activities/1059
https://github.com/sam-meech-ward-lighthouse-labs/Swift3-Interoperability/blob/master/README.md
 

_style = style;
_age = age;
_weight = weight;
_birthdate = birthdate;


## NSUserDefaults

better for like a single thing

---

# Official Notes

### Download Tools

1. Download and install Realm Browser from the app store. This will allow students to inspect Realm's db: [https://itunes.apple.com/ca/app/realm-browser/id1007457278?mt=12](https://itunes.apple.com/ca/app/realm-browser/id1007457278?mt=12).

1. To be able to point the Realm Browser at the db file, it is a good idea to download an app to open the file sandbox on their simulator. Here are a couple of free options: 

* [SimSim](https://github.com/dsmelov/simsim)
* [OpenSim](https://github.com/luosheng/OpenSim)
* [SimPholders](https://simpholders.com/)

----

### Introduction to Cocoapods

- Introduce Cocoapods.
- Go [https://cocoapods.org](https://cocoapods.org) and pick a few entries and discuss how to use the search feature and how to find documentation.
- Discuss the pros and cons of using 3rd party dependencies.
- Discuss the pros and cons of using Cocoapods. (You can mention other ways of including dependencies. eg. manual, Carthage, etc.).

---- 

### Cocoapods Install

- Take students through Cocoapods install process. I've added reminders on how to do this below if you need it.
- Installing Cocoapods requires that Ruby be correctly installed. Some students may get stuck with botched Ruby installations. Try to help them, but they can always pair up with other students and fix their Ruby install after the lecture.
- To install Cocoapods run this from CL:

```bash
sudo gem install cocoapods
```

- Create a single view application in Xcode and close the project.
- CD into the root of the project.
- Run:

```bash
pod init
```

- Open the `Podfile` in a text editor or Xcode.
- Make sure you uncomment the line `use_frameworks!` if you are using Swift.
- Go to [https://cocoapods.org](https://cocoapods.org).
- Search for **RealmSwift** and copy the pod file reference to your podfile. Should look like this:

![copy pod data](https://i.imgur.com/mLmcxIu.jpg) 

```bash
# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Cocoapod' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for Cocoapod
  pod 'RealmSwift', '~> 3.0'
end
```

- Run:

```bash
pod install
```

- Open the project from the *.xcworkspace file.
- Add `import RealmSwift` in the `ViewController` file.
- Run to make sure everything builds.
- Note: Be sure to demo how to use the db brower and how to open the app's sandboxed files using one of the tools installed earlier.

---- 

# Basics Of Realm Models

- Make sure you're using **RealmSwift**. 
- The documentation is [here](https://realm.io/docs/swift/latest/)
- Create models like regular Swift classes.

```swift
class Dog: Object {
  @objc dynamic var name = ""
  @objc dynamic var age = 0
}
```

- Subclass Realm's `Object`.
- Properties are marked as `@objc dynamic`.
- Properties that are non-optional must have a default value.
- Supported types: `Bool`, `Int`, `Int8`, `Int16`, `Int32`, `Int64`, `Double`, `Float`, `String`, `Date`, and `Data`. 
- Don't use `CGFloat`.
- `String`, `Date` and `Data` properties can be optional. 
- `Object` properties must be optional. 
- Store *all other* optionals using `RealmOptional`.
- Check the [cheat sheet](https://realm.io/docs/swift/latest/#property-cheatsheet).

## Create (*C*RUD)

```swift
// Define your models like regular Swift classes
class Dog: Object {
  // Optional String, Date, Data properties built in
  @objc dynamic var name: String? // set to nil automatically
  // RealmOptional properties used to make other types optional. 
  // Should always be declared with `let`.
  // No @objc dynamic
  let age = RealmOptional<Int>()
}
class Person: Object {
  @objc dynamic var name = ""
  @objc dynamic var picture: Data? = nil // optionals supported
  let dogs = List<Dog>() // models a one to many relationship
}

```

- Let's create some objects:

```swift
private func createDog(with name: String, and age: Int? = nil)-> Dog {
  let dog = Dog()
  dog.name = name
  dog.age.value = age
  return dog
}

private func createPerson(with name: String, and image: UIImage? = nil)-> Person {
  let person = Person()
  person.name = name
  if let image = image {
    person.picture = UIImageJPEGRepresentation(image, 1.0)
  }
  return person
}

var name = "Dino"
let dog = createDog(with: name)
// To assign to RealmOptional use .value property
dog.age.value = 2

name = "Fred"
let image = UIImage(named: "Fred")
let person = createPerson(with: name, and: image)
person.dogs.append(dog)

let realm = try! Realm()
try! realm.write {
  // Add to the realm inside a write transaction
  realm.add(person)
}

```

## Read (C*R*UD)

- `Realm().objects(_:)` is the most basic fetch.

```swift
private func basicFetch() {
  let realm = try! Realm()
  let results = realm.objects(Person.self)
  // loop through result set
  for person in results {
    print(#line, person.name)
    print(#line, person.dogs.first?.name ?? "no dog or no name")
  }
}
```

- Queries return a `Results` instance.
- `Results` contain a collection of `Object`s.
- `Results` are similar to Swift Array.
- You can loop over `Results` and access them using subscripting syntax.

- Queries can be filtered using `NSPredicate`.

```swift
private func fetchWithFilter() {
  let realm = try! Realm()
  let predicate = NSPredicate(format:"age > 1")
  let results = realm.objects(Dog.self).filter(predicate)
  for dog in results {
    print(#line, dog.name ?? "no name set")
  }
}
```

- Check out this great `NSPredicate` [cheat sheet](https://academy.realm.io/posts/nspredicate-cheatsheet/).

## Realm Update (CR*U*D)

- Update is just a matter of getting a `Object` instance and changing any of its values inside a write transaction.

```swift
let realm = try! Realm()

private func fetchWithFilter()-> Dog? {
  let predicate = NSPredicate(format:"age > 1")
  let results = realm.objects(Dog.self).filter(predicate)
  return results.first
  }

realm.write {
  guard let dog = fetchWithFilter() else { return }
  dog.age.value = dog.age.value + 1
}
```

## Realm Delete (CRU*D*)

- Get a reference to the object or objects you want to delete.
- Inside a `write` transaction, call `delete` on realm and pass it the object(s) you wish to remove. 

```swift

let realm = try! Realm()

private func deleteObject() {
  guard let dog = fetchWithFilter() else { return }
  try! realm.write {
    realm.delete(dog)
  }
}

private func deleteAllPeople() {
  // Pass the `Results` directly to delete everything fetched.
  try! realm.write {
    realm.delete(realm.objects(Person.self))
  }
}

```

### Out of scope

- iOS file system and sandbox.
- `NSUserDefaults`
- Writing to the file system.
- `(NS)FileManager`.

### Include the following links in your lecture notes:

* [Realm Browser](https://itunes.apple.com/ca/app/realm-browser/id1007457278?mt=12)
* [Realm property cheat sheet](https://realm.io/docs/swift/latest/#property-cheatsheet)
* [`NSPredicate` cheat sheet](https://academy.realm.io/posts/nspredicate-cheatsheet/)
* Apps to view the app's documents directory:
  - [SimSim](https://github.com/dsmelov/simsim)
  - [OpenSim](https://github.com/luosheng/OpenSim)
  - [SimPholders](https://simpholders.com/)

