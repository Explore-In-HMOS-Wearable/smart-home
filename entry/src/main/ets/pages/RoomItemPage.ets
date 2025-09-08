import { RoomItemView } from '../views/RoomItemView';

@Entry
@Component
struct RoomItemPage {
  build() {
    RelativeContainer() {
      RoomItemView()
    }
  }
}