package model;

public class Room {
    private int id;
    private int roomId;
    private int hotelId;
    private String roomName;
    private String roomTypeName;
    private String description;
    private double price;
    private int maxAdults;
    private int maxChildren;
    private int area;
    private String image;
    private boolean hasBathtub;
    private boolean hasBreakfast;
    private boolean isRecommended;

    // Constructor mặc định không tham số
    public Room() {
    }

    // Constructor đầy đủ tham số
    public Room(int id, int roomId, int hotelId, String roomName, String roomTypeName, String description,
                double price, int maxAdults, int maxChildren, int area, String image,
                boolean hasBathtub, boolean hasBreakfast, boolean isRecommended) {
        this.id = id;
        this.roomId = roomId;
        this.hotelId = hotelId;
        this.roomName = roomName;
        this.roomTypeName = roomTypeName;
        this.description = description;
        this.price = price;
        this.maxAdults = maxAdults;
        this.maxChildren = maxChildren;
        this.area = area;
        this.image = image;
        this.hasBathtub = hasBathtub;
        this.hasBreakfast = hasBreakfast;
        this.isRecommended = isRecommended;
    }

    // Hệ thống Getter và Setter bắt buộc phải có để DAO và Controller gọi đến
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public int getHotelId() { return hotelId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getMaxAdults() { return maxAdults; }
    public void setMaxAdults(int maxAdults) { this.maxAdults = maxAdults; }

    public int getMaxChildren() { return maxChildren; }
    public void setMaxChildren(int maxChildren) { this.maxChildren = maxChildren; }

    public int getArea() { return area; }
    public void setArea(int area) { this.area = area; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public boolean isHasBathtub() { return hasBathtub; }
    public void setHasBathtub(boolean hasBathtub) { this.hasBathtub = hasBathtub; }

    public boolean isHasBreakfast() { return hasBreakfast; }
    public void setHasBreakfast(boolean hasBreakfast) { this.hasBreakfast = hasBreakfast; }

    public boolean isRecommended() { return isRecommended; }
    public void setRecommended(boolean recommended) { this.isRecommended = recommended; }
}