import RBTree "mo:base/RBTree";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";


actor {

  var question: Text = "Choose your recycling option";
  var selections: RBTree.RBTree<Text, Nat> = RBTree.RBTree(Text.compare);
  var sum = 0;

  public query func getQuestion() : async Text { 
    question 
  };

// query the list of entries and selections for each one
// Example: 
//      * JSON that the frontend will receive using the values above: 
//      * [["Recycle bin","0"],["Bottle","0"],["Electric car","0"],["Vegetarian food","0"]]

    public query func getSelections() : async [(Text, Nat)] {
    
        Iter.toArray(selections.entries())
    
    };



 // This method takes an entry to selection for, updates the data and returns the updated hashmap
// Example input: selection("Motoko")
// Example: 
//      * JSON that the frontend will receive using the values above: 
//      * [["Motoko","1"],["Python","0"],["Rust","0"],["TypeScript","0"]]
    
  public func selection(entry: Text) : async [(Text, Nat)] {

    //Check if the entry already has selections.
    //Note that "selections_for_entry" is of type ?Nat. This is because: 
    // * If the entry is in the RBTree, the RBTree returns a number.
    // * If the entry is not in the RBTree, the RBTree returns `null` for the new entry.
    let selections_for_entry :?Nat = selections.get(entry);
    
    //Need to be explicit about what to do when it is null or a number so every case is taken care of
    let current_selections_for_entry : Nat = switch selections_for_entry {
      case null 0;
      case (?Nat) Nat;
    };

    //once we have the number of selections, update the selections for the entry
    selections.put(entry, current_selections_for_entry + 1);

    //Return the number of selections as an array (so frontend can display it)
    Iter.toArray(selections.entries())
  };

  public func resetSelections() : async [(Text, Nat)] {
      selections.put("Bottle", 0);
      selections.put("Recycle bin", 0);
      selections.put("Electric car", 0);
      selections.put("Vegetarian food", 0);
      Iter.toArray(selections.entries())
  };

};
