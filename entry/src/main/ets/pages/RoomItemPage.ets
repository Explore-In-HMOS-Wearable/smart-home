import { RoomItemView } from '../views/RoomItemView';

@Builder
export function RoomItemPageBuilder() {
  RoomItemPage()
}

@Component
struct RoomItemPage {
  build() {
    RelativeContainer() {
      RoomItemView()
    }
  }
}