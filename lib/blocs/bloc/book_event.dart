abstract class BookEvent {}

class BookLoadEvent extends BookEvent {
  int? quantity;
  BookLoadEvent({
    this.quantity,
  });
}
