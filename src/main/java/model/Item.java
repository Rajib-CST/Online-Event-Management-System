package model;

public class Item {
    private int itemId;
    private String itemName;
    private String description;

    public Item() {}

    public Item(int itemId, String itemName, String description) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.description = description;
    }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() {
        return "Item{itemId=" + itemId + ", itemName='" + itemName + "'}";
    }
}
