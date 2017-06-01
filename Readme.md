Contact Browser
---------------
An simple app that displays the user’s contacts in a table view. Each cell displays first name, last name, and image. Tapping a contact should push a view controller that shows the contact’s home address on a map view.

* Doesn't' use Interface Builder, Story Boards, or UITableViewController.

* For fun I put the model in a separate library. I find it keeps the model clean but was not required for this project. This will also make it easier to add more third party code from swift package manager.

* The search for items defaults to displaying the default contents items.

* TableViewAdaptor is very flexible, reusable, and type safe, due to generics, piece of code. It allows different cell types
for each section. This class does not know anything about the specific Cell or specific Model, but generically routes the
information to the supporting classes. This may be a bit more complicated than was required for this specific use, but
I think this is a very cool class. One addition, I made was to add clicking. Notice how, I was able to handle the click
very cleanly in the select method, and the configure method is responsible for the updating the checkmark.

* Recommend running it on a real device. As the Simulator data does not have images.

* Some records on my device did not have values for the requested properties.

