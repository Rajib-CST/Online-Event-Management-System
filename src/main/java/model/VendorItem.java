package model;
import java.math.BigDecimal;
public class VendorItem {
 private int vendorItemId,vendorId,itemId; private String itemName; private BigDecimal price; private int stock; private boolean available=true;
 public VendorItem(){}
 public VendorItem(int a,int b,int c,String d,BigDecimal e,int f){vendorItemId=a;vendorId=b;itemId=c;itemName=d;price=e;stock=f;}
 public int getVendorItemId(){return vendorItemId;} public void setVendorItemId(int v){vendorItemId=v;}
 public int getVendorId(){return vendorId;} public void setVendorId(int v){vendorId=v;}
 public int getItemId(){return itemId;} public void setItemId(int v){itemId=v;}
 public String getItemName(){return itemName;} public void setItemName(String v){itemName=v;}
 public BigDecimal getPrice(){return price;} public void setPrice(BigDecimal v){price=v;}
 public int getStock(){return stock;} public void setStock(int v){stock=v;}
 public boolean isAvailable(){return available;} public void setAvailable(boolean v){available=v;}
}