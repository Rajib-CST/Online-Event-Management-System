package model;

public class Vendor {
    private int vendorId; private String vendorName; private String email; private String password;
    private String contact; private String address; private String description; private int bankAccountId;
    private String securityQuestion; private String securityAnswer; private String vendorStatus = "ACTIVE";
    private boolean available = true;
    public Vendor() {}
    public Vendor(int vendorId,String vendorName,String email,String contact,String address,String description,int bankAccountId){this.vendorId=vendorId;this.vendorName=vendorName;this.email=email;this.contact=contact;this.address=address;this.description=description;this.bankAccountId=bankAccountId;}
    public int getVendorId(){return vendorId;} public void setVendorId(int v){vendorId=v;}
    public String getVendorName(){return vendorName;} public void setVendorName(String v){vendorName=v;}
    public String getEmail(){return email;} public void setEmail(String v){email=v;}
    public String getPassword(){return password;} public void setPassword(String v){password=v;}
    public String getContact(){return contact;} public void setContact(String v){contact=v;}
    public String getAddress(){return address;} public void setAddress(String v){address=v;}
    public String getDescription(){return description;} public void setDescription(String v){description=v;}
    public int getBankAccountId(){return bankAccountId;} public void setBankAccountId(int v){bankAccountId=v;}
    public String getSecurityQuestion(){return securityQuestion;} public void setSecurityQuestion(String v){securityQuestion=v;}
    public String getSecurityAnswer(){return securityAnswer;} public void setSecurityAnswer(String v){securityAnswer=v;}
    public String getVendorStatus(){return vendorStatus;} public void setVendorStatus(String v){vendorStatus=v;}
    public boolean isAvailable(){return available;} public void setAvailable(boolean v){available=v;}
}