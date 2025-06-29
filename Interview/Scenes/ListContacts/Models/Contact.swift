import Foundation

/*
 Json Contract
[
  {
    "id": 1,
    "name": "Shakira",
    "photoURL": "https://picsum.photos/id/237/200/"
  }
]
*/

struct Contact: Decodable, Equatable {
    let id: Int
    let name: String
    let photoURL: URL
}
