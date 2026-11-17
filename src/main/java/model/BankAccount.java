package model;

import java.math.BigDecimal;

public class BankAccount {
    private int accountId;
    private String accountNumber;
    private String accountHolder;
    private String bankName;
    private BigDecimal balance;
    private String pin;
    private String accountType; // CUSTOMER / VENDOR / ADMIN

    public BankAccount() {}

    public BankAccount(int accountId, String accountNumber, String accountHolder,
                        String bankName, BigDecimal balance, String pin, String accountType) {
        this.accountId = accountId;
        this.accountNumber = accountNumber;
        this.accountHolder = accountHolder;
        this.bankName = bankName;
        this.balance = balance;
        this.pin = pin;
        this.accountType = accountType;
    }

    public int getAccountId() { return accountId; }
    public void setAccountId(int accountId) { this.accountId = accountId; }
    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }
    public String getAccountHolder() { return accountHolder; }
    public void setAccountHolder(String accountHolder) { this.accountHolder = accountHolder; }
    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }
    public BigDecimal getBalance() { return balance; }
    public void setBalance(BigDecimal balance) { this.balance = balance; }
    public String getPin() { return pin; }
    public void setPin(String pin) { this.pin = pin; }
    public String getAccountType() { return accountType; }
    public void setAccountType(String accountType) { this.accountType = accountType; }

    @Override
    public String toString() {
        return "BankAccount{accountNumber='" + accountNumber + "', balance=" + balance + "}";
    }
}
