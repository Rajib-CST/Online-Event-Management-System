package model;
import java.math.BigDecimal; import java.sql.Date; import java.sql.Timestamp; import java.util.List;
public class Booking {
 private int bookingId,userId,vendorId; private String vendorName,eventType,bookingStatus,cancelledBy,cancellationReason; private Date eventDate; private BigDecimal totalAmount,refundAmount; private Timestamp createdAt,cancelledAt; private List<BookingItem> items;
 public int getBookingId(){return bookingId;} public void setBookingId(int v){bookingId=v;} public int getUserId(){return userId;} public void setUserId(int v){userId=v;} public int getVendorId(){return vendorId;} public void setVendorId(int v){vendorId=v;}
 public String getVendorName(){return vendorName;} public void setVendorName(String v){vendorName=v;} public String getEventType(){return eventType;} public void setEventType(String v){eventType=v;} public Date getEventDate(){return eventDate;} public void setEventDate(Date v){eventDate=v;}
 public BigDecimal getTotalAmount(){return totalAmount;} public void setTotalAmount(BigDecimal v){totalAmount=v;} public String getBookingStatus(){return bookingStatus;} public void setBookingStatus(String v){bookingStatus=v;}
 public Timestamp getCreatedAt(){return createdAt;} public void setCreatedAt(Timestamp v){createdAt=v;} public List<BookingItem> getItems(){return items;} public void setItems(List<BookingItem> v){items=v;}
 public String getCancelledBy(){return cancelledBy;} public void setCancelledBy(String v){cancelledBy=v;} public String getCancellationReason(){return cancellationReason;} public void setCancellationReason(String v){cancellationReason=v;}
 public Timestamp getCancelledAt(){return cancelledAt;} public void setCancelledAt(Timestamp v){cancelledAt=v;} public BigDecimal getRefundAmount(){return refundAmount;} public void setRefundAmount(BigDecimal v){refundAmount=v;}
}